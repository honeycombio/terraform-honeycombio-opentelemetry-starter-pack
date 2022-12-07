terraform {
  required_version = ">= 0.13"
  required_providers {
    honeycombio = {
      source  = "honeycombio/honeycombio"
      version = "0.11.2"
    }
  }
}

provider "honeycombio" {
  api_key = var.honeycomb_api_key
  # You can supply this via the environment variable HONEYCOMB_API_KEY or by setting the value in a .tfvars file
}

resource "honeycombio_dataset" "required-columns-dataset" {
  count       = var.create_required_columns_dataset ? 1 : 0
  name        = var.required_columns_dataset_name
  description = "This dataset was created to ensure that all necessary columns exist in an environment that are required for the Golden OTEL Starter Pack"
}

module "environment_wide_derived_columns" {
  source                               = "./environment_derived_columns"
  honeycomb_api_key                    = var.honeycomb_api_key
  required_columns_dataset_name        = var.required_columns_dataset_name
  include_rpc_protocol_info_in_queries = var.include_rpc_protocol_info_in_queries
  count_400s_as_errors                 = var.count_400s_as_errors

  depends_on = [
    honeycombio_dataset.required-columns-dataset
  ]
}

module "environment_wide_queries" {
  source                          = "./environment_queries"
  honeycomb_api_key               = var.honeycomb_api_key
  required_columns_dataset_name   = var.required_columns_dataset_name
  query_time_range                = var.query_time_range
  min_long_duration               = var.min_long_duration
  max_long_duration               = var.max_long_duration
  dc_log10_duration               = module.environment_wide_derived_columns.dc_log10_duration_alias
  dc_protocols                    = module.environment_wide_derived_columns.dc_protocols_alias
  dc_bad_status_code_as_a_numeric = module.environment_wide_derived_columns.dc_bad_status_code_as_a_numeric_alias
  dc_error_as_a_numeric           = module.environment_wide_derived_columns.dc_error_as_a_numeric_alias
  dc_ensure_nonroot_server_span   = module.environment_wide_derived_columns.dc_ensure_nonroot_server_span_alias
  depends_on = [
    honeycombio_dataset.required-columns-dataset,
    module.environment_wide_derived_columns
  ]
}

module "environment_wide_boards" {
  source                                            = "./environment_boards"
  honeycomb_api_key                                 = var.honeycomb_api_key
  count_of_traces_by_service_id                     = module.environment_wide_queries.count_of_traces_by_service_id
  count_of_traces_by_service_annotation_id          = module.environment_wide_queries.count_of_traces_by_service_annotation_id
  count_of_traces_by_http_status_code_id            = module.environment_wide_queries.count_of_traces_by_http_status_code_id
  count_of_traces_by_http_status_code_annotation_id = module.environment_wide_queries.count_of_traces_by_http_status_code_annotation_id
  count_of_total_spans_by_service_id                = module.environment_wide_queries.count_of_total_spans_by_service_id
  count_of_total_spans_by_service_annotation_id     = module.environment_wide_queries.count_of_total_spans_by_service_annotation_id
  count_of_span_events_by_service_id                = module.environment_wide_queries.count_of_span_events_by_service_id
  count_of_span_events_by_service_annotation_id     = module.environment_wide_queries.count_of_span_events_by_service_annotation_id
  rate_of_error_spans_id                            = module.environment_wide_queries.rate_of_error_spans_id
  rate_of_error_spans_annotation_id                 = module.environment_wide_queries.rate_of_error_spans_annotation_id
  rate_of_bad_status_code_spans_id                  = module.environment_wide_queries.rate_of_bad_status_code_spans_id
  rate_of_bad_status_code_spans_annotation_id       = module.environment_wide_queries.rate_of_bad_status_code_spans_annotation_id
  count_of_traces_by_telemetry_sdks_id              = module.environment_wide_queries.count_of_traces_by_telemetry_sdks_id
  count_of_traces_by_telemetry_sdks_annotation_id   = module.environment_wide_queries.count_of_traces_by_telemetry_sdks_annotation_id
  heatmap_duration_id                               = module.environment_wide_queries.heatmap_duration_id
  heatmap_duration_annotation_id                    = module.environment_wide_queries.heatmap_duration_annotation_id
  heatmap_log10_duration_id                         = module.environment_wide_queries.heatmap_log10_duration_id
  heatmap_log10_duration_annotation_id              = module.environment_wide_queries.heatmap_log10_duration_annotation_id
  count_long_duration_spans_id                      = module.environment_wide_queries.count_long_duration_spans_id
  count_long_duration_spans_annotation_id           = module.environment_wide_queries.count_long_duration_spans_annotation_id
  percentiles_of_duration_id                        = module.environment_wide_queries.percentiles_of_duration_id
  percentiles_of_duration_annotation_id             = module.environment_wide_queries.percentiles_of_duration_annotation_id
  count_of_traces_by_db_system_id                   = module.environment_wide_queries.count_of_traces_by_db_system_id
  count_of_traces_by_db_system_annotation_id        = module.environment_wide_queries.count_of_traces_by_db_system_annotation_id
  count_distinct_traces_by_protocol_id              = module.environment_wide_queries.count_distinct_traces_by_protocol_id
  count_distinct_traces_by_protocol_annotation_id   = module.environment_wide_queries.count_distinct_traces_by_protocol_annotation_id
  depends_on = [
    honeycombio_dataset.required-columns-dataset,
    module.environment_wide_derived_columns,
    module.environment_wide_queries
  ]
}
