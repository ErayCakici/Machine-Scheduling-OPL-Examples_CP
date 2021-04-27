/* ------------------------------------------------------------

Problem Description
-------------------

A flexible resource constrained parallel machine scheduling problem is addressed. The objective studied is minimizing the number tardy jobs.

The Flexible Resource Constrained Scheduling Problem (FRCSP) is an extension of resource constrained scheduling problem which allows 
a job operation to be processed by any of available resource from a given resource set. 
In our example, each job is associated with a set of operation types which need to be processed in a specific order (known as precedence constraints). 
There is a set of alternative operations with associated type, duration, and capacity. 
Each operation also requires a set of resources with limited capacity.

This problem is known to be NP-hard. 
IBM ILOG CPLEX Optimization Studio includes solvers for both Mathematical and Constraint Programming. 
Constraint Programming is particularly efficient and useful to tackle detailed scheduling problems. 
By using OPL, you can easily formulate and solve scheduling problems in CPLEX IDE. 
Below is an example formulation with a sample data to provide a better understanding of the problem and the model.

------------------------------------------------------------ */
using CP;

//randomly generate set of jobs with an associated due date 
int nbJobs = 10;
range Jobs = 0..nbJobs-1;
int minDueDate=200;
int maxDueDate=300;
int dueDates[j in Jobs] = minDueDate+rand(maxDueDate-minDueDate+1);

//introduce set of operations 
tuple operation {
  int opId;    
  int opType; 
  int duration;   
  int capacity;
};
{operation} Operations   = ...;

//introduce set of operation types required by each job 
tuple req_op_type {
  int jobId;    
  int opType; 
};
{req_op_type} Req_op_types   = ...;

// introduce set of resources with randomly generated capacities
int nbResources = 3;
range Resources = 0..nbResources-1;
int minResourceCapacity=20;
int maxResourceCapacity=32;
int capacity[r in Resources] = minResourceCapacity+rand(maxResourceCapacity-minResourceCapacity+1);

// randomly generate resource demand by each operation
int minResourceDemand=0;
int maxResourceDemand=4;
int resourceDemand [o in Operations][r in Resources] = minResourceDemand+rand(maxResourceDemand-minResourceDemand+1);

// Create optional interval variables for each operation 
dvar interval ops_itvs[o in Operations] optional size o.duration;

// Create binary variables for tardy jobs --- 1 if job cannot complete all required operations on-time, 0 otherwise
dvar boolean isTardy[j in Jobs]; 

// Create optional interval variables for each job-operation  --- jobs will assign to operation having required types 
dvar interval job_ops_itvs[j in Jobs][o in Operations] optional size o.duration;

//define resource usage at a time
cumulFunction resourceUsage[r in Resources] = 
  sum (o in Operations: resourceDemand [o][r] >0) pulse(ops_itvs[o], resourceDemand [o][r] );

//minimize total number of tardy jobs
minimize sum(j in Jobs) isTardy[j];

subject to { 

// Capacity of resources cannot be exceeded
  forall (r in Resources)
    resourceUsage[r] <= capacity[r];
    
//Capacity of operations (batching) cannot be exceeded
  forall (o in Operations)
    sum(j in Jobs)presenceOf(job_ops_itvs[j][o])<=o.capacity;
    
//Ensure that if a job is assigned to an operation then operation should be performed    
  forall (j in Jobs, o in Operations) 
    synchronize(job_ops_itvs[j][o],all(o1 in Operations:o1.opId==o.opId) ops_itvs[o1]);
  forall (j in Jobs, o in Operations) 
    presenceOf(job_ops_itvs[j][o])<=presenceOf(ops_itvs[o]);    
 
//define tardy jobs 
  forall (j in Jobs, o in Operations) 
    endOf(job_ops_itvs[j][o])-dueDates[j]<=9999*isTardy[j];
    
//on-time jobs should be assigned to all required op types 
  forall (j in Jobs, rot in Req_op_types:j==rot.jobId) 
    1 - isTardy[j] == sum(o in Operations:o.opType==rot.opType)presenceOf(job_ops_itvs[j][o]);

//no overlap   
   forall (j in Jobs)  
     noOverlap(all(o in Operations)job_ops_itvs[j][o]);

//precedence constraints 
   forall (j in Jobs, o1 in Operations, o2 in Operations:o1.opId<o2.opId)  
     endBeforeStart(job_ops_itvs[j][o1], job_ops_itvs[j][o2]);    
           
}





