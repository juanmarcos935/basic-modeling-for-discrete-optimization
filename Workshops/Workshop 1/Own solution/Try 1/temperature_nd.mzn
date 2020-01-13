int: start;

array[int] of int: readings;

array[1..length(readings)+1] of var int: temp;

constraint temp[1] = start;

constraint forall(i in 2..length(readings))
  (temp[i] = ((temp[i-1] + readings[i-1]) div 2));
  
constraint temp[length(readings)+1] = (temp[length(readings)] + readings[length(readings)]) div 2;

solve satisfy;

output ["temp = \(temp)"];