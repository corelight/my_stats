This package collects statistics in a cluster where it is loaded.  It creates
a new log called "my_stats" where the output from "global_sizes" occurs 
every minute (this is configurable).  Each execution of the function is keyed in the log so that 
individual runs can be pulled.