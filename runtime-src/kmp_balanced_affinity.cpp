// Dynamic affinity settings - Affinity balanced
void __kmp_balanced_affinity( int tid, int nthreads )
{
    if( __kmp_affinity_uniform_topology() ) {
        int coreID;
        int threadID;
        // Number of hyper threads per core in HT machine
        int __kmp_nth_per_core = __kmp_avail_proc / __kmp_ncores;
        // Number of cores
        int ncores = __kmp_ncores;
        // How many threads will be bound to each core
        int chunk = nthreads / ncores;
        // How many cores will have an additional thread bound to it - "big cores"
        int big_cores = nthreads % ncores;
        // Number of threads on the big cores
        int big_nth = ( chunk + 1 ) * big_cores;
        if( tid < big_nth ) {
            coreID = tid / (chunk + 1 );
            threadID = ( tid % (chunk + 1 ) ) % __kmp_nth_per_core ;
        } else { //tid >= big_nth
            coreID = ( tid - big_cores ) / chunk;
            threadID = ( ( tid - big_cores ) % chunk ) % __kmp_nth_per_core ;
        }

        KMP_DEBUG_ASSERT2(KMP_AFFINITY_CAPABLE(),
          "Illegal set affinity operation when not capable");

        kmp_affin_mask_t *mask;
        KMP_CPU_ALLOC_ON_STACK(mask);
        KMP_CPU_ZERO(mask);

        // Granularity == thread
        if( __kmp_affinity_gran == affinity_gran_fine || __kmp_affinity_gran == affinity_gran_thread) {
            int osID = address2os[ coreID * __kmp_nth_per_core + threadID ].second;
            KMP_CPU_SET( osID, mask);
        } else if( __kmp_affinity_gran == affinity_gran_core ) { // Granularity == core
            for( int i = 0; i < __kmp_nth_per_core; i++ ) {
                int osID;
                osID = address2os[ coreID * __kmp_nth_per_core + i ].second;
                KMP_CPU_SET( osID, mask);
            }
        }
        if (__kmp_affinity_verbose) {
            char buf[KMP_AFFIN_MASK_PRINT_LEN];
            __kmp_affinity_print_mask(buf, KMP_AFFIN_MASK_PRINT_LEN, mask);
            KMP_INFORM(BoundToOSProcSet, "KMP_AFFINITY", (kmp_int32)getpid(),
              tid, buf);
        }
        __kmp_set_system_affinity( mask, TRUE );
        KMP_CPU_FREE_FROM_STACK(mask);
    } else { // Non-uniform topology

        kmp_affin_mask_t *mask;
        KMP_CPU_ALLOC_ON_STACK(mask);
        KMP_CPU_ZERO(mask);

        // Number of hyper threads per core in HT machine
        int nth_per_core = __kmp_nThreadsPerCore;
        int core_level;
        if( nth_per_core > 1 ) {
            core_level = __kmp_aff_depth - 2;
        } else {
            core_level = __kmp_aff_depth - 1;
        }

        // Number of cores - maximum value; it does not count trail cores with 0 processors
        int ncores = address2os[ __kmp_avail_proc - 1 ].first.labels[ core_level ] + 1;

        // For performance gain consider the special case nthreads == __kmp_avail_proc
        if( nthreads == __kmp_avail_proc ) {
            if( __kmp_affinity_gran == affinity_gran_fine || __kmp_affinity_gran == affinity_gran_thread) {
                int osID = address2os[ tid ].second;
                KMP_CPU_SET( osID, mask);
            } else if( __kmp_affinity_gran == affinity_gran_core ) { // Granularity == core
                int coreID = address2os[ tid ].first.labels[ core_level ];
                // We'll count found osIDs for the current core; they can be not more than nth_per_core;
                // since the address2os is sortied we can break when cnt==nth_per_core
                int cnt = 0;
                for( int i = 0; i < __kmp_avail_proc; i++ ) {
                    int osID = address2os[ i ].second;
                    int core = address2os[ i ].first.labels[ core_level ];
                    if( core == coreID ) {
                        KMP_CPU_SET( osID, mask);
                        cnt++;
                        if( cnt == nth_per_core ) {
                            break;
                        }
                    }
                }
            }
        } else if( nthreads <= __kmp_ncores ) {

            int core = 0;
            for( int i = 0; i < ncores; i++ ) {
                // Check if this core from procarr[] is in the mask
                int in_mask = 0;
                for( int j = 0; j < nth_per_core; j++ ) {
                    if( procarr[ i * nth_per_core + j ] != - 1 ) {
                        in_mask = 1;
                        break;
                    }
                }
                if( in_mask ) {
                    if( tid == core ) {
                        for( int j = 0; j < nth_per_core; j++ ) {
                            int osID = procarr[ i * nth_per_core + j ];
                            if( osID != -1 ) {
                                KMP_CPU_SET( osID, mask );
                                // For granularity=thread it is enough to set the first available osID for this core
                                if( __kmp_affinity_gran == affinity_gran_fine || __kmp_affinity_gran == affinity_gran_thread) {
                                    break;
                                }
                            }
                        }
                        break;
                    } else {
                        core++;
                    }
                }
            }

        } else { // nthreads > __kmp_ncores

            // Array to save the number of processors at each core
            int* nproc_at_core = (int*)KMP_ALLOCA(sizeof(int)*ncores);
            // Array to save the number of cores with "x" available processors;
            int* ncores_with_x_procs = (int*)KMP_ALLOCA(sizeof(int)*(nth_per_core+1));
            // Array to save the number of cores with # procs from x to nth_per_core
            int* ncores_with_x_to_max_procs = (int*)KMP_ALLOCA(sizeof(int)*(nth_per_core+1));

            for( int i = 0; i <= nth_per_core; i++ ) {
                ncores_with_x_procs[ i ] = 0;
                ncores_with_x_to_max_procs[ i ] = 0;
            }

            for( int i = 0; i < ncores; i++ ) {
                int cnt = 0;
                for( int j = 0; j < nth_per_core; j++ ) {
                    if( procarr[ i * nth_per_core + j ] != -1 ) {
                        cnt++;
                    }
                }
                nproc_at_core[ i ] = cnt;
                ncores_with_x_procs[ cnt ]++;
            }

            for( int i = 0; i <= nth_per_core; i++ ) {
                for( int j = i; j <= nth_per_core; j++ ) {
                    ncores_with_x_to_max_procs[ i ] += ncores_with_x_procs[ j ];
                }
            }

            // Max number of processors
            int nproc = nth_per_core * ncores;
            // An array to keep number of threads per each context
            int * newarr = ( int * )__kmp_allocate( sizeof( int ) * nproc );
            for( int i = 0; i < nproc; i++ ) {
                newarr[ i ] = 0;
            }

            int nth = nthreads;
            int flag = 0;
            while( nth > 0 ) {
                for( int j = 1; j <= nth_per_core; j++ ) {
                    int cnt = ncores_with_x_to_max_procs[ j ];
                    for( int i = 0; i < ncores; i++ ) {
                        // Skip the core with 0 processors
                        if( nproc_at_core[ i ] == 0 ) {
                            continue;
                        }
                        for( int k = 0; k < nth_per_core; k++ ) {
                            if( procarr[ i * nth_per_core + k ] != -1 ) {
                                if( newarr[ i * nth_per_core + k ] == 0 ) {
                                    newarr[ i * nth_per_core + k ] = 1;
                                    cnt--;
                                    nth--;
                                    break;
                                } else {
                                    if( flag != 0 ) {
                                        newarr[ i * nth_per_core + k ] ++;
                                        cnt--;
                                        nth--;
                                        break;
                                    }
                                }
                            }
                        }
                        if( cnt == 0 || nth == 0 ) {
                            break;
                        }
                    }
                    if( nth == 0 ) {
                        break;
                    }
                }
                flag = 1;
            }
            int sum = 0;
            for( int i = 0; i < nproc; i++ ) {
                sum += newarr[ i ];
                if( sum > tid ) {
                    // Granularity == thread
                    if( __kmp_affinity_gran == affinity_gran_fine || __kmp_affinity_gran == affinity_gran_thread) {
                        int osID = procarr[ i ];
                        KMP_CPU_SET( osID, mask);
                    } else if( __kmp_affinity_gran == affinity_gran_core ) { // Granularity == core
                        int coreID = i / nth_per_core;
                        for( int ii = 0; ii < nth_per_core; ii++ ) {
                            int osID = procarr[ coreID * nth_per_core + ii ];
                            if( osID != -1 ) {
                                KMP_CPU_SET( osID, mask);
                            }
                        }
                    }
                    break;
                }
            }
            __kmp_free( newarr );
        }

        if (__kmp_affinity_verbose) {
            char buf[KMP_AFFIN_MASK_PRINT_LEN];
            __kmp_affinity_print_mask(buf, KMP_AFFIN_MASK_PRINT_LEN, mask);
            KMP_INFORM(BoundToOSProcSet, "KMP_AFFINITY", (kmp_int32)getpid(),
              tid, buf);
        }
        __kmp_set_system_affinity( mask, TRUE );
        KMP_CPU_FREE_FROM_STACK(mask);
    }
}
