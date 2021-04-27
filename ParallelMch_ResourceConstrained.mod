/* ------------------------------------------------------------

Problem Description
-------------------

A parallel machine scheduling problem with resource constraints is addressed. The objective studied is minimizing the completion time of latest task (makespan).

There is a set of tasks (with precedence relationships) and all tasks need to be performed on one of the machines. 
There is also a set of resources (with limited capacity) and certain resources are required for processing of certain tasks. 
Machines can only process one task at a given time and resource capacities cannot be exceeded.

This problem is known to be NP-hard. 
IBM ILOG CPLEX Optimization Studio includes solvers for both Mathematical and Constraint Programming. 
Constraint Programming is particularly efficient and useful to tackle detailed scheduling problems. 
By using OPL, you can easily formulate and solve scheduling problems in CPLEX IDE. 
Below is an example formulation with a sample data to provide a better understanding of the problem and the model.

This model is adapted from resource-constrained scheduling example which can be found among OPL examples in <Install_dir>/opl/examples/opl or thru OPL IDE File-->Import-->Example-->IBM ILOG OPL Examples

------------------------------------------------------------ */
using CP;

int nbTasks = 10;
range Tasks = 0..nbTasks-1;

int nbMachines = 3;

// randomly generate processing time for each task
int minProcessingTime=10;
int maxProcessingTime=40;
int processtime[t in Tasks] = minProcessingTime+rand(maxProcessingTime-minProcessingTime);

int nbResources = 3;
range Resources = 0..nbResources-1;

// randomly generate resource capacities
int minResourceCapacity=4;
int maxResourceCapacity=12;
int capacity[r in Resources] = minResourceCapacity+rand(maxResourceCapacity-minResourceCapacity+1);

// randomly generate resource demand by each task 
int minResourceDemand=0;
int maxResourceDemand=4;
int resourceDemand [t in Tasks][r in Resources] = minResourceDemand+rand(maxResourceDemand-minResourceDemand+1);

// introduce decision variables
dvar interval itvs[t in Tasks] size processtime[t];

//define resource usage at a time
cumulFunction resourceUsage[r in Resources] = 
  sum (t in Tasks: resourceDemand [t][r] >0) pulse(itvs[t], resourceDemand [t][r] );
  
//define machine usage at a time
cumulFunction tasks_atATime = 
  sum (t in Tasks) pulse(itvs[t], 1);

//minimize makespan
minimize max(t in Tasks) endOf(itvs[t]);

subject to {  
// Capacity of resources cannot be exceeded
  forall (r in Resources)
    resourceUsage[r] <= capacity[r];
// tasks at a time cannot exceed number of machines
    tasks_atATime <= nbMachines;
    
}

execute {
  for (var j in Tasks) {
        writeln("Task " + j + " starts at " +  itvs[j].start);
        writeln("Task " + j + " ends at " +  itvs[j].end);   
 }
}



