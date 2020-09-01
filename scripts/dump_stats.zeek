module dump_stats;

export {

}

event zeek_init()
    {
    Cluster::log(global_sizes());
    }