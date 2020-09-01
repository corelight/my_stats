module dump_stats;

export {
}

event dump_global_stats()
    {
    Cluster::log(cat(global_sizes()));
    schedule 1 min { dump_global_stats() };
    }

event zeek_init()
    {
    schedule 10 secs { dump_global_stats() };
    }