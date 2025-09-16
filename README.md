# my_stats

This package collects statistics in a Zeek cluster where it is loaded.  It creates
a new log called "my_stats" where the output from "global_container_footprints" occurs 
every minute (this interval is configurable).  

Each execution of the function is keyed in the log so that individual runs can be pulled.

This package can be installed with the following command:

```zkg install my_stats```

More documentation in the form of a blog post will be coming soon.
