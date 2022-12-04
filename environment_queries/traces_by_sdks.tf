data "honeycombio_query_specification" "count_of_traces_by_telemetry_sdks" {
  calculation {
    op     = "COUNT_DISTINCT"
    column = "trace.trace_id"
  }

  breakdowns = [
    "telemetry.sdk.language",
    "telemetry.sdk.version",
    "telemetry.sdk.name"
  ]

  order {
    column = "trace.trace_id"
    op = "COUNT_DISTINCT"
    order = "descending"
  }

  time_range = var.query_time_range

  # depends_on = [
  #   honeycombio_column.dynsampler_sample_rate_avg,
  #   honeycombio_column.rulessampler_sample_rate_avg,
  #   honeycombio_column.rulessampler_num_dropped,
  # ]
}

resource "honeycombio_query" "count_of_traces_by_telemetry_sdks" {
  dataset    = "__all__"
  query_json = data.honeycombio_query_specification.count_of_traces_by_telemetry_sdks.json
}

resource "honeycombio_query_annotation" "count_of_traces_by_telemetry_sdks" {
  dataset     = "__all__"
  description = "Provides the number of traces over time, organized by the different telemetry sdk languages and versions."
  name        = "Trace Counts by Telemetry SDK"
  query_id    = honeycombio_query.count_of_traces_by_telemetry_sdks.id
}
