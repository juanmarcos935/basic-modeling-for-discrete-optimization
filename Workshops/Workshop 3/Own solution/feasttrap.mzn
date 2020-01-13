include "alldifferent.mzn";
% Beauty Trap
% Create the most magnificient feast 
enum DISH;
enum TASTE = {spicy, sour, salty, sweet, umame, bland};
enum TEMP = {hot, cold, warm};
%int: ndish;
%set of int: DISH = 1..ndish;
%set of int: TASTE = 1..6;
%int: spicy = 1; int: sour = 2; int: salty = 3; int: sweet = 4; int: umame = 5; int: bland = 6;
%set of int: TEMP = 1..3;
%int: hot = 1; int: cold = 2; int: warm = 3;


array[DISH] of TASTE: taste;
array[DISH] of TEMP: temp;
array[DISH] of bool: heavy;
array[DISH] of int: value;

int: len; % length of banquet
set of int: COURSE = 1..len;
set of int: COURSEminusOne = 1..len-1;
set of int: COURSEminusTwo = 1..len-2;

array[COURSE] of var DISH: dish;

constraint alldifferent(dish);

constraint forall(i in COURSEminusOne) (taste[dish[i]] != taste[dish[i+1]]);

constraint taste[dish[1]] = salty;
constraint taste[dish[len]] = sweet;

constraint forall(i in COURSEminusOne) ((taste[dish[i]] = spicy) -> (taste[dish[i+1]] = bland) \/ (taste[dish[i+1]] = sweet));

constraint forall(i in COURSEminusOne) ((taste[dish[i]] = sour) -> (taste[dish[i+1]] = bland) \/ (taste[dish[i+1]] = umame));

constraint forall(i in COURSEminusOne) ((taste[dish[i]] = sweet) -> (taste[dish[i+1]] = salty) \/ (taste[dish[i+1]] = sour) \/ (taste[dish[i+1]] = bland));

constraint forall(i in COURSEminusOne) ((temp[dish[i]] = hot) -> 
(temp[dish[i+1]] = hot) \/ (temp[dish[i+1]] = warm));

constraint forall(i in COURSEminusTwo) ((heavy[dish[i]] = true /\ heavy[dish[i+1]] = true) -> (heavy[dish[i+2]] = false));

var int: obj1 = sum(i in dish) (value[i]);
var int: obj2 = sum([1 | i in COURSEminusOne where taste[dish[i]] != taste[dish[i+1]]]);
var int: obj3 = sum([1 | i in COURSEminusOne where temp[dish[i]] != temp[dish[i+1]]]);
var int: obj4 = sum([1 | i in COURSEminusOne where heavy[dish[i]] != heavy[dish[i+1]]]);

var int: obj = obj1 + obj2 + obj3 + obj4;

solve maximize obj;

output ["dish = \(dish);\nobj = \(obj);"];