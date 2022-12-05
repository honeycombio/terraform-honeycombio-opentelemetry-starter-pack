
resource "honeycombio_query" "heatmap_duration" {
  dataset    = "__all__"
  query_json = "{\n  \"calculations\": [\n    {\n      \"op\": \"HEATMAP\",\n      \"column\": \"duration_ms\"\n    }\n  ],\n  \"time_range\": ${var.query_time_range}\n}"
}

resource "honeycombio_query_annotation" "heatmap_duration" {
  dataset     = "__all__"
  description = "Heatmap of the `duration_ms` attribute for all services in the environment"
  name        = "Standard Duration Heatmap"
  query_id    = honeycombio_query.heatmap_duration.id
}

resource "honeycombio_query" "heatmap_log10_duration" {
  dataset    = "__all__"
  depends_on = [
    honeycombio_derived_column.dc_log10_duration_all,
  ]
  query_json = "{\n  \"calculations\": [\n    {\n      \"op\": \"HEATMAP\",\n      \"column\": \"dc_log10_duration_all\"\n    }\n  ],\n  \"time_range\": ${var.query_time_range}\n}"
}

resource "honeycombio_query_annotation" "heatmap_log10_duration" {
  dataset     = "__all__"
  description = "This shows a LOG10 representation of the `duration_ms` attribute value of the service:\n\n- 0.x values correlate to a duration of <1ms to 10ms\n- 1.x values correlate to a duration between 10ms and 100ms\n- 2.x values correlate to a duration between 100ms and 1000ms"
  name        = "Logarithmic Duration Heatmap"
  query_id    = honeycombio_query.heatmap_log10_duration.id
}

resource "honeycombio_query" "count_long_duration_spans" {
  dataset    = "__all__"
  query_json = "{\n  \"calculations\": [\n    {\n      \"op\": \"COUNT\"\n    }\n  ],\n  \"filters\": [\n    {\n      \"column\": \"duration_ms\",\n      \"op\": \">=\",\n      \"value\": ${var.min_long_duration}\n    },\n    {\n      \"column\": \"duration_ms\",\n      \"op\": \"<\",\n      \"value\": ${var.max_long_duration}\n    }\n  ],\n  \"breakdowns\": [\n    \"service.name\"\n  ],\n  \"orders\": [\n    {\n      \"op\": \"COUNT\",\n      \"order\": \"descending\"\n    }\n  ],\n  \"time_range\": ${var.query_time_range}\n}"
}

resource "honeycombio_query_annotation" "count_long_duration_spans" {
  dataset     = "__all__"
  description = "Displays the number of spans with a `duration_ms` running longer than ${var.min_long_duration} milliseconds, but also sets an upper bound of ${var.max_long_duration} milliseconds to limit long running tasks of some services from skewing the data"
  name        = "High Duration Span Count"
  query_id    = honeycombio_query.count_long_duration_spans.id
}

resource "honeycombio_query" "percentiles_of_duration" {
  dataset    = "__all__"
  query_json = "{\n  \"calculations\": [\n    {\n      \"op\": \"P999\",\n      \"column\": \"duration_ms\"\n    },\n    {\n      \"op\": \"P99\",\n      \"column\": \"duration_ms\"\n    },\n    {\n      \"op\": \"P95\",\n      \"column\": \"duration_ms\"\n    },\n    {\n      \"op\": \"P90\",\n      \"column\": \"duration_ms\"\n    },\n    {\n      \"op\": \"P75\",\n      \"column\": \"duration_ms\"\n    },\n    {\n      \"op\": \"P50\",\n      \"column\": \"duration_ms\"\n    }\n  ],\n  \"breakdowns\": [\n    \"service.name\"\n  ],\n  \"orders\": [\n    {\n      \"op\": \"P999\",\n      \"column\": \"duration_ms\",\n      \"order\": \"descending\"\n    }\n  ],\n  \"time_range\": ${var.query_time_range}\n}"
}

resource "honeycombio_query_annotation" "percentiles_of_duration" {
  dataset     = "__all__"
  description = "A series of percentile line graphs focusing on span duration, grouped by the `service.name` attribute"
  name        = "Duration Percentiles By Service"
  query_id    = honeycombio_query.percentiles_of_duration.id
}







resource "honeycombio_query" "count_of_traces_by_db_system" {
  dataset    = "__all__"
  query_json = "{\n  \"calculations\": [\n    {\n      \"op\": \"COUNT_DISTINCT\",\n      \"column\": \"trace.trace_id\"\n    }\n  ],\n  \"filters\": [\n    {\n      \"column\": \"db.system\",\n      \"op\": \"exists\"\n    }\n  ],\n  \"breakdowns\": [\n    \"db.system\"\n  ],\n  \"orders\": [\n    {\n      \"op\": \"COUNT_DISTINCT\",\n      \"column\": \"trace.trace_id\",\n      \"order\": \"descending\"\n    }\n  ],\n  \"time_range\": ${var.query_time_range}\n}"
}

resource "honeycombio_query_annotation" "count_of_traces_by_db_system" {
  dataset     = "__all__"
  description = "Displays the number of trace interacting with a Database where the [type of database](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/trace/semantic_conventions/database.md#connection-level-attributes) is included in the span attributes."
  name        = "Database Systems Spans"
  query_id    = honeycombio_query.count_of_traces_by_db_system.id
}

resource "honeycombio_query" "count_distinct_traces_by_protocol" {
  dataset    = "__all__"
  depends_on = [
    honeycombio_derived_column.dc_protocols,
  ]
  query_json = "{\n  \"calculations\": [\n    {\n      \"op\": \"COUNT_DISTINCT\",\n      \"column\": \"trace.trace_id\"\n    }\n  ],\n  \"filters\": [\n    {\n      \"column\": \"dc_protocols\",\n      \"op\": \"exists\"\n    }\n  ],\n  \"breakdowns\": [\n    \"dc_protocols\"\n  ],\n  \"orders\": [\n    {\n      \"op\": \"COUNT_DISTINCT\",\n      \"column\": \"trace.trace_id\",\n      \"order\": \"descending\"\n    }\n  ],\n  \"time_range\": ${var.query_time_range}\n}"
}

resource "honeycombio_query_annotation" "count_distinct_traces_by_protocol" {
  dataset     = "__all__"
  description = "Displays the number of traces utilizing different data protocols like HTTP/2 and GRPC"
  name        = "Protocol Utilization"
  query_id    = honeycombio_query.count_distinct_traces_by_protocol.id
}

