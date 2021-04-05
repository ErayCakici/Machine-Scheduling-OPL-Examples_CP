/* ------------------------------------------------------------

Problem Description
-------------------

The objective studied is minimizing the sum of weighted completion times on a single machine with precedence constraints.

Each job is associated with proccesing time and weight. 
There are precendence relationships which must be satisfied in the schedule. 
A job can only start its processing after all the predecessor jobs have been completed.

This problem is known to be NP-hard. 
IBM ILOG CPLEX Optimization Studio includes solvers for both Mathematical and Constraint Programming. 
Constraint Programming is particularly efficient and useful to tackle detailed scheduling problems. 
By using OPL, you can easily formulate and solve scheduling problems in CPLEX IDE. 
Below is an example formulation with randomly generated sample data to provide a better understanding of the problem and the model.

------------------------------------------------------------ */

using CP;

int nbJobs = 10;
range Jobs = 0..nbJobs-1;

// randomly generate processing time for each job
int minProcessingTime=10;
int maxProcessingTime=40;
int processingTimes[j in Jobs]=minProcessingTime+rand(maxProcessingTime-minProcessingTime);

// randomly generate weight for each job
int minWeight=1;
int maxWeight=5;
int weights[j in Jobs]=minWeight+rand(maxWeight);

// randomly generate precedence relationships
{int} subsetJobs={j | j in Jobs:j>=nbJobs/2};
int subsetRandLimit=3; 
int predecessor[j in subsetJobs]=rand(subsetRandLimit); //one of smallest 3 numbered jobs are randomly selected as predecessor for some of bigger numbered jobs 

// introduce decision variables
dvar interval itvs[j in Jobs] size processingTimes[j];
dvar sequence singlemachine in all(j in Jobs) itvs[j];

// minimize total weighted completion times 
minimize sum(j in Jobs) endOf(itvs[j])*weights[j];

subject to { 
    // no overlap between jobs
      noOverlap(singlemachine);   
    // precedence constraints
    forall (j in Jobs:j>=nbJobs/2)
      endBeforeStart(itvs[predecessor[j]], itvs[j]);;  
} 

