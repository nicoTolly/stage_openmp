#Notes sur OpenMP et l'algorithme de Cholesky

trouvé d'abord une implémentation de Cholesky en C standard,
celle-ci fonctionne aussi bien avec clang qu'avec gcc.


gcc (GCC) 5.3.0
Copyright © 2015 Free Software Foundation, Inc.
Ce logiciel est libre; voir les sources pour les conditions de copie.  Il n'y a PAS
GARANTIE; ni implicite pour le MARCHANDAGE ou pour un BUT PARTICULIER.


clang version 3.7.1 (tags/RELEASE_371/final)
Target: x86_64-unknown-linux-gnu
Thread model: posix

les versions de gcc et clang de mon ordinateur.

Cherché ensuite une version de cholesky implémentée pour openMP, pas mal galéré.
Finalement, après avoir trouvé un lourd dossier de benchmark comprenant notamment un cholesky,
sans réussir à l'adapter, j'ai simplement adapté le code en C original. Ajouté ceci :

#pragma scop
#pragma omp parallel
	{
#pragma omp for private (j, k)
	for (int i = 0; i < n; i++)
		for (int j = 0; j < (i+1); j++) {
			double s = 0;
			for (int k = 0; k < j; k++)
				s += L[i * n + k] * L[j * n + k];
			L[i * n + j] = (i == j) ?
				sqrt(A[i * n + i] - s) :
				(1.0 / L[j * n + j] * (A[i * n + j] - s));
		}
}
#pragma endscop

( toutes les pragmas ).

Compile sans souci ( et fonctionne ) avec gcc : gcc -Wall -o cholesky cholesky.c -lm

Pour clang par contre, il  y a un souci: il faut ajouter une option à la commande de base.
clang -o cholesky cholesky.c -lm -fopenmp

Aussi du faire: 
sudo cp /usr/lib/gcc/x86_64-unknown-linux-gnu/5.3.0/include/omp.h /usr/lib/clang/3.7.1/include/

on aurait pu se contenter d'un -I dans la ligne de commande.

Ensuite tout fonctionne sans problème. Il s'agirait maintenant de voir comment openMP modifie le
comportement du programme ( si même il le modifie ).

Premier point : les fichiers assembleurs générés sont les memes.

En fait les pragmas sont ignorées.

libgomp est bien installé


Tenté un petit hello avec openmp. Marche bien avec gcc à condition d'ajouter -fopenmp également.
Ne fonctionne pas avec Clang


#04/04

Le programme parallèle est en fait super instable: parfois des nan ou des inf ( float proche de 0 ) interviennent ).

Aussi, mettre j et i dans shared change le programme en boucle infinie. À éclaircir.


Récupéré des fichiers de test, notamment un exemple de boucle. Le mot clé schedule est sympa : permet 
de distribuer les tâches aux différents threads. On choisit static ou dynamic ( static répartissant a 
priori entre les threads, dynamic permettant de les répartir à l'exécution et d'en donner plus 
au plus rapide ).

Le souci est en fait simple : il y a de grosses dépendances entre les itérations de la boucle.

Tenté d'ajouter la clause ordered, ne change rien.

Placé le pragma uniquement sur la boucle interne. Comme on peut s'y attendre, le comportement 
devient déterministe (plus de dépendances entre itérations ).

On peut même paralléliser les deux boucles internes ( en fait, on calcule une colonne d'après
la colonne précédente, mais dans une même colonne, les lignes sont indépendantes ).

C'est sans doute à ça que servait la clause "private(j, k)"

Déclarer i, j et k avant les boucles déclenche une boucle infinie ( problème de localité quelconque )



#my program

Réalisé ( sur conseil de Fabrice ) un petit programme qui se contente de tourner sur le CPU, en faisant
des calculs inutiles ( juste pour tourner ).

L'outil perf permet d'analyser les performances du programme, les défauts de pages ou défauts de cache 
notamment. On devrait voir les cache miss augmenter quand on va allouer des tableaux privés de la taille 
du cache L1.

Utilise timeout pour arrêter le programme après 10s.

la commande est : perf stat -e cache-misses timeout 10 ./example

On voit en effet que le nombre de caches-misses augmente si on met les deux tableaux en private,
et qu'en plus on met une grande taille

# re cholesky
Retour rapide au cholesky: on peut arriver à un programme déterministe (testé seulement 4 ou 5 fois) 
en ajoutant une directive ordered.
Cette directive encadre un bloc qu'on veut voir être exécuté dans le même ordre que dans le cas séquentiel.
Il faut préciser que for est ordered ET rajouter le pragma ordered dans la boucle.

Sinon, fait un petit script pour récupérer les caches-misses et les stocker dans un fichier ( countMissed.sh)
Utilisé awk pour le script ( on pipe le perf dans un grep ( il faut piper le stderr ) et on utilise awk
dessus ).

Les caches-misses sont vraiment aléatoires. Je pense qu'ils dépendent aussi du reste de l'environnement.

Grosses difficultés pour installer clang et llvm.

Le linkage à la fin pose problème.

Récupéré à chaque fois les release 3.8 pour llvm, puis clang ( cloné dans llvm/tools ) puis openmp
( cloné dans llvm/projects ). Utilisé à chaque fois le clonage en ssh sur github, comme conseillé par
Philippe ( ça a pris quand même pas mal de temps ).

Créé build dans stage. 
fait ( dans build ) cmake ../llvm -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++
puis make omp

Ensuite, toujours dans build:
cmake "Unix Makefiles"
make -j 3

Obtenu à la fin une erreur sur le ld qui a reçu une interruption

En fait, le linkage plante parce que la RAM est débordée ( le linkage essaie de prendre 10 Gi, il n'y en
a que 8 ).

On peut installer la release plutôt que la version debug, beaucoup plus lourde.

La ligne de cmake est alors:
(voir plus tard)

Possibilité avec perf d'obtenir uniquement les caches-misses pour le L1, séparés en cache-load-misses et
cache-store-misses.

Difficile de noter une différence sur ces chiffres là également.


Fini par réussir à compiler et installer: finalement il ne faut pas installer la release mais MinSizeRel.
La ligne cmake est : 
cmake ../llvm/ -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ -DCMAKE_BUILD_TYPE=MinSizeRel

Il faut aussi exporter LD_LIBRARY_PATH. À faire : faire cela automatiquement.

#06/04

Clang finalement installé.

Essayé de compiler cholesky avec : il semble que la directive ordered soit mal comprise. On retombe 
en effet sur les nan, etc.

Fabrice m'a donné un bout de code pour faire tourner des benchmarks. Compilation pas si simple:

Il faut ajouter le flag -mavx pour indiquer le matériel présent ( des instructions de parallélisation
simd ) 
ajouter aussi ( avec gcc, pas testé avec clang ) le flag -fpic ( position independant code )
Sans ça, ld renvoie une erreur.

Fait un Makefile pour pouvoir compiler tous les exécutables à la fois ( en définissant les bonnes
macros )


Idées: profiling, regarder l'exécution dynamiquement pour prédire les accès mémoire futurs pour placer
les affinités.

Voir l'algo d'Alain ?

Autre idée:

Avec philippe, voir le "vol de tache".
Une tache qui fait beaucoup d'appel à distance perd en performance.
Vérifier si une tache va faire beaucoup d'appel à la mémoire, si oui, interdire
le vol. Prioriser les vols sur les taches computationnelles et favoriser les taches
"mémorielles" en priorité.

Trouver des exemples de programmes en openmp. Beaucoup de taches différentes ?

##Brancher un programme compilé avec clang sur une librairie gcc

Copier la bibliothèque qu'on veut utiliser dans un répertoire quelconque.
ajouter ce répertoire à LD_LIBRARY_PATH ( éventuellement en l'écrasant ).
on peut vérifier avec ldd ( permet de voir les bibliothèques utilisées ).

#07/04

##Who uses openmp ?

openmp.org/wp/whos-using-openmp/

Quelques applications sont listées sur cette page. Malheureusement, elles sont
pour la plupart commerciales.

Les projets évoquent beaucoup la parallélisation automatique de boucle avec #pragma
omp for mais on trouve aussi la mention d'utilisations de task.

Un des programmes ( libdoubanm ) dit utiliser des task pour faire des parcours de 
graphe.

##Affinity

Il existe une bibliothèque C pour spécifier une affinité sur un thread. 
Les deux fonctions centrales sont sched_getaffinity et sched_setaffinity.
Des macros permettent de travailler sur les structures cpu_set_t.

ATTENTION : il faut définir la macro _GNU_SOURCE AVANT d'inclure <sched.h> sans
quoi les macros ne sont pas définies ( ni les fonctions, d'ailleurs, mais ce n'est
pas un souci dans ce cas).

#08/04

Réécrit un programme aff pour tester les affinités avec des forks. Cette fois, le programme
fonctionne bien, on voit avec htop que le travail est bien affecté différamment sur chacun 
des coeurs.

En openmp, ces paramètrages sont probablement redéfinis à part. Il faudrait changer le runtime
pour arriver à quelque chose de plus convaincant. 



##Discussion Philippe

Pas mal de choses, plusieurs possibilités pour la suite.

Existence ( et bientot finition ) d'un programme qui peut garder la localité d'une tache sur
un numa. Une file de tache dans lequel un autre processeur ( éventuellement distant ) peut
piocher. Garder la localité : demander à ce que deux taches soient exécutées au meme endroit.

Dans les choses à faire : soit, à la compilation, "calculer" ou estimer une intensité opérationnelle
pour une tâche. Ensuite, la passer au runtime pour qui applique la stratégie appropriée.

Autrement, déterminer cette stratégie : dans quel cas autoriser le vol, dans quel cas garder la localité.

On peut baser la file du runtime sur l'OI déterminée.

Intensité opérationnelle : "rapport" entre nombre d'accès mémoire à un secteur et taille de ce même secteur. Pas trop de trace sur internet.

Plein de chose sur l'implémentation en mémoire de openmp. Une nouvelle variable est créée pour chaque
variable privée, une simple référence vers le tas pour les variables shared. 

Fork trop coûteux : trop de choses sont copiées ( état de la stack, du tas...) On utilise plutôt pthread.

Kastors

#14/04

retour avec nouvel ordi. Un : le benchmark que m'a donné Fabrice ne
compile plus. Pas encore trouvé de fix ( à voir si j'en trouverai
un ) 

Continué mes petits tests avec cholesky. Génère des matrices 
définies positives symétriques avec Hilbert ( a en plus l'avantage 
d'être déterministe )
Fait aussi un Makefile qui compile trois fichiers : basic-cholesky,
 cholesky-for (avec la directive ordered ) et cholesky-dep ( avec 
 les dépendances ). Surprise (ou pas) la version basique est 
 largement plus rapide que les deux autres.

 La version dep bat nettement la version for, mais reste du même 
 ordre de grandeur.

 Il est probable que la granularité soit trop fine : trop de temps
 passé à répartir les tâches. À noter qu'au début, le programme 
 créait ses tâches dans la boucle interne, ce qui faisait encore 
 plus de granularité. Cette version était moins performante que la 
 boucle for.

 Comment diminuer la granularité ?

 #15/04

 Quelques tests sur la directive ordered de openmp.

 Fait d'abord un fichier avec une boucle simple qui affiche la valeur
 de i. Compilé avec gcc puis clang, on obtient le comportement attendu.

 Pas de souci non plus avec une double boucle
 peut-être des optimisations de code mort ?
 Compliqué un peu les choses, introduit un sleep dans chacune des
 itérations, juste après un print non ordonné, et avant un print ordonné.
 À ce moment, le programme compilé avec gcc se comporte toujours comme 
 attendu ( les print non ordonnés arrivent un peu au hasard, ceux qui sont
 ordonnés apparaissent dans le bon ordre ). Par contre, le programme compilé
 avec clang se comporte de manière étrange, et l'ordre est perdu.

 relativisons les performances observees sur cholesky : même avec une boucle
 simple et sans dépendance, le gain de performance est peu évident (
 peut-être des optimisations de code mort ?)

 Il y a manifestement un souci au niveau de mon chrono. 
 Clock_gettime semble mieux approprie ( clock() se contente
 du temps passe par l'application dans le processeur)

 #18/04

 clock_gettime(CLOCK_MONOTONIC, ...) est bien mieux appropriee
 pour les tests. Les resultats sont bien plus stables qu'avant.

 Des lors, les resultats sont plus proches de ceux attendus. A 
 noter que pour cholesky-dep on obtient des performances tres 
 inferieures a la version basique avec num_threads=1, mais les
 performances deviennent comparables avec num_threads=2. Pas de 
 differences notables lorsque num_threads=4 ou 8 par contre. 

 #19/04

 re-discussion avec Philippe:
 envoyer un mail a fred desprez pour grid5000 et a christian seguy
 pour idchire (oui...)

 Si travail cote runtime : essayer le run-time de clang ( en fait
  celui d'Intel ) plus "facile" d'acces que kaapi notamment.

  fait un wrapper de clock_gettime ( on pourrait eventuellement
   ajouter d'autres timers, mais CLOCK_MONOTONIC fait bien le job,
   coherente avec d'autres trucs)

On obtient ENFIN des temps inferieurs pour une boucle for pour
des iterations tres longues ( au moins 500M calculs flottants )

#20/04

Envoyé mail à fred desprez pour grid5000 et christiqn seguy pour idchire,
suivant le conseil de Philippe.

Petit retour sur les deux runtimes : c'est bien le runtime de clang qui 
plante sur ordered ( le problème n'est apparemment pas situé à la 
compilation ). Testé omp-for avec le runtime intel : copié
build/lib/libomp.so dans le répertoire courant, puis fait 
LD_PRELOAD="libomp.so" ldd ./omp-for qui prouve que libomp.so est bien
utilisée.

Puis fait LD_PRELOAD="libomp.so" ./omp-for.
On a toujours le for désordonné.

#21/04

Aujourd'hui, recu les acces a idchire. Installation de clang (youhou)
et de gcc (version trop vieille). Il faut installer gcc avant clang.

Pour installer la derniere version de gcc, il faut recuperer gmp, mpfr
et mpc. 

Tous les binaires sont installes dans ntollena/local

Il a fallu installer aussi cmake

pour mpfr, bien penser a actualiser LD_LIBRARY_PATH, de sorte qu'il
trouve bien la bonne version de gmp. Ce sera pareil pour gcc


./configure --prefix=/home/ntollena/local/ --with-gmp-lib=/home/ntollena/local/lib/ --with-gmp-include=/home/ntollena/local/include/ --with-mpfr-lib=/home/ntollena/local/lib/ --with-mpfr-include=/home/ntollena/local/include/

Une ligne de configuration (en l'occurence pour mpc, mais dans le principe
 ca doit marcher pour tout)


 La ligne utilisee, apres bien des soucis, pour gcc :

  ../gcc-5.3.0/configure --prefix=/home/ntollena/local/ --with-gmp=/home/ntollena/local --with-mpfr=/home/ntollena/local --with-mpc=/home/ntollena/local --disable-multilib

  faite dans le repertoire gcc/build.

  Bien faire pointer LD_LIBRARY_PATH sur lib.

entre LD_LIBRARY_PATH dans le .bashrc

Il faut python pour compiler clang

#22/04

Clang installé !!

Ça ne servait à rien d'installer gcc.
Commande module load permet de charger des modules.
module unload pour les décharger. 
module list pour lister les modules chargés.
module avail pour lister les modules disponibles.

Pour initialiser la commande, faire source /usr/share/modules/init/bash

Il y a entre autres gcc, python et cmake/

Sinon, pour les soucis de compilation avec clang :
Il faut préciser explicitement la bibliothèque à charger.
Ici, il faut donc ajouter -lrt à la fin de la ligne de compilation.


#25/04

Quelques notes sur le fonctionnement d'openmp.

L'implementation a deux facettes : la compilation et le runtime.

Le compilateur est chargé de transformer chacune des sections openmp
en procédure correspondante. Les variables shared sont passés par référence,
les variables privates directement dans la pile du thread, de manière à 
rendre le scope explicite. Le compilateur fait aussi appel à des fonctions 
de la bibliothèque du runtime ( appel par exemple aux fonctions kmpc... dans
l'assembleur généré par clang, appel à gomp pour gcc ).

Le runtime est ensuite de son coté chargé d'appeler les bonnes procédures
sur chacun des threads, selon l'architecture à sa disposition et les 
indications de l'OS et du programmeur ( variable OMP_NUM_THREADS par ex )
Tout ceci est sans doute à préciser.

##llvm Intermediate Representation

Assembleur, yay !!

Quelques remarques sur l'IR de llvm,

@ est utilisé pour la déclaration de variables/fonctions globales.
% est utilisé pour les variables locales.

Les préfixes permettent de ne pas s'inquiéter de collisions avec les
noms réservés (qui ne prennent pas de préfixes )

Pour les types : relativement naturel pour les entiers. i32 est un entier
stocké sur 32 bits. Notons que le nombre de bits est arbitraire.

type de fonctions : <return-type > (types des paramètres éventuels )
par ex i32 (i32, i32) prend deux entiers en arguments et renvoie un
entier.

type pointeurs : spécifiés par des étoiles, le type pointé et le nombre
d'éléments est spécifié entre crochets.
Ex : ```[4 x i32]* ``` représente un pointeur vers 4 entiers.
``` i32 (i32 *)* ``` est un pointeur vers une fonction qui prend un 
pointeur sur un entier en paramètre et renvoie un entier. 

assez naturellement, les tableaux sont représentés entre crochets :
```[5 x i16]``` est un tableau de 5 entiers de 16 bits.

cas particulier : une string constante peut être représentée par
"c"chaine constante"".

instructions binaires : ```add ty op1 op2``` 
op1 et op2 doivent etre de meme types ( entier ouéventuellement 
des vecteurs d'entiers ) on peut ajouter nsw et nuw pour "non 
signed wrapped" et "non unsigned wrapped" qui font que la valeur 
renvoyée est "empoisonné" en cas de dépassement d'entier.

fadd pour additionner des types flottants.

Des fonctions équivalentes existent pour sub, mul et div

alloca alloue de la mémoire sur la pile. Le type est obligatoire.
alloca peut prendre un nb d'éléments en deuxième argument, et un 
alignement en troisième.
Comme la variable est allouée sur la pile, elle est automatiquement
détruite à la sortie de la fonction.

Ex : alloca i32, i32 10, align 2048 ( puissance de deux obligatoire )

getelementptr sert à extraire l'adresse d'un élément d'une structure
aggrégée.

syntax :
<result> = getelementptr <ty>, <ty>* <ptrval>{, <ty> <idx>}*
<result> = getelementptr inbounds <ty>, <ty>* <ptrval>{, <ty> <idx>}*
<result> = getelementptr <ty>, <ptr vector> <ptrval>, <vector index type> <idx>

un code en C :
```
struct RT {
  char A;
  int B[10][20];
  char C;
};
struct ST {
  int X;
  double Y;
  struct RT Z;
};

int *foo(struct ST *s) {
  return &s[1].Z.B[5][13];
}
```
et le code llvm correspondant :

```
%struct.RT = type { i8, [10 x [20 x i32]], i8 }
%struct.ST = type { i32, double, %struct.RT }

define i32* @foo(%struct.ST* %s) nounwind uwtable readnone optsize ssp {
entry:
  %arrayidx = getelementptr inbounds %struct.ST, %struct.ST* %s, i64 1, i32 2, i32 1, i64 5, i64 13
  ret i32* %arrayidx
}
```

##libgomp and libomp

Le runtime de gcc N'EST PAS compatible avec un programme compilé avec
clang.

La raison est sans doute que les fonctions appelées sont différentes 
( les kmp... pour clang et GOMP... pour gcc ). On peut supposer que des
indirections permettent au runtime de clang de rediriger les appels à GOMP
vers des fonctions kmp, ce qui permet d'utiliser le runtime de clang avec
des fonctions compilées avec gcc.

Pour la compatibilité gcc -> libomp, les symboles sont définies dans 
kmp_ftn_os.h et le lien vers les fonctions kmp est fait dans kmp_gsupport.c.
Toujours bon à savoir

Fonction utile : nm permet de lister tous les symboles définis dans un 
fichier binaires exécutable. Permet de savoir quelle fonction on appelle.

Petite note : sleep caste automatiquement son argument en int, il serait
bon d'y faire quelque chose
