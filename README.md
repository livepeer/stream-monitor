# stream-monitor

A tool to exercise Livepeer e2e by continuously running test streams,
monitoring their output, and surfacing the resulting metrics to prometheus.

## Running

Starting this tool on your local machine is a 3 step process.

1. clone this repository
2. create a `.env` with the following contents
```
INJEST_URL= # can be created at livepeer.com
PLAYBACK_URL= # can be created at livepeer.com
REGION= # used to label prometheus metrics
DURATION= # lenght of time to stream before cycling
```
3. Run: `docker-compose up`

## What's included

When you `docker-compose up` 3 services will boot:

1. prometheus
2. grafana
3. monitor

The monitor, which is the important service here, will run a prometheus exporter on port 9090
and also continuously run stream-tester sessions, pausing for a grace period between each stream.

## Monitoring

To see metrics output for the monitor you can view the following:

- *Prometheus* at http://localhost:9090
- *Exporter* at https://localhost:9091/metrics
- *Grafana* at http://localhost:3000 import `./dashboard.json` and configure prometheus datasource

## Metrics

The following metrics are surfaced:

- active_tests
- total_tests
- segment_duration
- segment_latency
- startup_latency

The source of truth is looking at https://localhost:9091/metrics

## Notes

Output is buffered so when tailing the logs with docker you will notice the
output rate is not realtime. We could accelerate the output rate by using PTY
to call stream-tester but this doesn't seem necessary at the moment.
