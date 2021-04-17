/* ------------------------------------------------------------

Problem Description
-------------------

The objective studied is minimizing the completion time of latest job (makespan). 
Unrelated parallel machine scheduling problem with sequence- and machine-dependent setup times is addressed. 
Each job is associated with a proccesing time and needs to be processed by one of the machines. Preemption is not allowed.
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

// randomly generate processing time for each job
int minProcessingTime=10;
int maxProcessingTime=40;
int processingTimes[j in Jobs]=minProcessingTime+rand(maxProcessingTime-minProcessingTime);

// randomly generate setup times between jobs
int minSetUpTime=5;
int maxSetUpTime=10;
tuple setup { 
int j1; 
int j2; 
int setuptime; }

{setup} SetUpMatrix[m in Machines] ={ <j1,j2,minSetUpTime+rand(maxSetUpTime-minSetUpTime)> | j1,j2 in Jobs : j1 != j2};

// introduce decision variables
dvar interval itvs[j in Jobs][m in Machines] optional size processingTimes[j];
dvar sequence machine[m in Machines] in all(j in Jobs) itvs[j][m] types all(j in Jobs) j;

// minimize makespan
minimize max(j in Jobs,m in Machines) (endOf(itvs[j][m]));

subject to { 

//each job should be assigned to a machine
forall (j in Jobs) 
  	sum(m in Machines) (presenceOf(itvs[j][m])) ==1;
  	
//no overlap
forall (m in Machines) 
    noOverlap(machine[m],SetUpMatrix[m]);   
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

