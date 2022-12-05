####################################################
# Ensure Columns Exist That the Query Will Use
####################################################
resource "honeycombio_column" "trace-trace_id" {
  count = var.create_required_columns_dataset ? 1 : 0
  key_name = "trace.trace_id"
  type = "string"
  dataset = var.required_columns_dataset_name
}

resource "honeycombio_column" "telemetry-sdk-language" {
  count = var.create_required_columns_dataset ? 1 : 0
  key_name = "telemetry.sdk.language"
  type = "string"
  dataset = var.required_columns_dataset_name
}

resource "honeycombio_column" "telemetry-sdk-version" {
  count = var.create_required_columns_dataset ? 1 : 0
  key_name = "telemetry.sdk.version"
  type = "string"
  dataset = var.required_columns_dataset_name
}

resource "honeycombio_column" "telemetry-sdk-name" {
  count = var.create_required_columns_dataset ? 1 : 0
  key_name = "telemetry.sdk.name"
  type = "string"
  dataset = var.required_columns_dataset_name
}

####################################################
# Define the Query Specification
####################################################
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

  depends_on = [
    honeycombio_column.trace-trace_id,
    honeycombio_column.telemetry-sdk-language,
    honeycombio_column.telemetry-sdk-version,
    honeycombio_column.telemetry-sdk-name,
  ]
}

####################################################
# Implement the Query Using the Specification
####################################################
resource "honeycombio_query" "count_of_traces_by_telemetry_sdks" {
  dataset    = "__all__"
  query_json = data.honeycombio_query_specification.count_of_traces_by_telemetry_sdks.json
}

################################################################
# Attach an Annotation to the Query to Explain What it Does
################################################################
resource "honeycombio_query_annotation" "count_of_traces_by_telemetry_sdks" {
  dataset     = "__all__"
  description = "Provides the number of traces over time, organized by the different telemetry sdk languages and versions."
  name        = "Trace Counts by Telemetry SDK"
  query_id    = honeycombio_query.count_of_traces_by_telemetry_sdks.id
}

####################################################
# Create Outputs for Use by Other Modules
####################################################
output "count_of_traces_by_telemetry_sdks_id" {
  value = honeycombio_query.count_of_traces_by_telemetry_sdks.id
}

output "count_of_traces_by_telemetry_sdks_annotation_id" {
  value = honeycombio_query_annotation.count_of_traces_by_telemetry_sdks.id
}
