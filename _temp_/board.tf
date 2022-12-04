resource "honeycombio_board" "all_services_board" {
  column_layout = "multi"
  description   = "Queries run across all services in the environment"
  name          = "All Services Board"

  query {
    graph_settings {
      hide_markers        = "false"
      log_scale           = "false"
      omit_missing_values = "false"
      stacked_graphs      = "false"
      utc_xaxis           = "false"
    }

    query_annotation_id = honeycombio_query_annotation.count_of_traces_by_service.id
    query_id            = honeycombio_query.count_of_traces_by_service.id
    query_style         = "combo"
  }

  query {
    graph_settings {
      hide_markers        = "false"
      log_scale           = "false"
      omit_missing_values = "false"
      stacked_graphs      = "false"
      utc_xaxis           = "false"
    }

    query_annotation_id = honeycombio_query_annotation.count_of_total_spans_by_service.id
    query_id            = honeycombio_query.count_of_total_spans_by_service.id
    query_style         = "combo"
  }

  query {
    graph_settings {
      hide_markers        = "false"
      log_scale           = "false"
      omit_missing_values = "false"
      stacked_graphs      = "false"
      utc_xaxis           = "false"
    }

    query_annotation_id = honeycombio_query_annotation.count_of_span_events_by_service.id
    query_id            = honeycombio_query.count_of_span_events_by_service.id
    query_style         = "combo"
  }

  query {
    graph_settings {
      hide_markers        = "false"
      log_scale           = "false"
      omit_missing_values = "false"
      stacked_graphs      = "false"
      utc_xaxis           = "false"
    }

    query_annotation_id = honeycombio_query_annotation.rate_of_error_spans.id
    query_id            = honeycombio_query.rate_of_error_spans.id
    query_style         = "combo"
  }

  query {
    graph_settings {
      hide_markers        = "false"
      log_scale           = "false"
      omit_missing_values = "false"
      stacked_graphs      = "false"
      utc_xaxis           = "false"
    }

    query_annotation_id = honeycombio_query_annotation.rate_of_bad_status_code_spans.id
    query_id            = honeycombio_query.rate_of_bad_status_code_spans.id
    query_style         = "combo"
  }

  query {
    graph_settings {
      hide_markers        = "false"
      log_scale           = "false"
      omit_missing_values = "false"
      stacked_graphs      = "false"
      utc_xaxis           = "false"
    }

    query_annotation_id = honeycombio_query_annotation.heatmap_duration.id
    query_id            = honeycombio_query.heatmap_duration.id
    query_style         = "graph"
  }

  query {
    graph_settings {
      hide_markers        = "false"
      log_scale           = "false"
      omit_missing_values = "false"
      stacked_graphs      = "false"
      utc_xaxis           = "false"
    }

    query_annotation_id = honeycombio_query_annotation.heatmap_log10_duration.id
    query_id            = honeycombio_query.heatmap_log10_duration.id
    query_style         = "graph"
  }

  query {
    graph_settings {
      hide_markers        = "false"
      log_scale           = "false"
      omit_missing_values = "false"
      stacked_graphs      = "false"
      utc_xaxis           = "false"
    }

    query_annotation_id = honeycombio_query_annotation.count_long_duration_spans.id
    query_id            = honeycombio_query.count_long_duration_spans.id
    query_style         = "combo"
  }

  query {
    graph_settings {
      hide_markers        = "false"
      log_scale           = "false"
      omit_missing_values = "false"
      stacked_graphs      = "false"
      utc_xaxis           = "false"
    }

    query_annotation_id = honeycombio_query_annotation.percentiles_of_duration.id
    query_id            = honeycombio_query.percentiles_of_duration.id
    query_style         = "combo"
  }

  query {
    graph_settings {
      hide_markers        = "false"
      log_scale           = "false"
      omit_missing_values = "false"
      stacked_graphs      = "false"
      utc_xaxis           = "false"
    }

    query_annotation_id = honeycombio_query_annotation.count_of_traces_by_telemetry_sdks.id
    query_id            = honeycombio_query.count_of_traces_by_telemetry_sdks.id
    query_style         = "combo"
  }

  query {
    graph_settings {
      hide_markers        = "false"
      log_scale           = "false"
      omit_missing_values = "false"
      stacked_graphs      = "false"
      utc_xaxis           = "false"
    }

    query_annotation_id = honeycombio_query_annotation.count_distinct_traces_by_protocol.id
    query_id            = honeycombio_query.count_distinct_traces_by_protocol.id
    query_style         = "combo"
  }

  query {
    graph_settings {
      hide_markers        = "false"
      log_scale           = "false"
      omit_missing_values = "false"
      stacked_graphs      = "false"
      utc_xaxis           = "false"
    }

    query_annotation_id = honeycombio_query_annotation.count_of_traces_by_db_system.id
    query_id            = honeycombio_query.count_of_traces_by_db_system.id
    query_style         = "combo"
  }

  style = "visual"
}
