module my_stats;

export {
    redef enum Log::ID += { MY_STATS_LOG };
}

# Used to track executions for easier sorting later.
global current_run: count = 0;

# Output record
type MyStatsInfo: record 
    {
    ts:                         time        &log;
    run:                        count       &log;
    node:                       string      &log;
    module_name:                string      &log &optional;
    variable:                   string      &log;
    size:                       count       &log;
    };

event dump_global_stats()
    {
    # Cluster::log(cat(global_sizes()));
    local i: MyStatsInfo;
    i$run = current_run;
    current_run += 1;
    local gs = global_sizes();
    for (key,val in gs)
        {
        i$ts = current_time();
        local split_key = split_string(key, /::/);
        if (|split_key| > 1)
            {
            i$module_name = split_key[0];
            }
        else
            {
            i$module_name = "";
            }
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