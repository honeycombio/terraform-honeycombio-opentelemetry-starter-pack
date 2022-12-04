resource "honeycombio_query" "count_of_traces_by_service" {
  dataset    = "__all__"
  query_json = "{\n  \"calculations\": [\n    {\n      \"op\": \"COUNT\"\n    }\n  ],\n  \"filters\": [\n    {\n      \"column\": \"trace.parent_id\",\n      \"op\": \"does-not-exist\"\n    }\n  ],\n  \"breakdowns\": [\n    \"service.name\"\n  ],\n  \"orders\": [\n    {\n      \"op\": \"COUNT\",\n      \"order\": \"descending\"\n    }\n  ],\n  \"time_range\": ${var.query_time_range}\n}"
}

resource "honeycombio_query_annotation" "count_of_traces_by_service" {
  dataset     = "__all__"
  description = "Gets a count of the number of traces (not the number of spans) over time.  This provides an idea of which services are generating root spans, and at which volume they're being generated."
  name        = "Trace Counts By Service"
  query_id    = honeycombio_query.count_of_traces_by_service.id
}

resource "honeycombio_query" "rate_of_bad_status_code_spans" {
  dataset    = "__all__"
  depends_on = [
    honeycombio_derived_column.dc_bad_status_code_as_a_numeric,
  ]
  query_json = "{\n  \"calculations\": [\n    {\n      \"op\": \"AVG\",\n      \"column\": \"dc_bad_status_code_rate\"\n    }\n  ],\n  \"filters\": [\n    {\n      \"column\": \"dc_ensure_nonroot_server_span\",\n      \"op\": \"=\",\n      \"value\": true\n    },\n    {\n      \"column\": \"meta.annotation_type\",\n      \"op\": \"does-not-exist\"\n    }\n  ],\n  \"breakdowns\": [\n    \"service.name\"\n  ],\n  \"orders\": [\n    {\n      \"op\": \"AVG\",\n      \"column\": \"dc_bad_status_code_rate\",\n      \"order\": \"descending\"\n    }\n  ],\n  \"time_range\": ${var.query_time_range}\n}"
}

resource "honeycombio_query_annotation" "rate_of_bad_status_code_spans" {
  dataset     = "__all__"
  description = "This uses the AVG against a Derived Column to determine the rate at which a service returns a bad status code, this could be from multiple status code fields OpenTelemetry may provide:\n- `http.status_code`\n- `rpc.grpc.status_code`\n- `status_code`"
  name        = "Average Bad Status Code Rate Across Services"
  query_id    = honeycombio_query.rate_of_bad_status_code_spans.id
}

resource "honeycombio_query" "count_of_total_spans_by_service" {
  dataset    = "__all__"
  query_json = "{\n  \"calculations\": [\n    {\n      \"op\": \"COUNT\"\n    }\n  ],\n  \"breakdowns\": [\n    \"service.name\"\n  ],\n  \"orders\": [\n    {\n      \"op\": \"COUNT\",\n      \"order\": \"descending\"\n    }\n  ],\n  \"time_range\": ${var.query_time_range}\n}"
}

resource "honeycombio_query_annotation" "count_of_total_spans_by_service" {
  dataset     = "__all__"
  description = "Gets a count of the number of spans over time from each service in the environment.  This provides an idea of which services are generating root spans, and at which volume they're being generated."
  name        = "Span Counts By Service"
  query_id    = honeycombio_query.count_of_total_spans_by_service.id
}

resource "honeycombio_query" "count_of_span_events_by_service" {
  dataset    = "__all__"
  query_json = "{\n  \"calculations\": [\n    {\n      \"op\": \"COUNT\"\n    }\n  ],\n  \"filters\": [\n    {\n      \"column\": \"meta.annotation_type\",\n      \"op\": \"=\",\n      \"value\": \"span_event\"\n    }\n  ],\n  \"breakdowns\": [\n    \"service.name\"\n  ],\n  \"orders\": [\n    {\n      \"op\": \"COUNT\",\n      \"order\": \"descending\"\n    }\n  ],\n  \"time_range\": ${var.query_time_range}\n}"
}

resource "honeycombio_query_annotation" "count_of_span_events_by_service" {
  dataset     = "__all__"
  description = "Number of span events over time, grouped by the service sending the event."
  name        = "Span Events by Service"
  query_id    = honeycombio_query.count_of_span_events_by_service.id
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

resource "honeycombio_query" "rate_of_error_spans" {
  dataset    = "__all__"
  depends_on = [
    honeycombio_derived_column.dc_error_as_a_numeric,
  ]
  query_json = "{\n  \"calculations\": [\n    {\n      \"op\": \"AVG\",\n      \"column\": \"dc_error_as_a_numeric\"\n    }\n  ],\n  \"filters\": [\n    {\n      \"column\": \"meta.annotation_type\",\n      \"op\": \"does-not-exist\"\n    },\n    {\n      \"column\": \"dc_ensure_nonroot_server_span\",\n      \"op\": \"=\",\n      \"value\": true\n    }\n  ],\n  \"breakdowns\": [\n    \"service.name\"\n  ],\n  \"orders\": [\n    {\n      \"op\": \"AVG\",\n      \"column\": \"dc_error_as_a_numeric\",\n      \"order\": \"descending\"\n    }\n  ],\n  \"time_range\": ${var.query_time_range}\n}"
}

resource "honeycombio_query_annotation" "rate_of_error_spans" {
  dataset     = "__all__"
  description = "Uses a derived column to show any span that has an $error field populated as 100, and any span without that as a 0.  This way we can VIZUALIZE the AVG of the derived column, and we'll be able to see a percentage value 0 being 0% and 100 being 100%"
  name        = "Average Error Rate Across Services"
  query_id    = honeycombio_query.rate_of_error_spans.id
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

resource "honeycombio_query" "count_of_traces_by_telemetry_sdks" {
  dataset    = "__all__"
  query_json = "{\n  \"calculations\": [\n    {\n      \"op\": \"COUNT_DISTINCT\",\n      \"column\": \"trace.trace_id\"\n    }\n  ],\n  \"breakdowns\": [\n    \"telemetry.sdk.language\",\n    \"telemetry.sdk.version\",\n    \"telemetry.sdk.name\"\n  ],\n  \"orders\": [\n    {\n      \"op\": \"COUNT_DISTINCT\",\n      \"column\": \"trace.trace_id\",\n      \"order\": \"descending\"\n    }\n  ],\n  \"time_range\": ${var.query_time_range}\n}"
}

resource "honeycombio_query_annotation" "count_of_traces_by_telemetry_sdks" {
  dataset     = "__all__"
  description = "Provides the number of traces over time, organized by the different telemetry sdk languages and versions."
  name        = "Trace Counts by Telemetry SDK"
  query_id    = honeycombio_query.count_of_traces_by_telemetry_sdks.id
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
