/* ------------------------------------------------------------

Problem Description
-------------------

The objective studied is minimizing the sum of weighted tardiness on a parallel machine scheduling environment. 
Batching machines can process simultaneously up to a specified number of the jobs of a particular family (type).
Each job is associated with proccesing time, weight, due date and family (type).
This problem is known to be NP-hard. 
IBM ILOG CPLEX Optimization Studio includes solvers for both Mathematical and Constraint Programming. 
Constraint Programming is particularly efficient and useful to tackle detailed scheduling problems. 
By using OPL, you can easily formulate and solve scheduling problems in CPLEX IDE. 
Below is an example formulation with randomly generated sample data to provide a better understanding of the problem and the model.

------------------------------------------------------------ */
using CP;

int nbJobs = 10;
range Jobs = 0..nbJobs-1;

int nbMachines = 3;
range Machines = 0..nbMachines-1;

// randomly generate a job type and processing time for each job
int nbTypes = 3;
range Types = 0..nbTypes-1;
int minProcessingTime=10;
int maxProcessingTime=40;
int jobTypeProcessingTimes[t in Types]=minProcessingTime+rand(maxProcessingTime-minProcessingTime);
int jobTypes[j in Jobs]=rand(nbTypes);
int processingTimes[j in Jobs]=jobTypeProcessingTimes[jobTypes[j]];

// randomly generate weight for each job
int minWeight=1;
int maxWeight=5;
int weights[j in Jobs]=minWeight+rand(maxWeight);

// randomly generate due date for each job
int minDueDate=10;
int maxDueDate=60;
int dueDates[j in Jobs]=minDueDate+rand(maxDueDate-minDueDate);

// define batching capacity
int batchCapacity=2;

// introduce decision variables
dvar interval itvs[j in Jobs][m in Machines] optional size processingTimes[j];

statefunction s[m in Machines] ;   //to be used in incompatible job families(types) constraint
cumulFunction f[m in Machines] = sum(j in Jobs)pulse(itvs[j][m],1);  //to be used in batching capacity

// minimize total weighted tardiness
minimize sum(j in Jobs,m in Machines) weights[j]*maxl(0,(endOf(itvs[j][m])-dueDates[j])); 

subject to { 
//each job should be assigned to a machine
forall (j in Jobs) 
  	sum(m in Machines) (presenceOf(itvs[j][m])) ==1;

//batch capacity cannot be exceeded
forall (m in Machines) 
     f[m]<=batchCapacity;
     
//only jobs of the same type can be processed simultaneously  - incompatible job families (types)
forall(m in Machines)
  forall(j in Jobs) 
    alwaysEqual(s[m], itvs[j][m], jobTypes[j]); 
} 

execute {
  for (var j in Jobs) {
    for (var m in Machines) {
      if (itvs[j][m].present) {
        writeln("Job " + j + " on machine " + m + " starts at " +  itvs[j][m].start);
        writeln("Job " + j + " on machine " + m + " ends at " +  itvs[j][m].end);
         } 
    }      
  }
}

