int: n;

array[1..n] of var 0..9: arr;

constraint sum(arr) = product(arr);

constraint forall(i in 1..n-1) 
  (arr[i] <= arr[i+1]);

solve satisfy;

output["Arreglo = \(arr)"];