/* ------------------------------------------------------------

Problem Description
-------------------

A flow shop scheduling problem is addressed. The objective studied is minimizing the completion time of latest job (makespan).

There is a set of n jobs, a set of m machines, and each job is associated with a set of operations. 
Each job can be processed only at one machine at a time, and each machine can process only one job at a time. 
Flow shop scheduling is a special case of job shop scheduling where there is strict order of "all" operations to be performed on "all" jobs. 
The i-th operation of the job must be executed on the i-th machine. 

This problem is known to be NP-hard. IBM ILOG CPLEX Optimization Studio includes solvers for both Mathematical and Constraint Programming. Constraint Programming is particularly efficient and useful to tackle detailed scheduling problems. By using docplex.cp python package, you can easily formulate and solve scheduling problems in python notebooks. Below is an example formulation with randomly generated sample data to provide a better understanding of the problem and the model.
IBM ILOG CPLEX Optimization Studio includes solvers for both Mathematical and Constraint Programming. 
Constraint Programming is particularly efficient and useful to tackle detailed scheduling problems. 
By using OPL, you can easily formulate and solve scheduling problems in CPLEX IDE. 
Below is an example formulation with randomly generated sample data to provide a better understanding of the problem and the model.

This model is adapted from flow shop scheduling example which can be found among OPL examples in <Install_dir>/opl/examples/opl or thru OPL IDE File-->Import-->Example-->IBM ILOG OPL Examples
------------------------------------------------------------ */
using CP;

int nbJobs = 10;
range Jobs = 0..nbJobs-1;

int nbMachines = 3;
range Machines = 0..nbMachines-1;

// randomly generate processing time for each job and each machine 
int minProcessingTime=10;
int maxProcessingTime=40;
int processtime[j in Jobs][m in Machines] = minProcessingTime+rand(maxProcessingTime-minProcessingTime);

// introduce decision variables
dvar interval itvs[j in Jobs][m in Machines] size processtime[j][m];
dvar sequence mchs[m in Machines] in all(j in Jobs) itvs[j][m];

// minimize makespan - in this example, it is assumed that jobs are processed in the order of machine number, therefore machine with highest number is the last machine to be processed on
minimize max(j in Jobs) endOf(itvs[j][nbMachines-1]);

subject to { 
// Ensure no overlap for operations executed on the same machine
  forall (m in Machines)
    noOverlap(mchs[m]);
// Each operation must start after the end of the predecessor - assumed that jobs are processed in the order of machine number
  forall (j in Jobs, m in 0..nbMachines-2)
    endBeforeStart(itvs[j][m], itvs[j][m+1]);
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

