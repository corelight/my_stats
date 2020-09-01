module my_stats;

export {
    redef enum Log::ID += { MY_STATS_LOG };
}

# Output record
type MyStatsInfo: record 
    {
    ts:                         time        &log;
    node:                       string      &log;
    variable:                   string      &log;
    size:                       count       &log;
    };

event dump_global_stats()
    {
    # Cluster::log(cat(global_sizes()));
    local i: MyStatsInfo;
    local gs = global_sizes();
    for (key,val in gs)
        {
        i$ts = current_time();
        i$variable = key;
        i$size = gs[key];
        i$node = Cluster::node;
        Log::write(MY_STATS_LOG, i);
        }
    schedule 1 min { dump_global_stats() };
    }

event zeek_init()
    {
    Log::create_stream(MY_STATS_LOG, [$columns=MyStatsInfo, $path="my_stats"]);
    schedule 10 secs { dump_global_stats() };
    }