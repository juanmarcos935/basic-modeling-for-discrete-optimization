% Beauty Trap
% Perform the most seductive dance
include "globals.mzn";

enum LEGS = {spin, leap, waltz, curtsey, prep, stand};
enum ARMS = {beckon, out, up, wrapped, neutral};
enum FACE = {smile, wink, batt, think, glow, blank};

int: maxlen;
set of int: STEP = 1..maxlen;
set of int: STEPminusThree = 1..maxlen-3;
set of int: STEPminusOne = 1..maxlen-1;
set of int: STEPplusOne = 1..maxlen+1;
array[LEGS] of int: maxlegs;
array[ARMS] of int: maxarms;
array[FACE] of int: maxface;
constraint assert(maxlegs[stand] >= maxlen, "maxlegs[stand] smaller than maxlen");
constraint assert(maxarms[neutral] >= maxlen, "maxarms[neutral] smaller than maxlen");
constraint assert(maxface[blank] >= maxlen, "maxface[blank] smaller than maxlen");
array[LEGS,ARMS] of int: dance_value;
array[ARMS,FACE] of int: entice_value;
constraint assert(dance_value[stand,neutral] = 0, "incorrect dance_value array");
constraint assert(entice_value[neutral,blank] = 0, "incorrect entice_value array");
int: boredom; % how bored each step make the viewer

var STEP: len;
array[STEP] of var LEGS: legs;
array[STEP] of var ARMS: arms;
array[STEP] of var FACE: face;

len = length(face) - 1;

array[1..7, LEGS] of int: automata_legs =
[| 2, 0, 4, 5, 6, 7       % Init, 1
 | 0, 0, 0, 5, 6, 7       % Spin, 2
 | 2, 0, 4, 0, 0, 7       % Leap, 3
 | 2, 0, 4, 5, 6, 7       % Waltz, 4
 | 2, 0, 4, 5, 0, 7       % Curtsey, 5
 | 2, 3, 4, 5, 6, 7       % Prep, 6
 | 2, 0, 4, 5, 6, 7 |];   % Stand, 7
 
array[1..6, ARMS] of int: automata_arms =
[| 0, 3, 4, 5, 6          % Init, 1
 | 0, 3, 4, 5, 6          % Beckon, 2
 | 2, 0, 4, 0, 6          % Out, 3
 | 2, 3, 0, 0, 6          % Up, 4
 | 0, 3, 4, 0, 6          % Wrapped, 5
 | 0, 3, 4, 5, 6 |];      % Neutral, 6
 
array[1..7, FACE] of int: automata_face =
[| 2, 3, 4, 5, 6, 7       % Init, 1
 | 2, 3, 4, 0, 6, 7       % Smile, 2
 | 2, 3, 4, 5, 6, 7       % Wink, 3
 | 2, 3, 4, 0, 6, 7       % Batt, 4
 | 2, 3, 4, 5, 6, 7       % Think, 5
 | 2, 3, 4, 5, 6, 7       % Glow, 6
 | 2, 3, 4, 5, 6, 7 |];   % Blank, 7

constraint regular(legs, card(LEGS)+1, card(LEGS), automata_legs, 1, {7});
constraint regular(arms, card(ARMS)+1, card(ARMS), automata_arms, 1, {6});
constraint regular(face, card(FACE)+1, card(FACE), automata_face, 1, {7});

                  
constraint forall(i in 1..len-3)
                 ((legs[i] = waltz) /\ (legs[i+1] = waltz) /\ (legs[i+2] = waltz) -> (legs[i+3] != waltz));
                  
constraint forall(c in 1..len-1)
                 (legs[c] = waltz -> 
                  forall(c1 in c+1..len)
                        (legs[c1] = curtsey -> 
                         exists(c2 in c+1..c1-1)(legs[c2] = stand)));
                         

constraint forall(i in 1..len-2)
                 ((face[i] = face[i+1]) /\ (face[i+1] = face[i+2]) ->
                 face[i] = blank);


constraint global_cardinality_low_up_closed(legs, [i |i in LEGS], [0 | i in LEGS], [m | m in maxlegs]);

constraint global_cardinality_low_up_closed(arms, [i |i in ARMS], [0 | i in ARMS], [m | m in maxarms]);

constraint global_cardinality_low_up_closed(face, [i |i in FACE], [0 | i in FACE], [m | m in maxface]);

var int: sum1 = sum([dance_value[legs[i],arms[j]] | i,j in 1..maxlen where i = j]);

var int: sum2 = sum([entice_value[arms[i],face[j]] | i,j in 1..maxlen where i = j]);

var int: obj = sum1 + sum2 - boredom * len;

solve maximize obj;

output ["len = \(len);\nlegs = \(legs);\narms = \(arms);\nface = \(face);\nobj = \(obj);"];
