/* ------------------------------------------------------------

Problem Description
-------------------

A flexible job shop scheduling problem is addressed. The objective studied is minimizing the completion time of latest job (makespan).

The Flexible Job Shop Problem (FJSP) is an extension of job shop scheduling problem which allows an operation to be processed by any machine from a given machine set. 
Each job is associated with a set of operations which need to be processed in a specific order (known as precedence constraints). 
Only one operation in a job can be processed at a given time and machines can only process one job at a time.

This problem is known to be NP-hard. 
IBM ILOG CPLEX Optimization Studio includes solvers for both Mathematical and Constraint Programming. 
Constraint Programming is particularly efficient and useful to tackle detailed scheduling problems. 
By using OPL, you can easily formulate and solve scheduling problems in CPLEX IDE. 
Below is an example formulation with a sample data to provide a better understanding of the problem and the model.

This model is adapted from flexible job shop scheduling example which can be found among OPL examples in <Install_dir>/opl/examples/opl or thru OPL IDE File-->Import-->Example-->IBM ILOG OPL Examples

------------------------------------------------------------ */
using CP;

int nbJobs = 10;
range Jobs = 0..nbJobs-1;

int nbMachines = 3;
range Machines = 0..nbMachines-1;

//introduce operations of each job
tuple jobOperation {
  string opId;    // Operation id
  int jobId; // Job id
  int position;   // Position in job
};
{jobOperation} jobOperations   = ...;

//introduce processing time of operations at eligible machines
tuple operationMachine {
  string opId; // Operation id
  int mchId;  // Machine id
  int proc_time;   // Processing time
};
{operationMachine}      operationMachines = ...;

// Position of last operation of job j
int jlast[j in Jobs] = max(o in jobOperations: o.jobId==j) o.position;

// introduce decision variables
dvar interval jobops[jobOperations]; 
dvar interval opsmchs[om in operationMachines] optional size om.proc_time;
dvar sequence mchs[m in Machines] in all(om in operationMachines: om.mchId == m) opsmchs[om];

//minimize makespan
minimize max(j in Jobs, o in jobOperations: o.position==jlast[j]) endOf(jobops[o]);

subject to {
//Each operation must start after the end of the predecessor  
  forall (j in Jobs, o1 in jobOperations, o2 in jobOperations: o1.jobId==j && o2.jobId==j && o2.position==1+o1.position)
    endBeforeStart(jobops[o1],jobops[o2]);
    
//job operation intervals can only take value if one of alternative operation-machines intervals take value
  forall (o in jobOperations)
    alternative(jobops[o], all(om in operationMachines: om.opId==o.opId) opsmchs[om]);

//ensure no overlap for operations executed on a same machine    
  forall (m in Machines)
    noOverlap(mchs[m]);
}

execute {
  for (var om in operationMachines) {
    if (opsmchs[om].present)
      writeln("Operation " + om.opId + " on machine " + om.mchId + " starting at " + opsmchs[om].start);
  }
}


