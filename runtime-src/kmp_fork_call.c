/* most of the work for a fork */
/* return true if we really went parallel, false if serialized */
int
__kmp_fork_call(
    ident_t   * loc,
    int         gtid,
    enum fork_context_e  call_context, // Intel, GNU, ...
    kmp_int32   argc,
#if OMPT_SUPPORT
    void       *unwrapped_task,
#endif
    microtask_t microtask,
    launch_t    invoker,
/* TODO: revert workaround for Intel(R) 64 tracker #96 */
#if (KMP_ARCH_X86_64 || KMP_ARCH_ARM || KMP_ARCH_AARCH64) && KMP_OS_LINUX
    va_list   * ap
#else
    va_list     ap
#endif
    )
{
    void          **argv;
    int             i;
    int             master_tid;
    int             master_this_cons;
    kmp_team_t     *team;
    kmp_team_t     *parent_team;
    kmp_info_t     *master_th;
    kmp_root_t     *root;
    int             nthreads;
    int             master_active;
    int             master_set_numthreads;
    int             level;
#if OMP_40_ENABLED
    int             active_level;
    int             teams_level;
#endif
#if KMP_NESTED_HOT_TEAMS
    kmp_hot_team_ptr_t **p_hot_teams;
#endif
    { // KMP_TIME_BLOCK
    KMP_TIME_DEVELOPER_BLOCK(KMP_fork_call);
    KMP_COUNT_VALUE(OMP_PARALLEL_args, argc);

    KA_TRACE( 20, ("__kmp_fork_call: enter T#%d\n", gtid ));
    if ( __kmp_stkpadding > 0 &&  __kmp_root[gtid] != NULL ) {
        /* Some systems prefer the stack for the root thread(s) to start with */
        /* some gap from the parent stack to prevent false sharing. */
        void *dummy = KMP_ALLOCA(__kmp_stkpadding);
        /* These 2 lines below are so this does not get optimized out */
        if ( __kmp_stkpadding > KMP_MAX_STKPADDING )
            __kmp_stkpadding += (short)((kmp_int64)dummy);
    }

    /* initialize if needed */
    KMP_DEBUG_ASSERT( __kmp_init_serial ); // AC: potentially unsafe, not in sync with shutdown
    if( ! TCR_4(__kmp_init_parallel) )
        __kmp_parallel_initialize();

    /* setup current data */
    master_th     = __kmp_threads[ gtid ]; // AC: potentially unsafe, not in sync with shutdown
    parent_team   = master_th->th.th_team;
    master_tid    = master_th->th.th_info.ds.ds_tid;
    master_this_cons = master_th->th.th_local.this_construct;
    root          = master_th->th.th_root;
    master_active = root->r.r_active;
    master_set_numthreads = master_th->th.th_set_nproc;

#if OMPT_SUPPORT
    ompt_parallel_id_t ompt_parallel_id;
    ompt_task_id_t ompt_task_id;
    ompt_frame_t *ompt_frame;
    ompt_task_id_t my_task_id;
    ompt_parallel_id_t my_parallel_id;

    if (ompt_enabled) {
        ompt_parallel_id = __ompt_parallel_id_new(gtid);
        ompt_task_id = __ompt_get_task_id_internal(0);
        ompt_frame = __ompt_get_task_frame_internal(0);
    }
#endif

    // Nested level will be an index in the nested nthreads array
    level         = parent_team->t.t_level;
#if OMP_40_ENABLED
    active_level  = parent_team->t.t_active_level; // is used to launch non-serial teams even if nested is not allowed
    teams_level    = master_th->th.th_teams_level; // needed to check nesting inside the teams
#endif
#if KMP_NESTED_HOT_TEAMS
    p_hot_teams   = &master_th->th.th_hot_teams;
    if( *p_hot_teams == NULL && __kmp_hot_teams_max_level > 0 ) {
        *p_hot_teams = (kmp_hot_team_ptr_t*)__kmp_allocate(
                sizeof(kmp_hot_team_ptr_t) * __kmp_hot_teams_max_level);
        (*p_hot_teams)[0].hot_team = root->r.r_hot_team;
        (*p_hot_teams)[0].hot_team_nth = 1; // it is either actual or not needed (when active_level > 0)
    }
#endif

#if OMPT_SUPPORT
    if (ompt_enabled &&
        ompt_callbacks.ompt_callback(ompt_event_parallel_begin)) {
        int team_size = master_set_numthreads;

        ompt_callbacks.ompt_callback(ompt_event_parallel_begin)(
            ompt_task_id, ompt_frame, ompt_parallel_id,
            team_size, unwrapped_task, OMPT_INVOKER(call_context));
    }
#endif

    master_th->th.th_ident = loc;

#if OMP_40_ENABLED
    if ( master_th->th.th_teams_microtask &&
         ap && microtask != (microtask_t)__kmp_teams_master && level == teams_level ) {
        // AC: This is start of parallel that is nested inside teams construct.
        //     The team is actual (hot), all workers are ready at the fork barrier.
        //     No lock needed to initialize the team a bit, then free workers.
        parent_team->t.t_ident = loc;
        parent_team->t.t_argc  = argc;
        argv = (void**)parent_team->t.t_argv;
        for( i=argc-1; i >= 0; --i )
/* TODO: revert workaround for Intel(R) 64 tracker #96 */
#if (KMP_ARCH_X86_64 || KMP_ARCH_ARM || KMP_ARCH_AARCH64) && KMP_OS_LINUX
            *argv++ = va_arg( *ap, void * );
#else
            *argv++ = va_arg( ap, void * );
#endif
        /* Increment our nested depth levels, but not increase the serialization */
        if ( parent_team == master_th->th.th_serial_team ) {
            // AC: we are in serialized parallel
            __kmpc_serialized_parallel(loc, gtid);
            KMP_DEBUG_ASSERT( parent_team->t.t_serialized > 1 );
            parent_team->t.t_serialized--; // AC: need this in order enquiry functions
                                           //     work correctly, will restore at join time

#if OMPT_SUPPORT
            void *dummy;
            void **exit_runtime_p;

            ompt_lw_taskteam_t lw_taskteam;

            if (ompt_enabled) {
                __ompt_lw_taskteam_init(&lw_taskteam, master_th, gtid,
                    unwrapped_task, ompt_parallel_id);
                lw_taskteam.ompt_task_info.task_id = __ompt_task_id_new(gtid);
                exit_runtime_p = &(lw_taskteam.ompt_task_info.frame.exit_runtime_frame);

                __ompt_lw_taskteam_link(&lw_taskteam, master_th);

#if OMPT_TRACE
                /* OMPT implicit task begin */
                my_task_id = lw_taskteam.ompt_task_info.task_id;
                my_parallel_id = parent_team->t.ompt_team_info.parallel_id;
                if (ompt_callbacks.ompt_callback(ompt_event_implicit_task_begin)) {
                    ompt_callbacks.ompt_callback(ompt_event_implicit_task_begin)(
                        my_parallel_id, my_task_id);
                }
#endif

                /* OMPT state */
                master_th->th.ompt_thread_info.state = ompt_state_work_parallel;
            } else {
                exit_runtime_p = &dummy;
            }
#endif

            {
                KMP_TIME_BLOCK(OMP_work);
                __kmp_invoke_microtask( microtask, gtid, 0, argc, parent_team->t.t_argv
#if OMPT_SUPPORT
                                        , exit_runtime_p
#endif
                                        );
            }

#if OMPT_SUPPORT
            if (ompt_enabled) {
#if OMPT_TRACE
                lw_taskteam.ompt_task_info.frame.exit_runtime_frame = 0;

                if (ompt_callbacks.ompt_callback(ompt_event_implicit_task_end)) {
                    ompt_callbacks.ompt_callback(ompt_event_implicit_task_end)(
                        ompt_parallel_id, ompt_task_id);
                }

                __ompt_lw_taskteam_unlink(master_th);
                // reset clear the task id only after unlinking the task
                lw_taskteam.ompt_task_info.task_id = ompt_task_id_none;
#endif

                if (ompt_callbacks.ompt_callback(ompt_event_parallel_end)) {
                    ompt_callbacks.ompt_callback(ompt_event_parallel_end)(
                        ompt_parallel_id, ompt_task_id,
                        OMPT_INVOKER(call_context));
                }
                master_th->th.ompt_thread_info.state = ompt_state_overhead;
            }
#endif
            return TRUE;
        }

        parent_team->t.t_pkfn  = microtask;
#if OMPT_SUPPORT
        parent_team->t.ompt_team_info.microtask = unwrapped_task;
#endif
        parent_team->t.t_invoke = invoker;
        KMP_TEST_THEN_INC32( (kmp_int32*) &root->r.r_in_parallel );
        parent_team->t.t_active_level ++;
        parent_team->t.t_level ++;

        /* Change number of threads in the team if requested */
        if ( master_set_numthreads ) {   // The parallel has num_threads clause
            if ( master_set_numthreads < master_th->th.th_teams_size.nth ) {
                // AC: only can reduce the number of threads dynamically, cannot increase
                kmp_info_t **other_threads = parent_team->t.t_threads;
                parent_team->t.t_nproc = master_set_numthreads;
                for ( i = 0; i < master_set_numthreads; ++i ) {
                    other_threads[i]->th.th_team_nproc = master_set_numthreads;
                }
                // Keep extra threads hot in the team for possible next parallels
            }
            master_th->th.th_set_nproc = 0;
        }

#if USE_DEBUGGER
    if ( __kmp_debugging ) {    // Let debugger override number of threads.
        int nth = __kmp_omp_num_threads( loc );
        if ( nth > 0 ) {        // 0 means debugger does not want to change number of threads.
            master_set_numthreads = nth;
        }; // if
    }; // if
#endif

        KF_TRACE( 10, ( "__kmp_fork_call: before internal fork: root=%p, team=%p, master_th=%p, gtid=%d\n", root, parent_team, master_th, gtid ) );
        __kmp_internal_fork( loc, gtid, parent_team );
        KF_TRACE( 10, ( "__kmp_fork_call: after internal fork: root=%p, team=%p, master_th=%p, gtid=%d\n", root, parent_team, master_th, gtid ) );

        /* Invoke microtask for MASTER thread */
        KA_TRACE( 20, ("__kmp_fork_call: T#%d(%d:0) invoke microtask = %p\n",
                    gtid, parent_team->t.t_id, parent_team->t.t_pkfn ) );

        {
            KMP_TIME_BLOCK(OMP_work);
            if (! parent_team->t.t_invoke( gtid )) {
                KMP_ASSERT2( 0, "cannot invoke microtask for MASTER thread" );
            }
        }
        KA_TRACE( 20, ("__kmp_fork_call: T#%d(%d:0) done microtask = %p\n",
            gtid, parent_team->t.t_id, parent_team->t.t_pkfn ) );
        KMP_MB();       /* Flush all pending memory write invalidates.  */

        KA_TRACE( 20, ("__kmp_fork_call: parallel exit T#%d\n", gtid ));

        return TRUE;
    } // Parallel closely nested in teams construct
#endif /* OMP_40_ENABLED */

#if KMP_DEBUG
    if ( __kmp_tasking_mode != tskm_immediate_exec ) {
        KMP_DEBUG_ASSERT(master_th->th.th_task_team == parent_team->t.t_task_team[master_th->th.th_task_state]);
    }
#endif

    if ( parent_team->t.t_active_level >= master_th->th.th_current_task->td_icvs.max_active_levels ) {
        nthreads = 1;
    } else {
#if OMP_40_ENABLED
        int enter_teams = ((ap==NULL && active_level==0)||(ap && teams_level>0 && teams_level==level));
#endif
        nthreads = master_set_numthreads ?
            master_set_numthreads : get__nproc_2( parent_team, master_tid ); // TODO: get nproc directly from current task

        // Check if we need to take forkjoin lock? (no need for serialized parallel out of teams construct).
        // This code moved here from __kmp_reserve_threads() to speedup nested serialized parallels.
        if (nthreads > 1) {
            if ( ( !get__nested(master_th) && (root->r.r_in_parallel
#if OMP_40_ENABLED
                && !enter_teams
#endif /* OMP_40_ENABLED */
            ) ) || ( __kmp_library == library_serial ) ) {
                KC_TRACE( 10, ( "__kmp_fork_call: T#%d serializing team; requested %d threads\n",
                                gtid, nthreads ));
                nthreads = 1;
            }
        }
        if ( nthreads > 1 ) {
            /* determine how many new threads we can use */
            __kmp_acquire_bootstrap_lock( &__kmp_forkjoin_lock );

            nthreads = __kmp_reserve_threads(root, parent_team, master_tid, nthreads
#if OMP_40_ENABLED
/* AC: If we execute teams from parallel region (on host), then teams should be created
   but each can only have 1 thread if nesting is disabled. If teams called from serial region,
   then teams and their threads should be created regardless of the nesting setting. */
                                         , enter_teams
#endif /* OMP_40_ENABLED */
                                         );
            if ( nthreads == 1 ) {
                // Free lock for single thread execution here;
                // for multi-thread execution it will be freed later
                // after team of threads created and initialized
                __kmp_release_bootstrap_lock( &__kmp_forkjoin_lock );
            }
        }
    }
    KMP_DEBUG_ASSERT( nthreads > 0 );

    /* If we temporarily changed the set number of threads then restore it now */
    master_th->th.th_set_nproc = 0;

    /* create a serialized parallel region? */
    if ( nthreads == 1 ) {
        /* josh todo: hypothetical question: what do we do for OS X*? */
#if KMP_OS_LINUX && ( KMP_ARCH_X86 || KMP_ARCH_X86_64 || KMP_ARCH_ARM || KMP_ARCH_AARCH64)
        void *   args[ argc ];
#else
        void * * args = (void**) KMP_ALLOCA( argc * sizeof( void * ) );
#endif /* KMP_OS_LINUX && ( KMP_ARCH_X86 || KMP_ARCH_X86_64 || KMP_ARCH_ARM || KMP_ARCH_AARCH64) */

        KA_TRACE( 20, ("__kmp_fork_call: T#%d serializing parallel region\n", gtid ));

        __kmpc_serialized_parallel(loc, gtid);

        if ( call_context == fork_context_intel ) {
            /* TODO this sucks, use the compiler itself to pass args! :) */
            master_th->th.th_serial_team->t.t_ident = loc;
#if OMP_40_ENABLED
            if ( !ap ) {
                // revert change made in __kmpc_serialized_parallel()
                master_th->th.th_serial_team->t.t_level--;
                // Get args from parent team for teams construct

#if OMPT_SUPPORT
                void *dummy;
                void **exit_runtime_p;

                ompt_lw_taskteam_t lw_taskteam;

                if (ompt_enabled) {
                    __ompt_lw_taskteam_init(&lw_taskteam, master_th, gtid,
                        unwrapped_task, ompt_parallel_id);
                    lw_taskteam.ompt_task_info.task_id = __ompt_task_id_new(gtid);
                    exit_runtime_p = &(lw_taskteam.ompt_task_info.frame.exit_runtime_frame);

                    __ompt_lw_taskteam_link(&lw_taskteam, master_th);

#if OMPT_TRACE
                    my_task_id = lw_taskteam.ompt_task_info.task_id;
                    if (ompt_callbacks.ompt_callback(ompt_event_implicit_task_begin)) {
                        ompt_callbacks.ompt_callback(ompt_event_implicit_task_begin)(
                            ompt_parallel_id, my_task_id);
                    }
#endif

                    /* OMPT state */
                    master_th->th.ompt_thread_info.state = ompt_state_work_parallel;
                } else {
                    exit_runtime_p = &dummy;
                }
#endif

                {
                    KMP_TIME_BLOCK(OMP_work);
                    __kmp_invoke_microtask( microtask, gtid, 0, argc, parent_team->t.t_argv
#if OMPT_SUPPORT
                        , exit_runtime_p
#endif
                    );
                }

#if OMPT_SUPPORT
                if (ompt_enabled) {
                    lw_taskteam.ompt_task_info.frame.exit_runtime_frame = 0;

#if OMPT_TRACE
                    if (ompt_callbacks.ompt_callback(ompt_event_implicit_task_end)) {
                        ompt_callbacks.ompt_callback(ompt_event_implicit_task_end)(
                            ompt_parallel_id, ompt_task_id);
                    }
#endif

                    __ompt_lw_taskteam_unlink(master_th);
                    // reset clear the task id only after unlinking the task
                    lw_taskteam.ompt_task_info.task_id = ompt_task_id_none;

                    if (ompt_callbacks.ompt_callback(ompt_event_parallel_end)) {
                        ompt_callbacks.ompt_callback(ompt_event_parallel_end)(
                            ompt_parallel_id, ompt_task_id,
                            OMPT_INVOKER(call_context));
                    }
                    master_th->th.ompt_thread_info.state = ompt_state_overhead;
                }
#endif
            } else if ( microtask == (microtask_t)__kmp_teams_master ) {
                KMP_DEBUG_ASSERT( master_th->th.th_team == master_th->th.th_serial_team );
                team = master_th->th.th_team;
                //team->t.t_pkfn = microtask;
                team->t.t_invoke = invoker;
                __kmp_alloc_argv_entries( argc, team, TRUE );
                team->t.t_argc = argc;
                argv = (void**) team->t.t_argv;
                if ( ap ) {
                    for( i=argc-1; i >= 0; --i )
// TODO: revert workaround for Intel(R) 64 tracker #96
# if (KMP_ARCH_X86_64 || KMP_ARCH_ARM || KMP_ARCH_AARCH64) && KMP_OS_LINUX
                        *argv++ = va_arg( *ap, void * );
# else
                        *argv++ = va_arg( ap, void * );
# endif
                } else {
                    for( i=0; i < argc; ++i )
                        // Get args from parent team for teams construct
                        argv[i] = parent_team->t.t_argv[i];
                }
                // AC: revert change made in __kmpc_serialized_parallel()
                //     because initial code in teams should have level=0
                team->t.t_level--;
                // AC: call special invoker for outer "parallel" of the teams construct
                {
                    KMP_TIME_BLOCK(OMP_work);
                    invoker(gtid);
                }
            } else {
#endif /* OMP_40_ENABLED */
                argv = args;
                for( i=argc-1; i >= 0; --i )
// TODO: revert workaround for Intel(R) 64 tracker #96
#if (KMP_ARCH_X86_64 || KMP_ARCH_ARM || KMP_ARCH_AARCH64) && KMP_OS_LINUX
                    *argv++ = va_arg( *ap, void * );
#else
                    *argv++ = va_arg( ap, void * );
#endif
                KMP_MB();

#if OMPT_SUPPORT
                void *dummy;
                void **exit_runtime_p;

                ompt_lw_taskteam_t lw_taskteam;

                if (ompt_enabled) {
                    __ompt_lw_taskteam_init(&lw_taskteam, master_th, gtid,
                        unwrapped_task, ompt_parallel_id);
                    lw_taskteam.ompt_task_info.task_id = __ompt_task_id_new(gtid);
                    exit_runtime_p = &(lw_taskteam.ompt_task_info.frame.exit_runtime_frame);

                    __ompt_lw_taskteam_link(&lw_taskteam, master_th);

#if OMPT_TRACE
                    /* OMPT implicit task begin */
                    my_task_id = lw_taskteam.ompt_task_info.task_id;
                    my_parallel_id = ompt_parallel_id;
                    if (ompt_callbacks.ompt_callback(ompt_event_implicit_task_begin)) {
                        ompt_callbacks.ompt_callback(ompt_event_implicit_task_begin)(
                            my_parallel_id, my_task_id);
                    }
#endif

                    /* OMPT state */
                    master_th->th.ompt_thread_info.state = ompt_state_work_parallel;
                } else {
                    exit_runtime_p = &dummy;
                }
#endif

                {
                    KMP_TIME_BLOCK(OMP_work);
                    __kmp_invoke_microtask( microtask, gtid, 0, argc, args
#if OMPT_SUPPORT
                        , exit_runtime_p
#endif
                    );
                }

#if OMPT_SUPPORT
                if (ompt_enabled) {
#if OMPT_TRACE
                    lw_taskteam.ompt_task_info.frame.exit_runtime_frame = 0;

                    if (ompt_callbacks.ompt_callback(ompt_event_implicit_task_end)) {
                        ompt_callbacks.ompt_callback(ompt_event_implicit_task_end)(
                            my_parallel_id, my_task_id);
                    }
#endif

                    __ompt_lw_taskteam_unlink(master_th);
                    // reset clear the task id only after unlinking the task
                    lw_taskteam.ompt_task_info.task_id = ompt_task_id_none;

                    if (ompt_callbacks.ompt_callback(ompt_event_parallel_end)) {
                        ompt_callbacks.ompt_callback(ompt_event_parallel_end)(
                            ompt_parallel_id, ompt_task_id,
                            OMPT_INVOKER(call_context));
                    }
                    master_th->th.ompt_thread_info.state = ompt_state_overhead;
                }
#endif
#if OMP_40_ENABLED
            }
#endif /* OMP_40_ENABLED */
        }
        else if ( call_context == fork_context_gnu ) {
#if OMPT_SUPPORT
            ompt_lw_taskteam_t *lwt = (ompt_lw_taskteam_t *)
                __kmp_allocate(sizeof(ompt_lw_taskteam_t));
            __ompt_lw_taskteam_init(lwt, master_th, gtid,
                unwrapped_task, ompt_parallel_id);

            lwt->ompt_task_info.task_id = __ompt_task_id_new(gtid);
            lwt->ompt_task_info.frame.exit_runtime_frame = 0;
            __ompt_lw_taskteam_link(lwt, master_th);
#endif

            // we were called from GNU native code
            KA_TRACE( 20, ("__kmp_fork_call: T#%d serial exit\n", gtid ));
            return FALSE;
        }
        else {
            KMP_ASSERT2( call_context < fork_context_last, "__kmp_fork_call: unknown fork_context parameter" );
        }


        KA_TRACE( 20, ("__kmp_fork_call: T#%d serial exit\n", gtid ));
        KMP_MB();
        return FALSE;
    }

    // GEH: only modify the executing flag in the case when not serialized
    //      serialized case is handled in kmpc_serialized_parallel
    KF_TRACE( 10, ( "__kmp_fork_call: parent_team_aclevel=%d, master_th=%p, curtask=%p, curtask_max_aclevel=%d\n",
                  parent_team->t.t_active_level, master_th, master_th->th.th_current_task,
                  master_th->th.th_current_task->td_icvs.max_active_levels ) );
    // TODO: GEH - cannot do this assertion because root thread not set up as executing
    // KMP_ASSERT( master_th->th.th_current_task->td_flags.executing == 1 );
    master_th->th.th_current_task->td_flags.executing = 0;

#if OMP_40_ENABLED
    if ( !master_th->th.th_teams_microtask || level > teams_level )
#endif /* OMP_40_ENABLED */
    {
        /* Increment our nested depth level */
        KMP_TEST_THEN_INC32( (kmp_int32*) &root->r.r_in_parallel );
    }

    // See if we need to make a copy of the ICVs.
    int nthreads_icv = master_th->th.th_current_task->td_icvs.nproc;
    if ((level+1 < __kmp_nested_nth.used) && (__kmp_nested_nth.nth[level+1] != nthreads_icv)) {
        nthreads_icv = __kmp_nested_nth.nth[level+1];
    }
    else {
        nthreads_icv = 0;  // don't update
    }

#if OMP_40_ENABLED
    // Figure out the proc_bind_policy for the new team.
    kmp_proc_bind_t proc_bind = master_th->th.th_set_proc_bind;
    kmp_proc_bind_t proc_bind_icv = proc_bind_default; // proc_bind_default means don't update
    if ( master_th->th.th_current_task->td_icvs.proc_bind == proc_bind_false ) {
        proc_bind = proc_bind_false;
    }
    else {
        if (proc_bind == proc_bind_default) {
            // No proc_bind clause specified; use current proc-bind-var for this parallel region
            proc_bind = master_th->th.th_current_task->td_icvs.proc_bind;
        }
        /* else: The proc_bind policy was specified explicitly on parallel clause. This
           overrides proc-bind-var for this parallel region, but does not change proc-bind-var. */
        // Figure the value of proc-bind-var for the child threads.
        if ((level+1 < __kmp_nested_proc_bind.used)
            && (__kmp_nested_proc_bind.bind_types[level+1] != master_th->th.th_current_task->td_icvs.proc_bind)) {
            proc_bind_icv = __kmp_nested_proc_bind.bind_types[level+1];
        }
    }

    // Reset for next parallel region
    master_th->th.th_set_proc_bind = proc_bind_default;
#endif /* OMP_40_ENABLED */

    if ((nthreads_icv > 0)
#if OMP_40_ENABLED
        || (proc_bind_icv != proc_bind_default)
#endif /* OMP_40_ENABLED */
        ) {
        kmp_internal_control_t new_icvs;
        copy_icvs(&new_icvs, &master_th->th.th_current_task->td_icvs);
        new_icvs.next = NULL;
        if (nthreads_icv > 0) {
            new_icvs.nproc = nthreads_icv;
        }

#if OMP_40_ENABLED
        if (proc_bind_icv != proc_bind_default) {
            new_icvs.proc_bind = proc_bind_icv;
        }
#endif /* OMP_40_ENABLED */

        /* allocate a new parallel team */
        KF_TRACE( 10, ( "__kmp_fork_call: before __kmp_allocate_team\n" ) );
        team = __kmp_allocate_team(root, nthreads, nthreads,
#if OMPT_SUPPORT
                                   ompt_parallel_id,
#endif
#if OMP_40_ENABLED
                                   proc_bind,
#endif
                                   &new_icvs, argc USE_NESTED_HOT_ARG(master_th) );
    } else {
        /* allocate a new parallel team */
        KF_TRACE( 10, ( "__kmp_fork_call: before __kmp_allocate_team\n" ) );
        team = __kmp_allocate_team(root, nthreads, nthreads,
#if OMPT_SUPPORT
                                   ompt_parallel_id,
#endif
#if OMP_40_ENABLED
                                   proc_bind,
#endif
                                   &master_th->th.th_current_task->td_icvs, argc
                                   USE_NESTED_HOT_ARG(master_th) );
    }
    KF_TRACE( 10, ( "__kmp_fork_call: after __kmp_allocate_team - team = %p\n", team ) );

    /* setup the new team */
    team->t.t_master_tid = master_tid;
    team->t.t_master_this_cons = master_this_cons;
    team->t.t_ident      = loc;
    team->t.t_parent     = parent_team;
    TCW_SYNC_PTR(team->t.t_pkfn, microtask);
#if OMPT_SUPPORT
    TCW_SYNC_PTR(team->t.ompt_team_info.microtask, unwrapped_task);
#endif
    team->t.t_invoke     = invoker;  /* TODO move this to root, maybe */
    // TODO: parent_team->t.t_level == INT_MAX ???
#if OMP_40_ENABLED
    if ( !master_th->th.th_teams_microtask || level > teams_level ) {
#endif /* OMP_40_ENABLED */
        team->t.t_level        = parent_team->t.t_level + 1;
        team->t.t_active_level = parent_team->t.t_active_level + 1;
#if OMP_40_ENABLED
    } else {
        // AC: Do not increase parallel level at start of the teams construct
        team->t.t_level        = parent_team->t.t_level;
        team->t.t_active_level = parent_team->t.t_active_level;
    }
#endif /* OMP_40_ENABLED */
    team->t.t_sched      = get__sched_2(parent_team, master_tid); // set master's schedule as new run-time schedule

#if OMP_40_ENABLED
    team->t.t_cancel_request = cancel_noreq;
#endif

    // Update the floating point rounding in the team if required.
    propagateFPControl(team);

    if ( __kmp_tasking_mode != tskm_immediate_exec ) {
        // Set master's task team to team's task team. Unless this is hot team, it should be NULL.
#if 0
        // Patch out an assertion that trips while the runtime seems to operate correctly.
        // Avoiding the preconditions that cause the assertion to trip has been promised as a forthcoming patch.
        KMP_DEBUG_ASSERT(master_th->th.th_task_team == parent_team->t.t_task_team[master_th->th.th_task_state]);
#endif
        KA_TRACE( 20, ( "__kmp_fork_call: Master T#%d pushing task_team %p / team %p, new task_team %p / team %p\n",
                      __kmp_gtid_from_thread( master_th ), master_th->th.th_task_team,
                      parent_team, team->t.t_task_team[master_th->th.th_task_state], team ) );

        if ( level || master_th->th.th_task_team ) {
            // Take a memo of master's task_state
            KMP_DEBUG_ASSERT(master_th->th.th_task_state_memo_stack);
            if (master_th->th.th_task_state_top >= master_th->th.th_task_state_stack_sz) { // increase size
                kmp_uint32 new_size = 2*master_th->th.th_task_state_stack_sz;
                kmp_uint8 *old_stack, *new_stack;
                kmp_uint32 i;
                new_stack = (kmp_uint8 *)__kmp_allocate(new_size);
                for (i=0; i<master_th->th.th_task_state_stack_sz; ++i) {
                    new_stack[i] = master_th->th.th_task_state_memo_stack[i];
                }
                for (i=master_th->th.th_task_state_stack_sz; i<new_size; ++i) { // zero-init rest of stack
                    new_stack[i] = 0;
                }
                old_stack = master_th->th.th_task_state_memo_stack;
                master_th->th.th_task_state_memo_stack = new_stack;
                master_th->th.th_task_state_stack_sz = new_size;
                __kmp_free(old_stack);
            }
            // Store master's task_state on stack
            master_th->th.th_task_state_memo_stack[master_th->th.th_task_state_top] = master_th->th.th_task_state;
            master_th->th.th_task_state_top++;
#if KMP_NESTED_HOT_TEAMS
            if (team == master_th->th.th_hot_teams[level].hot_team) { // Restore master's nested state if nested hot team
                master_th->th.th_task_state = master_th->th.th_task_state_memo_stack[master_th->th.th_task_state_top];
            }
            else {
#endif
                master_th->th.th_task_state = 0;
#if KMP_NESTED_HOT_TEAMS
            }
#endif
        }
#if !KMP_NESTED_HOT_TEAMS
        KMP_DEBUG_ASSERT((master_th->th.th_task_team == NULL) || (team == root->r.r_hot_team));
#endif
    }

    KA_TRACE( 20, ("__kmp_fork_call: T#%d(%d:%d)->(%d:0) created a team of %d threads\n",
                gtid, parent_team->t.t_id, team->t.t_master_tid, team->t.t_id, team->t.t_nproc ));
    KMP_DEBUG_ASSERT( team != root->r.r_hot_team ||
                      ( team->t.t_master_tid == 0 &&
                        ( team->t.t_parent == root->r.r_root_team || team->t.t_parent->t.t_serialized ) ));
    KMP_MB();

    /* now, setup the arguments */
    argv = (void**)team->t.t_argv;
#if OMP_40_ENABLED
    if ( ap ) {
#endif /* OMP_40_ENABLED */
        for ( i=argc-1; i >= 0; --i )
// TODO: revert workaround for Intel(R) 64 tracker #96
#if (KMP_ARCH_X86_64 || KMP_ARCH_ARM || KMP_ARCH_AARCH64) && KMP_OS_LINUX
            *argv++ = va_arg( *ap, void * );
#else
            *argv++ = va_arg( ap, void * );
#endif
#if OMP_40_ENABLED
    } else {
        for ( i=0; i < argc; ++i )
            // Get args from parent team for teams construct
            argv[i] = team->t.t_parent->t.t_argv[i];
    }
#endif /* OMP_40_ENABLED */

    /* now actually fork the threads */
    team->t.t_master_active = master_active;
    if (!root->r.r_active) // Only do assignment if it prevents cache ping-pong
        root->r.r_active = TRUE;

    __kmp_fork_team_threads( root, team, master_th, gtid );
    __kmp_setup_icv_copy( team, nthreads, &master_th->th.th_current_task->td_icvs, loc );

#if OMPT_SUPPORT
    master_th->th.ompt_thread_info.state = ompt_state_work_parallel;
#endif

    __kmp_release_bootstrap_lock( &__kmp_forkjoin_lock );

#if USE_ITT_BUILD
    if ( team->t.t_active_level == 1 // only report frames at level 1
# if OMP_40_ENABLED
        && !master_th->th.th_teams_microtask // not in teams construct
# endif /* OMP_40_ENABLED */
    ) {
#if USE_ITT_NOTIFY
        if ( ( __itt_frame_submit_v3_ptr || KMP_ITT_DEBUG ) &&
             ( __kmp_forkjoin_frames_mode == 3 || __kmp_forkjoin_frames_mode == 1 ) )
        {
            kmp_uint64 tmp_time = 0;
            if ( __itt_get_timestamp_ptr )
                tmp_time = __itt_get_timestamp();
            // Internal fork - report frame begin
            master_th->th.th_frame_time  = tmp_time;
            if ( __kmp_forkjoin_frames_mode == 3 )
                team->t.t_region_time = tmp_time;
        } else // only one notification scheme (either "submit" or "forking/joined", not both)
#endif /* USE_ITT_NOTIFY */
        if ( ( __itt_frame_begin_v3_ptr || KMP_ITT_DEBUG ) &&
             __kmp_forkjoin_frames && !__kmp_forkjoin_frames_mode )
        { // Mark start of "parallel" region for VTune.
            __kmp_itt_region_forking(gtid, team->t.t_nproc, 0);
        }
    }
#endif /* USE_ITT_BUILD */

    /* now go on and do the work */
    KMP_DEBUG_ASSERT( team == __kmp_threads[gtid]->th.th_team );
    KMP_MB();
    KF_TRACE(10, ("__kmp_internal_fork : root=%p, team=%p, master_th=%p, gtid=%d\n",
                  root, team, master_th, gtid));

#if USE_ITT_BUILD
    if ( __itt_stack_caller_create_ptr ) {
        team->t.t_stack_id = __kmp_itt_stack_caller_create(); // create new stack stitching id before entering fork barrier
    }
#endif /* USE_ITT_BUILD */

#if OMP_40_ENABLED
    if ( ap )   // AC: skip __kmp_internal_fork at teams construct, let only master threads execute
#endif /* OMP_40_ENABLED */
    {
        __kmp_internal_fork( loc, gtid, team );
        KF_TRACE(10, ("__kmp_internal_fork : after : root=%p, team=%p, master_th=%p, gtid=%d\n",
                      root, team, master_th, gtid));
    }

    if (call_context == fork_context_gnu) {
        KA_TRACE( 20, ("__kmp_fork_call: parallel exit T#%d\n", gtid ));
        return TRUE;
    }

    /* Invoke microtask for MASTER thread */
    KA_TRACE( 20, ("__kmp_fork_call: T#%d(%d:0) invoke microtask = %p\n",
                gtid, team->t.t_id, team->t.t_pkfn ) );
    }  // END of timer KMP_fork_call block

    {
        KMP_TIME_BLOCK(OMP_work);
        // KMP_TIME_DEVELOPER_BLOCK(USER_master_invoke);
        if (! team->t.t_invoke( gtid )) {
            KMP_ASSERT2( 0, "cannot invoke microtask for MASTER thread" );
        }
    }
    KA_TRACE( 20, ("__kmp_fork_call: T#%d(%d:0) done microtask = %p\n",
        gtid, team->t.t_id, team->t.t_pkfn ) );
    KMP_MB();       /* Flush all pending memory write invalidates.  */

    KA_TRACE( 20, ("__kmp_fork_call: parallel exit T#%d\n", gtid ));

#if OMPT_SUPPORT
    if (ompt_enabled) {
        master_th->th.ompt_thread_info.state = ompt_state_overhead;
    }
#endif

    return TRUE;
}
