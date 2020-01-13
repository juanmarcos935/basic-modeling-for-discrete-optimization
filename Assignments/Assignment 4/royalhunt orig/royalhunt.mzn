include "globals.mzn";

int: n; % number of court members
set of int: COURT = 1..n;
set of int: COURT1 = 1..n-1;
int: emperor = 1;
array[COURT] of int: rank;
array[COURT] of int: ability;

int: m; % number of horses
set of int: HORSE = 1..m;
set of int: HORSE1 = 1..m-1;
array[HORSE] of int: beauty;
array[HORSE] of int: speed;

array[COURT,HORSE] of int: enjoy;

array[COURT] of var HORSE union {0}: horse;
array[HORSE] of var COURT union {0}: court;

array[HORSE] of int: times_h = [1 |i in HORSE];
array[HORSE] of int: horses = [i |i in HORSE];
array[COURT] of int: times_c = [1 |i in COURT];
array[COURT] of int: courts = [i |i in COURT];

constraint if n > m then global_cardinality(horse,horses,times_h)
else global_cardinality(court,courts,times_c) endif;

constraint if n > m then inverse([horse[i] | i in 1..m],court) else inverse(horse,[court[i] | i in 1..n]) endif;

constraint forall(i in 2..n where horse[i] != 0)(enjoy[emperor,horse[emperor]] > enjoy[i,horse[i]]);

constraint forall(i, j in COURT where rank[i] > rank[j] /\ horse[i] != 0 /\ horse[j] != 0) (beauty[horse[i]] >= beauty[horse[j]] \/
                horse[j] = 0 \/
                (horse[j] = 0 /\ horse[i] = 0));
                
                
var int: penalty = sum([100 | i, j in HORSE where
                              speed[i] > speed[j] /\
                              ability[court[i]] < ability[court[j]] /\
                              court[i] != 0 /\
                              (court[i] != 0 /\ court[j] != 0)]);

var int: obj1 = sum(i in court where i != 0)(enjoy[i,horse[i]]);

var int: obj = obj1 + penalty * -1;

solve maximize obj;

output ["horse = \(horse);\nobj = \(obj);\n"];