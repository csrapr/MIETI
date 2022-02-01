
param N_Operations, integer, > 0;
/* number of tasks */

param N_Workst, integer, >0;
/* number of workstation */

param N_devices;
# Number of diveces to process per shift

param Tshift;
# Shift time in seconds, 8h minus 23 minutes * Efficiency  * OOE

param PCT := Tshift / N_devices;
# Projected Cicle Time

set I := 1..N_Operations;
# set of tasks

param Operacoes{i in I, j in 1..2};
# Access of data provided 

param p{i in I}:= Operacoes[i,1] >= 0;
/* processing time of task i is loaded from  Operations, column 2*/

#segunda tentativa
param w{i in I}:= Operacoes[i,2] >= 0;
/* workstation of the task i is loaded from  Operations, column 3*/

param totalP:= sum {i in 1..N_Operations} p[i];
# total time of processing time of operations to produce one device

param N_Colab:= ceil(N_devices*totalP/Tshift);
# minimum number of colaborators to process the requireded production _ceil gives the next intiger;

set J := 1..N_Workst;
/* set of workstations */

set K := 1..N_Colab;
/* set of Colaboretors */

var x{i in I, j in J, k in K}, binary;
# assignment variable

#var y{i in I, k in K}, binary;
# assignment variable

var TPC{k in K}, >=0;
# Total processing time assigned to colaborator

var Tmax, >=0;
var TROCA{i in I,k in K}, binary;
#var To{i in I}, binary;
#var Tmin, >=0;
#var changes{j in J, k in K}, binary;

#minimize changes of an operator
#minimize obj{i in I, k in K}: y[i, k];

minimize obj: sum{i in I,k in K} TROCA[i,k];
#minimize obj{i in I}: Tmax + (To[i]*10);
#maximize dif between PCT and TPCmin
#maximize obj: PCT - Tmin;

#sum{i in I, j in J, k in K} p[i]* x[i,j,k]
/* the objective is to find a cheapest assignment */

#segunda tentativa
s.t. control_A{i in 1..N_Operations-1, k in K}: sum{j in J} x[i,j,k] <= sum{j in J} x[i+1,j,k]+ TROCA[i,k];

s.t. tac{i in I}: sum{k in K} x[i,w[i], k] = 1;
#each  task must be assigned exactly to one colaborator

/*
#primeira tentativa
s.t. tac{i in I}: sum{j in J, k in K} x[i,j, k] = 1;

#each  task must be assigned exactly to one colaborator 

s.t. assignWorkst{i in I}: sum{j in J} y[i, j] = 1;
#each task must be assigned to only one workstation
*/

s.t. TtimmeLim{k in K}: sum{i in I}  p[i]* x[i,w[i],k] = TPC[k];
/* each colaborator has a limit of time that must be respected */


#s.t. WorkstConst{i in I}: sum{k in K} x[i,w[i],k] = 1;
/*each task belongs to a specific workstation*/

s.t. Control_1{k in K}: sum {i in I, j in J}  p[i]* x[i,j,k]=TPC[k];

s.t. Control_2{k in K}: TPC[k]<=Tmax;

s.t. Control_3{k in K}: Tmax<= PCT;

#s.t. Control_4{k in K}: Tmin<= TPC[k];

#s.t. Control_4{i in I, k in K}: sum{j in J} x[i,j,k] <= N_devices*y[i,k];

#s.t. Control_5{i in 1..N_Operations-1, k in K}: y[i,k] <= y[i+1, k] + To[i];


