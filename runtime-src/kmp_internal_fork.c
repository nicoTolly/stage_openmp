void
__kmp_internal_fork( ident_t *id, int gtid, kmp_team_t *team )
{
    kmp_info_t *this_thr = __kmp_threads[gtid];

#ifdef KMP_DEBUG
    int f;
#endif /* KMP_DEBUG */

    KMP_DEBUG_ASSERT( team );
    KMP_DEBUG_ASSERT( this_thr->th.th_team  ==  team );
    KMP_ASSERT(       KMP_MASTER_GTID(gtid) );
    KMP_MB();       /* Flush all pending memory write invalidates.  */

    team->t.t_construct = 0;          /* no single directives seen yet */
    team->t.t_ordered.dt.t_value = 0; /* thread 0 enters the ordered section first */

    /* Reset the identifiers on the dispatch buffer */
    KMP_DEBUG_ASSERT( team->t.t_disp_buffer );
    if ( team->t.t_max_nproc > 1 ) {
        int i;
        for (i = 0; i <  KMP_MAX_DISP_BUF; ++i) {
            team->t.t_disp_buffer[ i ].buffer_index = i;
#if OMP_41_ENABLED
            team->t.t_disp_buffer[i].doacross_buf_idx = i;
#endif
        }
    } else {
        team->t.t_disp_buffer[ 0 ].buffer_index = 0;
#if OMP_41_ENABLED
        team->t.t_disp_buffer[0].doacross_buf_idx = 0;
#endif
    }

    KMP_MB();       /* Flush all pending memory write invalidates.  */
    KMP_ASSERT( this_thr->th.th_team  ==  team );

#ifdef KMP_DEBUG
    for( f=0 ; f<team->t.t_nproc ; f++ ) {
        KMP_DEBUG_ASSERT( team->t.t_threads[f] &&
                          team->t.t_threads[f]->th.th_team_nproc == team->t.t_nproc );
    }
#endif /* KMP_DEBUG */

    /* release the worker threads so they may begin working */
    __kmp_fork_barrier( gtid, 0 );
}
