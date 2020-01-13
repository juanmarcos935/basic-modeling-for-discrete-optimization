int: n; % number of court members
set of int: COURT = 1..n;
int: emperor = 1;
array[COURT] of int: rank;
array[COURT] of int: ability;

int: m; % number of horses
set of int: HORSE = 1..m;
array[HORSE] of int: beauty;
array[HORSE] of int: speed;

array[COURT,HORSE] of int: enjoy;

array[COURT] of var HORSE union {0}: horse;


constraint forall(i, j in COURT where rank[i] < rank[j]) (
 horse[j] = 0 -> horse[i] = 0
);

constraint sum(i in COURT) (horse[i] > 0) = min(n, m);


include "alldifferent_except_0.mzn";
constraint alldifferent_except_0(horse);

constraint forall(i in 2..n where horse[i] != 0) (enjoy[i, horse[i]] < enjoy[1, horse[1]]);


constraint forall(i, j in COURT where rank[i] < rank[j] /\ horse[i] != 0 /\ horse[j] != 0) (
    horse[i] = 0 \/
    (horse[i] = 0 /\ horse[j] = 0) \/
    beauty[horse[i]] <= beauty[horse[j]]
);


constraint forall(i in COURT where horse[i] != 0)(
    enjoy[i, horse[i]] >= 0
);


array[HORSE] of var COURT union {0}: court;
constraint forall(i in COURT, j in HORSE) (
   (horse[i] = j <-> court[j] = i)
);

var int: penalty = sum([1 | i, j in HORSE where 
        speed[i] < speed[j] /\ court[j] != 0 /\
        ((court[i] != 0 /\ ability[court[i]] > ability[court[j]]) \/
        court[i] = 0)
]);


var int: overall_enjoyment = sum(i in 1..n where horse[i] != 0) (enjoy[i, horse[i]]);
var int: obj = overall_enjoyment - 100*penalty;
solve maximize obj;

output ["rider = \(court);\nhorse = \(horse);\n",  "obj = \(obj);"];
