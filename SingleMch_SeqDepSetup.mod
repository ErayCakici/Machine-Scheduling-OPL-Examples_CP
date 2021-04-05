/* ------------------------------------------------------------

Problem Description
-------------------

The objective studied is minimizing the makespan (completion time of latest job) on a single machine with sequence dependent setup times.
Each job is associated with a proccesing time, all jobs need to be processed on the single machine and preemption is not allowed.
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

// randomly generate setup times between jobs
int minSetUpTime=5;
int maxSetUpTime=10;
tuple triplet { 
int j1; 
int j2; 
int setuptime; }
{triplet} SetUpMatrix={ <j1,j2,minSetUpTime+rand(maxSetUpTime-minSetUpTime)> | j1,j2 in Jobs : j1 != j2};

// introduce decision variables
dvar interval itvs[j in Jobs] size processingTimes[j];
dvar sequence singlemachine in all(j in Jobs) itvs[j] types all(j in Jobs) j;

// minimize maximum lateness 
minimize max(j in Jobs) (endOf(itvs[j]));

subject to {
    noOverlap(singlemachine,SetUpMatrix);   
}

