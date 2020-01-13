int: start;
array[int] of int: readings;
enum ACTIONS = {strongly_cool, cool, do_nothing, heat, strongly_heat};
array[ACTIONS] of int: benefit = [-5, -2, 0, 1, 4];
array[ACTIONS] of int: cost = [9, 3, 0, 1, 5];


array[1..length(readings)] of var ACTIONS: choice;
array[1..length(readings)+1] of var int: temp;

constraint temp[1] = start;

constraint forall(i in 2..length(readings)+1)
  (temp[i] = (((temp[i-1]+readings[i-1]) div 2) + benefit[choice[i-1]]));

constraint forall(i in 2..length(readings)+1)
  (temp[i] >= 25);

constraint forall(i in 2..length(readings)+1)
  (temp[i] <= 30);
  
var int: total = sum(i in 1..length(readings))
  (cost[choice[i]]);
  
solve minimize total;

output ["temp = \(temp) \nchoice = \(choice) \ncost = \(total) "];
  
  