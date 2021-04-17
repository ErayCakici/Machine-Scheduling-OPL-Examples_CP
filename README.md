# Scheduling-Examples_CP_OPL

Constraint programming formulations for different machine scheduling problems are provided in this repository. 

Optimization models are formulated in Optimization Programming Language (OPL) and solved with IBM ILOG CPLEX CP Optimizer.

Problems addressed are: 
- [Single machine scheduling to minimize weighted number of tardy jobs](https://github.com/ErayCakici/Scheduling-OPL-Examples_CP/blob/main/SingleMch_WeightedNbrOfTardyJobs.mod) 
- [Single machine scheduling to minimize maximum lateness (with release times)](https://github.com/ErayCakici/Scheduling-OPL-Examples_CP/blob/main/SingleMch_MinMaxLateness.mod)
- [Single machine scheduling to minimize total weighted completion times (with precedence constraints)](https://github.com/ErayCakici/Scheduling-OPL-Examples_CP/blob/main/SingleMch_TWCT_precedence.mod)
- [Single machine scheduling to minimize total weighted completion times (with batching and incompatible job families)](https://github.com/ErayCakici/Scheduling-OPL-Examples_CP/blob/main/SingleMch_TWCT_batching.mod)
- [Single machine scheduling to minimize makespane (with sequence dependent setup times)](https://github.com/ErayCakici/Scheduling-OPL-Examples_CP/blob/main/SingleMch_SeqDepSetup.mod)
- [Parallel machine scheduling to minimize makespan](https://github.com/ErayCakici/Scheduling-OPL-Examples_CP/blob/main/ParallelMch_Makespan.mod) 
- [Parallel machine scheduling to minimize total weighted tardiness (with batching and incompatible job families)](https://github.com/ErayCakici/Scheduling-OPL-Examples_CP/blob/main/ParallelMch_TWT_Batching.mod) 
- [Parallel machine scheduling to minimize makespan (with sequence dependent setup times and unrelated machines)](https://github.com/ErayCakici/Scheduling-OPL-Examples_CP/blob/main/ParallelMch_UnrelatedSeqDep.mod) 
- To be continued

Same problems are formulated in Python at [Scheduling-DOCPLEX-Examples_CP](https://github.com/ErayCakici/Scheduling-DOCPLEX-Examples_CP) repository. 
