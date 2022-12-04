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

    query_annotation_id = module.environment_wide_queries.honeycombio_query_annotation.count_of_traces_by_telemetry_sdks.id
    query_id            = module.environment_wide_queries.honeycombio_query.count_of_traces_by_telemetry_sdks.id
    query_style         = "combo"
  }

  style = "visual"
}
