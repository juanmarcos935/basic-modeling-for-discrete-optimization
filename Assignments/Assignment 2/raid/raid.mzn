% assignment 2
% select a set of raiding warrior
enum WARRIOR;
WARRIOR: dummy; 
enum CLAN; % the clan they belong too

int: l; % minimum raid party size
int: u; % maximum raid party size
int: m; % limit of hatreds

array[WARRIOR] of int: strength;
array[WARRIOR] of CLAN: clan;

array[CLAN,CLAN] of 0..1: hates;

array[1..u] of var WARRIOR: raid;

constraint forall(i in 1..l) (raid[i] > dummy);
constraint forall(i in 1..u-1) (raid[i] >= (raid[i] != dummy) + raid[i+1]);

var int: obj = sum(i in raid) (strength[i]);

var int: hatreds = sum(i, j in raid where i < j /\ i != dummy /\ j != dummy) (hates[clan[i],clan[j]]);

constraint hatreds <= m;

solve maximize obj;

output ["raid = {"] ++ [if fix(raid[i]) != dummy then show(raid[i])
++ if i < length(strength) /\ fix(raid[i+1]) != dummy then ", " else "" endif
else "" endif | i in 1..length(strength)] ++ ["};\nobj = \(obj);"];