module my_stats;

export {
    redef enum Log::ID += { MY_STATS_LOG };
}

# Output record
type MyStatsInfo: record 
    {
    ts:                         time        &log;
    global_sizes:               string      &log;
    };

event dump_global_stats()
    {
    # Cluster::log(cat(global_sizes()));
    local i: MyStatsInfo();
    i$ts = current_time();
    i$global_sizes = cat(global_sizes());
    Log::write(MY_STATS_LOG, i);
    schedule 1 min { dump_global_stats() };
    }

event zeek_init()
    {
    Log::create_stream(MY_STATS_LOG, [$columns=MyStatsInfo, $path="my_stats"]);
    schedule 10 secs { dump_global_stats() };
    }