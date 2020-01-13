include "globals.mzn";

int: n;

array[1..n] of var 1..n: order;

array[1..n] of var 1..n: posn;

constraint abs(posn[1]-posn[n]) = 1;

constraint inverse(order,posn);

array[1..n-1] of var 1..n-1: diffs = [abs(order[i+1]-order[i]) | i in 1..n-1];

array[1..n-1] of var 1..n-1: dposn;

constraint dposn[n-1] = min(posn[1],posn[n]);

constraint inverse(diffs,dposn);

solve satisfy;

output ["order = \(order);\ndiffs = \(diffs);\nposn = \(posn);\ndposn = \(dposn);\n"];

