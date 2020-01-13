include "globals.mzn";

int: n;

array[1..n] of var 1..n: order;

array[1..n-1] of var 1..n-1: diffs = [abs(order[i+1]-order[i]) | i in 1..n-1];

constraint alldifferent(diffs);

constraint alldifferent(order);

solve satisfy;

output [show(order[i]) ++ " " | i in 1..n] ++ ["\n"]
       ++ [" "] ++ [show(diffs[i]) ++ " " | i in 1..n-1];