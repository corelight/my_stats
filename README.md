# my_stats

This package collects statistics in a Zeek cluster where it is loaded.  It creates
a new log called "my_stats" where the output from "global_sizes" occurs 
every minute (this interval is configurable).  

Each execution of the function is keyed in the log so that individual runs can be pulled.

More documentation in the form of a blog post will be coming soon.