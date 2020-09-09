module my_stats;

export {
    redef enum Log::ID += { MY_STATS_LOG };
    # This is how often global_sizes() is called and reported.
    global run_interval: interval = 1 min;
    # This is the minimum size a variable must be in order to be logged.
    # Set to zero to log everything.
    global min_var_size_to_log = 0;
}

# Used to track executions for easier sorting later.
global current_run: count = 0;

# Output record
type MyStatsInfo: record 
    {
    ts:                         time        &log;
    run:                        count       &log;
    node:                       string      &log;
    module_name:                string      &log &default="GLOBAL";
    variable:                   string      &log;
    size:                       count       &log;
    };

event dump_global_stats()
    {
    current_run += 1;
    local start_time = current_time();
    local gs = global_sizes();
    local end_time = current_time();
    Cluster::log(fmt("global_sizes() took %s to run.", end_time-start_time));
    for (key,val in gs)
        {
        if (val >= min_var_size_to_log)
            {
            local i: MyStatsInfo;
            i = [$ts=current_time(), $run=current_run, 
                $node=Cluster::node, $variable=key, $size=val];
            local split_key = split_string(key, /::/);
            if (|split_key| > 1)
                {
                i$module_name = split_key[0];
                }
            Log::write(MY_STATS_LOG, i);
            }
        }
    schedule run_interval { dump_global_stats() };
    }

event zeek_init()
    {
    Log::create_stream(MY_STATS_LOG, [$columns=MyStatsInfo, $path="my_stats"]);
    schedule 10 secs { dump_global_stats() };
    }