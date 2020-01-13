include "globals.mzn";
% workshop 2
% select a set of trade negotiation party
enum NEGOTIATOR;
NEGOTIATOR: dummy;
int: inf = 99999;

int: l; % minimum party size
int: u; % maximum party size
int: m; % minimum joint ability

array[NEGOTIATOR] of int: honor;
array[NEGOTIATOR,NEGOTIATOR] of int: joint;

array[1..length(honor)] of var NEGOTIATOR: aux;

var int: strength = sum(i, j in aux where i < j) (joint[i,j]);

array[1..length(honor)] of var int: honors = [honor[i] | i in aux];
array[1..length(honor)] of var int: honors2 = [if honors[i] == 0 then inf else honors[i] endif | i in 1..length(honor) ];

var int: obj = min(honors2);

constraint at_least(length(honor)-u, aux, dummy);
constraint at_most(length(honor)-l, aux, dummy);
constraint forall(i in 1..length(honor)-1) (aux[i] >= (aux[i] != dummy) + aux[i+1]);
constraint strength >= m;

solve satisfy;

set of NEGOTIATOR: party :: output_only 
                      = { fix(aux[i]) | i in 1..length(honor) } diff { dummy };

output ["party = \(party);\nobj = \(obj);\nstrength = \(strength);"];

