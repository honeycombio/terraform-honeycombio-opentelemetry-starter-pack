####################################################
# Ensure Columns Exist That the Query Will Use
####################################################
resource "honeycombio_column" "http-status_code" {
  count = var.create_required_columns_dataset ? 1 : 0
  key_name = "http.status_code"
  type = "integer"
  dataset = var.required_columns_dataset_name
}

####################################################
# Define the Query Specification
####################################################
data "honeycombio_query_specification" "count_of_traces_by_http_status_code" {
  calculation {
    op     = "COUNT"
  }

  filter {
    column = "trace.parent_id"
    op     = "does-not-exist"
  }

  filter {
    column = "http.status_code"
    op = "exists"
  }

  breakdowns = [
    "http.status_code"
  ]

  order {
    op = "COUNT"
    order = "descending"
  }

  time_range = var.query_time_range

  depends_on = [
    honeycombio_column.trace-parent_id,
    honeycombio_column.http-status_code,
  ]
}

####################################################
# Implement the Query Using the Specification
####################################################
resource "honeycombio_query" "count_of_traces_by_http_status_code" {
  dataset    = "__all__"
  query_json = data.honeycombio_query_specification.count_of_traces_by_http_status_code.json
}

################################################################
# Attach an Annotation to the Query to Explain What it Does
################################################################
resource "honeycombio_query_annotation" "count_of_traces_by_http_status_code" {
  dataset     = "__all__"
  description = "Provides the number of traces over time, grouped by the HTTP status code"
  name        = "Trace Counts by HTTP Status Code"
  query_id    = honeycombio_query.count_of_traces_by_http_status_code.id
}

####################################################
# Create Outputs for Use by Other Modules
####################################################
output "count_of_traces_by_http_status_code_id" {
  value = honeycombio_query.count_of_traces_by_http_status_code.id
}

output "count_of_traces_by_http_status_code_annotation_id" {
  value = honeycombio_query_annotation.count_of_traces_by_http_status_code.id
}
