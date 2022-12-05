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

    query_id            = var.count_of_traces_by_service_id
    query_annotation_id = var.count_of_traces_by_service_annotation_id
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

    query_id            = var.count_of_traces_by_http_status_code_id
    query_annotation_id = var.count_of_traces_by_http_status_code_annotation_id
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

    query_id            = var.count_of_total_spans_by_service_id
    query_annotation_id = var.count_of_total_spans_by_service_annotation_id
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

    query_id            = var.count_of_span_events_by_service_id
    query_annotation_id = var.count_of_span_events_by_service_annotation_id
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

    query_id            = var.rate_of_error_spans_id
    query_annotation_id = var.rate_of_error_spans_annotation_id
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

    query_id            = var.rate_of_bad_status_code_spans_id
    query_annotation_id = var.rate_of_bad_status_code_spans_annotation_id
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

    query_id            = var.count_of_traces_by_telemetry_sdks_id
    query_annotation_id = var.count_of_traces_by_telemetry_sdks_annotation_id
    query_style         = "combo"
  }

  style = "visual"
}
