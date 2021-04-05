/* ------------------------------------------------------------

Problem Description
-------------------

The objective studied is minimizing the sum of maximum lateness (tardiness) on a single machine with release times.

Each job is associated with proccesing time, release time and due date. 
A job is tardy if the completion time of job j is later than the due date. 
All jobs need to be processed on the single machine and preemption is not allowed.

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

// randomly generate due date for each job
int minDueDate=75;
int maxDueDate=200;
int dueDates[j in Jobs]=minDueDate+rand(maxDueDate-minDueDate+1);

// randomly generate release time for each job
int minReleaseTime=1;
int maxReleaseTime=50;
int releaseTimes[j in Jobs]=minReleaseTime+rand(maxReleaseTime-minReleaseTime+1);

// introduce decision variables
dvar interval itvs[j in Jobs] size processingTimes[j];
dvar sequence singlemachine in all(j in Jobs) itvs[j];

// minimize maximum lateness 
minimize max(j in Jobs) maxl(0,endOf(itvs[j])-dueDates[j]);

subject to {
  // ensure that jobs start after release times
  forall (j in Jobs)
    startOf(itvs[j])>=releaseTimes[j];   
  // No overlap between jobs
    noOverlap(singlemachine);   
}


