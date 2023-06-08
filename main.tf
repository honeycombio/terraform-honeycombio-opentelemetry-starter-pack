####################################################
# Create Dataset to Contain all Required Columns
####################################################
resource "honeycombio_dataset" "required-columns-dataset" {
  count       = var.create_required_columns_dataset && var.create_required_columns ? 1 : 0
  name        = var.required_columns_dataset_name
  description = "This dataset was created to ensure that all necessary columns exist in an environment that are required for the OpenTelemetry Starter Pack"
}

data "honeycombio_columns" "all" {
  count   = var.create_required_columns_dataset && var.create_required_columns ? 1 : 0
  dataset = var.required_columns_dataset_name
}

####################################################
# Create Required Columns
####################################################
locals {
  required_columns = {
    "db.system"              = "string",
    "db.type"                = "string",
    "duration_ms"            = "float",
    "error"                  = "boolean",
    "http.flavor"            = "string",
    "http.status_code"       = "integer",
    "meta.annotation_type"   = "string",
    "rpc.grpc.status_code"   = "integer",
    "rpc.system"             = "string",
    "service.name"           = "string",
    "span.kind"              = "string",
    "status_code"            = "integer",
    "trace.parent_id"        = "string",
    "trace.trace_id"         = "string",
    "telemetry.sdk.language" = "string",
    "telemetry.sdk.version"  = "string",
    "telemetry.sdk.name"     = "string",
  }

  cols_to_create = setsubtract(keys(local.required_columns), data.honeycombio_columns.all[0].names)

  required_rpc_columns = {
    "rpc.grpc.status_code" = "integer",
    "rpc.system"           = "string",
  }

  rpccols_to_create = setsubtract(keys(local.required_rpc_columns), data.honeycombio_columns.all[0].names)
}

output "columns_created" {
  value = setunion(local.cols_to_create, local.rpccols_to_create)
}

resource "honeycombio_column" "required_columns" {
  for_each = toset(local.cols_to_create)

  name    = each.key
  type    = lookup(local.required_columns, each.key, "string")
  dataset = var.required_columns_dataset_name
  depends_on = [
    honeycombio_dataset.required-columns-dataset
  ]
}

resource "honeycombio_column" "required_rpc_columns" {
  for_each = toset(local.rpccols_to_create)

  name    = each.key
  type    = lookup(local.required_rpc_columns, each.key, "string")
  dataset = var.required_columns_dataset_name
  depends_on = [
    honeycombio_dataset.required-columns-dataset
  ]
}

####################################################
# Create Derived Columns for the Environment
####################################################
module "environment_wide_derived_columns" {
  source                               = "./modules/environment_derived_columns"
  required_columns_dataset_name        = var.required_columns_dataset_name
  include_rpc_protocol_info_in_queries = var.include_rpc_protocol_info_in_queries
  count_400s_as_errors                 = var.count_400s_as_errors

  depends_on = [
    honeycombio_dataset.required-columns-dataset,
    honeycombio_column.required_columns,
    honeycombio_column.required_rpc_columns
  ]
}

####################################################
# Create Saved Queries for Environment-Wide Queries
####################################################
module "environment_wide_queries" {
  source                          = "./modules/environment_queries"
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
    honeycombio_column.required_columns,
    honeycombio_column.required_rpc_columns,
    module.environment_wide_derived_columns
  ]
}

####################################################
# Create the All Services Board with the Queries
####################################################
module "environment_wide_boards" {
  source                                            = "./modules/environment_boards"
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
    honeycombio_column.required_columns,
    honeycombio_column.required_rpc_columns,
    module.environment_wide_derived_columns,
    module.environment_wide_queries
  ]
}
