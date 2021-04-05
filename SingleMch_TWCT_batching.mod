/* ------------------------------------------------------------

Problem Description
-------------------

The objective studied is minimizing the sum of weighted completion times on a single "batching" machine. 
Batching machines can process simultaneously up to a specified number of the jobs of a particular family (type).

Each job is associated with proccesing time, weight and family (type).
This problem is known to be NP-hard. 
IBM ILOG CPLEX Optimization Studio includes solvers for both Mathematical and Constraint Programming. 
Constraint Programming is particularly efficient and useful to tackle detailed scheduling problems. 
By using OPL, you can easily formulate and solve scheduling problems in CPLEX IDE. 
Below is an example formulation with randomly generated sample data to provide a better understanding of the problem and the model.
------------------------------------------------------------ */

using CP;

int nbJobs = 10;
range Jobs = 0..nbJobs-1;

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

// define batching capacity
int batchCapacity=2;

// introduce decision variables
dvar interval itvs[j in Jobs] size processingTimes[j];

statefunction s;   //to be used in incompatible job families(types) constraint
cumulFunction f = sum(j in Jobs)pulse(itvs[j],1);  //to be used in batching capacity

// minimize total weighted completion times 
minimize sum(j in Jobs) endOf(itvs[j])*weights[j];

subject to { 
   //batch capacity cannot be exceeded
     f<=batchCapacity;
     
   //only jobs of the same type can be processed simultaneously  - incompatible job families (types)
    forall(j in Jobs) 
     alwaysEqual(s, itvs[j], jobTypes[j]);
    
} 

