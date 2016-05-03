#references 

https://computing.llnl.gov/tutorials/openMP/ProcessThreadAffinity.pdf
pdf sur les affinités, comment lier une tâche à un coeur ou une socket.

http://www.openmp.org/mp-documents/OpenMP3.1.pdf
OpenMP specification

http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.107.9768&rep=rep1&type=pdf
modèle mémoire openmp

https://en.wikipedia.org/wiki/Work_stealing

http://mspiegel.github.io/publications/ijhpca11.pdf
article sur une implementation du runtime d'openmp pour NUMA

http://prace.it4i.cz/sites/prace.it4i.cz/files/files/advancedopenmptutorial_2.pdf
Des "conseils" pour utiliser openMP avec NUMA

http://runtime.bordeaux.inria.fr/forestgomp/
Un projet runtime pour openMP avec du support pour NUMA

https://en.wikipedia.org/wiki/Non-uniform_memory_access

https://gcc.gnu.org/onlinedocs/libgomp/
la doc de gcc pour libgomp ( utile pour comparer )

http://llvm.org/docs/LangRef.html
la doc de la llvm intermediate representation

http://reviews.llvm.org/D13991
le commit lié à l'utilisation de hwloc

http://developerblog.redhat.com/2014/03/10/determining-whether-an-application-has-poor-cache-performance-2/
site expliquant comment evaluer la performance avec perf
