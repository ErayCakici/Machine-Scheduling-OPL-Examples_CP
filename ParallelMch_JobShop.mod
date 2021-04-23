/* ------------------------------------------------------------

Problem Description
-------------------

A job shop scheduling problem is addressed. The objective studied is minimizing the completion time of latest job (makespan).

Jobs need to be scheduled on m parallel machines. 
Each job is associated with a set of operations which need to be processed in a specific order (known as precedence constraints). 
Each operation has a specific machine that it needs to be processed on, only one operation in a job can be processed at a given time and machines can only process one job at a time.

This problem is known to be NP-hard. IBM ILOG CPLEX Optimization Studio includes solvers for both Mathematical and Constraint Programming. Constraint Programming is particularly efficient and useful to tackle detailed scheduling problems. By using docplex.cp python package, you can easily formulate and solve scheduling problems in python notebooks. Below is an example formulation with randomly generated sample data to provide a better understanding of the problem and the model.
IBM ILOG CPLEX Optimization Studio includes solvers for both Mathematical and Constraint Programming. 
Constraint Programming is particularly efficient and useful to tackle detailed scheduling problems. 
By using OPL, you can easily formulate and solve scheduling problems in CPLEX IDE. 
Below is an example formulation with randomly generated sample data to provide a better understanding of the problem and the model.

This model is adapted from job shop scheduling example which can be found among OPL examples in <Install_dir>/opl/examples/opl or thru OPL IDE File-->Import-->Example-->IBM ILOG OPL Examples
------------------------------------------------------------ */
using CP;

int nbJobs = 10;
range Jobs = 0..nbJobs-1;

int nbMachines = 3;
range Machines = 0..nbMachines-1;

// randomly generate processing time for each job operation 
// in this example, it is assumed that each job's number of operations is equal to number machines 
int minProcessingTime=10;
int maxProcessingTime=40;
int processtime[j in Jobs][o in Machines] = minProcessingTime+rand(maxProcessingTime-minProcessingTime);

// introduce decision variables
dvar interval itvs[j in Jobs][o in Machines] size processtime[j][o];

// in this example, it is assumed that each job operation is assigned to machine with same number
dvar sequence mchs[m in Machines] in all(j in Jobs, o in Machines : o == m) itvs[j][o];

// minimize makespan
minimize max(j in Jobs) endOf(itvs[j][nbMachines-1]);

subject to { 
// Ensure no overlap for operations executed on the same machine
  forall (m in Machines)
    noOverlap(mchs[m]);
// Each operation must start after the end of the predecessor
  forall (j in Jobs, o in 0..nbMachines-2)
    endBeforeStart(itvs[j][o], itvs[j][o+1]);
} 

execute {
  for (var j in Jobs) {
    for (var o in Machines) {
      if (itvs[j][o].present) {
        writeln("Job " + j + " on machine " + o + " starts at " +  itvs[j][o].start);
        writeln("Job " + j + " on machine " + o + " ends at " +  itvs[j][o].end);
         } 
    }      
  }
}

