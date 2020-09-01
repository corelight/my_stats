module dump_stats;

export {

}

event zeek_init()
    {
    Cluster::log(cat(global_sizes()));
    }