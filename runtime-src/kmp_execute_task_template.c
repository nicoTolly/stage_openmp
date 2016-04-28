//-----------------------------------------------------------------------------
// __kmp_execute_tasks_template: Choose and execute tasks until either the condition
// is statisfied (return true) or there are none left (return false).
// final_spin is TRUE if this is the spin at the release barrier.
// thread_finished indicates whether the thread is finished executing all
// the tasks it has on its deque, and is at the release barrier.
// spinner is the location on which to spin.
// spinner == NULL means only execute a single task and return.
// checker is the value to check to terminate the spin.
template <class C>
static inline int __kmp_execute_tasks_template(kmp_info_t *thread, kmp_int32 gtid, C *flag, int final_spin, 
                                               int *thread_finished
                                               USE_ITT_BUILD_ARG(void * itt_sync_obj), kmp_int32 is_constrained)
{
    kmp_task_team_t *     task_team;
    kmp_thread_data_t *   threads_data;
    kmp_task_t *          task;
    kmp_taskdata_t *      current_task = thread -> th.th_current_task;
    volatile kmp_uint32 * unfinished_threads;
    kmp_int32             nthreads, last_stolen, k, tid;

    KMP_DEBUG_ASSERT( __kmp_tasking_mode != tskm_immediate_exec );
    KMP_DEBUG_ASSERT( thread == __kmp_threads[ gtid ] );

    task_team = thread -> th.th_task_team;
    if (task_team == NULL) return FALSE;

    KA_TRACE(15, ("__kmp_execute_tasks_template(enter): T#%d final_spin=%d *thread_finished=%d\n",
                  gtid, final_spin, *thread_finished) );

    threads_data = (kmp_thread_data_t *)TCR_PTR(task_team -> tt.tt_threads_data);
    KMP_DEBUG_ASSERT( threads_data != NULL );

    nthreads = task_team -> tt.tt_nproc;
    unfinished_threads = &(task_team -> tt.tt_unfinished_threads);
#if OMP_41_ENABLED
    KMP_DEBUG_ASSERT( nthreads > 1 || task_team->tt.tt_found_proxy_tasks);
#else
    KMP_DEBUG_ASSERT( nthreads > 1 );
#endif
    KMP_DEBUG_ASSERT( TCR_4((int)*unfinished_threads) >= 0 );

    // Choose tasks from our own work queue.
    start:
    while (( task = __kmp_remove_my_task( thread, gtid, task_team, is_constrained )) != NULL ) {
#if USE_ITT_BUILD && USE_ITT_NOTIFY
        if ( __itt_sync_create_ptr || KMP_ITT_DEBUG ) {
            if ( itt_sync_obj == NULL ) {
                // we are at fork barrier where we could not get the object reliably
                itt_sync_obj  = __kmp_itt_barrier_object( gtid, bs_forkjoin_barrier );
            }
            __kmp_itt_task_starting( itt_sync_obj );
        }
#endif /* USE_ITT_BUILD && USE_ITT_NOTIFY */
        __kmp_invoke_task( gtid, task, current_task );
#if USE_ITT_BUILD
        if ( itt_sync_obj != NULL )
            __kmp_itt_task_finished( itt_sync_obj );
#endif /* USE_ITT_BUILD */

        // If this thread is only partway through the barrier and the condition
        // is met, then return now, so that the barrier gather/release pattern can proceed.
        // If this thread is in the last spin loop in the barrier, waiting to be
        // released, we know that the termination condition will not be satisified,
        // so don't waste any cycles checking it.
        if (flag == NULL || (!final_spin && flag->done_check())) {
            KA_TRACE(15, ("__kmp_execute_tasks_template(exit #1): T#%d spin condition satisfied\n", gtid) );
            return TRUE;
        }
        if (thread->th.th_task_team == NULL) break;
        KMP_YIELD( __kmp_library == library_throughput );   // Yield before executing next task
    }

    // This thread's work queue is empty.  If we are in the final spin loop
    // of the barrier, check and see if the termination condition is satisfied.
#if OMP_41_ENABLED
    // The work queue may be empty but there might be proxy tasks still executing
    if (final_spin && TCR_4(current_task -> td_incomplete_child_tasks) == 0) 
#else
    if (final_spin) 
#endif
    {
        // First, decrement the #unfinished threads, if that has not already
        // been done.  This decrement might be to the spin location, and
        // result in the termination condition being satisfied.
        if (! *thread_finished) {
            kmp_uint32 count;

            count = KMP_TEST_THEN_DEC32( (kmp_int32 *)unfinished_threads ) - 1;
            KA_TRACE(20, ("__kmp_execute_tasks_template(dec #1): T#%d dec unfinished_threads to %d task_team=%p\n",
                          gtid, count, task_team) );
            *thread_finished = TRUE;
        }

        // It is now unsafe to reference thread->th.th_team !!!
        // Decrementing task_team->tt.tt_unfinished_threads can allow the master
        // thread to pass through the barrier, where it might reset each thread's
        // th.th_team field for the next parallel region.
        // If we can steal more work, we know that this has not happened yet.
        if (flag != NULL && flag->done_check()) {
            KA_TRACE(15, ("__kmp_execute_tasks_template(exit #2): T#%d spin condition satisfied\n", gtid) );
            return TRUE;
        }
    }

    if (thread->th.th_task_team == NULL) return FALSE;
#if OMP_41_ENABLED
    // check if there are other threads to steal from, otherwise go back
    if ( nthreads  == 1 )
        goto start;
#endif

    // Try to steal from the last place I stole from successfully.
    tid = thread -> th.th_info.ds.ds_tid;//__kmp_tid_from_gtid( gtid );
    last_stolen = threads_data[ tid ].td.td_deque_last_stolen;

    if (last_stolen != -1) {
        kmp_info_t *other_thread = threads_data[last_stolen].td.td_thr;

        while ((task = __kmp_steal_task( other_thread, gtid, task_team, unfinished_threads,
                                         thread_finished, is_constrained )) != NULL)
        {
#if USE_ITT_BUILD && USE_ITT_NOTIFY
            if ( __itt_sync_create_ptr || KMP_ITT_DEBUG ) {
                if ( itt_sync_obj == NULL ) {
                    // we are at fork barrier where we could not get the object reliably
                    itt_sync_obj  = __kmp_itt_barrier_object( gtid, bs_forkjoin_barrier );
                }
                __kmp_itt_task_starting( itt_sync_obj );
            }
#endif /* USE_ITT_BUILD && USE_ITT_NOTIFY */
            __kmp_invoke_task( gtid, task, current_task );
#if USE_ITT_BUILD
            if ( itt_sync_obj != NULL )
                __kmp_itt_task_finished( itt_sync_obj );
#endif /* USE_ITT_BUILD */

            // Check to see if this thread can proceed.
            if (flag == NULL || (!final_spin && flag->done_check())) {
                KA_TRACE(15, ("__kmp_execute_tasks_template(exit #3): T#%d spin condition satisfied\n",
                              gtid) );
                return TRUE;
            }

            if (thread->th.th_task_team == NULL) break;
            KMP_YIELD( __kmp_library == library_throughput );   // Yield before executing next task
            // If the execution of the stolen task resulted in more tasks being
            // placed on our run queue, then restart the whole process.
            if (TCR_4(threads_data[ tid ].td.td_deque_ntasks) != 0) {
                KA_TRACE(20, ("__kmp_execute_tasks_template: T#%d stolen task spawned other tasks, restart\n",
                              gtid) );
                goto start;
            }
        }

        // Don't give priority to stealing from this thread anymore.
        threads_data[ tid ].td.td_deque_last_stolen = -1;

        // The victims's work queue is empty.  If we are in the final spin loop
        // of the barrier, check and see if the termination condition is satisfied.
#if OMP_41_ENABLED
        // The work queue may be empty but there might be proxy tasks still executing
        if (final_spin && TCR_4(current_task -> td_incomplete_child_tasks) == 0) 
#else
        if (final_spin) 
#endif
        {
            // First, decrement the #unfinished threads, if that has not already
            // been done.  This decrement might be to the spin location, and
            // result in the termination condition being satisfied.
            if (! *thread_finished) {
                kmp_uint32 count;

                count = KMP_TEST_THEN_DEC32( (kmp_int32 *)unfinished_threads ) - 1;
                KA_TRACE(20, ("__kmp_execute_tasks_template(dec #2): T#%d dec unfinished_threads to %d "
                              "task_team=%p\n", gtid, count, task_team) );
                *thread_finished = TRUE;
            }

            // If __kmp_tasking_mode != tskm_immediate_exec
            // then it is now unsafe to reference thread->th.th_team !!!
            // Decrementing task_team->tt.tt_unfinished_threads can allow the master
            // thread to pass through the barrier, where it might reset each thread's
            // th.th_team field for the next parallel region.
            // If we can steal more work, we know that this has not happened yet.
            if (flag != NULL && flag->done_check()) {
                KA_TRACE(15, ("__kmp_execute_tasks_template(exit #4): T#%d spin condition satisfied\n",
                              gtid) );
                return TRUE;
            }
        }
        if (thread->th.th_task_team == NULL) return FALSE;
    }

    // Find a different thread to steal work from.  Pick a random thread.
    // My initial plan was to cycle through all the threads, and only return
    // if we tried to steal from every thread, and failed.  Arch says that's
    // not such a great idea.
    // GEH - need yield code in this loop for throughput library mode?
    new_victim:
    k = __kmp_get_random( thread ) % (nthreads - 1);
    if ( k >= thread -> th.th_info.ds.ds_tid ) {
        ++k;               // Adjusts random distribution to exclude self
    }
    {
        kmp_info_t *other_thread = threads_data[k].td.td_thr;
        int first;

        // There is a slight chance that __kmp_enable_tasking() did not wake up
        // all threads waiting at the barrier.  If this thread is sleeping, then
        // wake it up.  Since we were going to pay the cache miss penalty
        // for referencing another thread's kmp_info_t struct anyway, the check
        // shouldn't cost too much performance at this point.
        // In extra barrier mode, tasks do not sleep at the separate tasking
        // barrier, so this isn't a problem.
        if ( ( __kmp_tasking_mode == tskm_task_teams ) &&
             (__kmp_dflt_blocktime != KMP_MAX_BLOCKTIME) &&
             (TCR_PTR(other_thread->th.th_sleep_loc) != NULL))
        {
            __kmp_null_resume_wrapper(__kmp_gtid_from_thread(other_thread), other_thread->th.th_sleep_loc);
            // A sleeping thread should not have any tasks on it's queue.
            // There is a slight possibility that it resumes, steals a task from
            // another thread, which spawns more tasks, all in the time that it takes
            // this thread to check => don't write an assertion that the victim's
            // queue is empty.  Try stealing from a different thread.
            goto new_victim;
        }

        // Now try to steal work from the selected thread
        first = TRUE;
        while ((task = __kmp_steal_task( other_thread, gtid, task_team, unfinished_threads,
                                         thread_finished, is_constrained )) != NULL)
        {
#if USE_ITT_BUILD && USE_ITT_NOTIFY
            if ( __itt_sync_create_ptr || KMP_ITT_DEBUG ) {
                if ( itt_sync_obj == NULL ) {
                    // we are at fork barrier where we could not get the object reliably
                    itt_sync_obj  = __kmp_itt_barrier_object( gtid, bs_forkjoin_barrier );
                }
                __kmp_itt_task_starting( itt_sync_obj );
            }
#endif /* USE_ITT_BUILD && USE_ITT_NOTIFY */
            __kmp_invoke_task( gtid, task, current_task );
#if USE_ITT_BUILD
            if ( itt_sync_obj != NULL )
                __kmp_itt_task_finished( itt_sync_obj );
#endif /* USE_ITT_BUILD */

            // Try stealing from this victim again, in the future.
            if (first) {
                threads_data[ tid ].td.td_deque_last_stolen = k;
                first = FALSE;
            }

            // Check to see if this thread can proceed.
            if (flag == NULL || (!final_spin && flag->done_check())) {
                KA_TRACE(15, ("__kmp_execute_tasks_template(exit #5): T#%d spin condition satisfied\n",
                              gtid) );
                return TRUE;
            }
            if (thread->th.th_task_team == NULL) break;
            KMP_YIELD( __kmp_library == library_throughput );   // Yield before executing next task

            // If the execution of the stolen task resulted in more tasks being
            // placed on our run queue, then restart the whole process.
            if (TCR_4(threads_data[ tid ].td.td_deque_ntasks) != 0) {
                KA_TRACE(20, ("__kmp_execute_tasks_template: T#%d stolen task spawned other tasks, restart\n",
                              gtid) );
                goto start;
            }
        }

        // The victims's work queue is empty.  If we are in the final spin loop
        // of the barrier, check and see if the termination condition is satisfied.
        // Going on and finding a new victim to steal from is expensive, as it
        // involves a lot of cache misses, so we definitely want to re-check the
        // termination condition before doing that.
#if OMP_41_ENABLED
        // The work queue may be empty but there might be proxy tasks still executing
        if (final_spin && TCR_4(current_task -> td_incomplete_child_tasks) == 0) 
#else
        if (final_spin) 
#endif
        {
            // First, decrement the #unfinished threads, if that has not already
            // been done.  This decrement might be to the spin location, and
            // result in the termination condition being satisfied.
            if (! *thread_finished) {
                kmp_uint32 count;

                count = KMP_TEST_THEN_DEC32( (kmp_int32 *)unfinished_threads ) - 1;
                KA_TRACE(20, ("__kmp_execute_tasks_template(dec #3): T#%d dec unfinished_threads to %d; "
                              "task_team=%p\n",
                              gtid, count, task_team) );
                *thread_finished = TRUE;
            }

            // If __kmp_tasking_mode != tskm_immediate_exec,
            // then it is now unsafe to reference thread->th.th_team !!!
            // Decrementing task_team->tt.tt_unfinished_threads can allow the master
            // thread to pass through the barrier, where it might reset each thread's
            // th.th_team field for the next parallel region.
            // If we can steal more work, we know that this has not happened yet.
            if (flag != NULL && flag->done_check()) {
                KA_TRACE(15, ("__kmp_execute_tasks_template(exit #6): T#%d spin condition satisfied\n", gtid) );
                return TRUE;
            }
        }
        if (thread->th.th_task_team == NULL) return FALSE;
    }

    KA_TRACE(15, ("__kmp_execute_tasks_template(exit #7): T#%d can't find work\n", gtid) );
    return FALSE;
}
