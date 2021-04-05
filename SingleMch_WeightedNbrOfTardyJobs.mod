/* ------------------------------------------------------------

Problem Description
-------------------

The objective studied is minimizing total weighted number of tardy jobs.

Each job is associated with:
- proccesing time
- due date
- weight

A job is tardy if the completion time of job j is later than the due date. 
All jobs need to be processed on the single machine and preemption is not allowed.

This problem is known to be NP-hard, even when the jobs all have common due date. 
IBM ILOG CPLEX Optimization Studio includes solvers for both Mathematical and Constraint Programming. 
Constraint Programming is particularly efficient and useful to tackle such detailed scheduling problems.  
By using OPL, you can easily formulate and solve scheduling problems. 
Below is an example formulation with randomly generated sample data to provide 
a better understanding of the problem and the code.

------------------------------------------------------------ */

using CP;

int nbJobs = 10;
range Jobs = 0..nbJobs-1;

// randomly generate processing time for each job
int minProcessingTime=10;
int maxProcessingTime=40;
int processingTimes[j in Jobs]=minProcessingTime+rand(maxProcessingTime-minProcessingTime);

int bigM=sum(j in Jobs)processingTimes[j]; //a very big number - to be used in constraints

// randomly generate due date for each job
int minDueDate=75;
int maxDueDate=200;
int dueDates[j in Jobs]=minDueDate+rand(maxDueDate-minDueDate);

// randomly generate weight for each job
int minWeight=1;
int maxWeight=5;
int weights[j in Jobs]=minWeight+rand(maxWeight);

// introduce decision variables
dvar boolean isTardy[j in Jobs]; 
dvar interval itvs[j in Jobs] size processingTimes[j];
dvar sequence singlemachine in all(j in Jobs) itvs[j];

// minimize total weighted number of tardy jobs 
minimize sum(j in Jobs) isTardy[j]*weights[j];

subject to {
  // define tardy jobs
  forall (j in Jobs)
    (endOf(itvs[j])-dueDates[j])<=bigM*(isTardy[j]);    
    
  // No overlap between jobs
    noOverlap(singlemachine);   
}

