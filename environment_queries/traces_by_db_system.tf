####################################################
# Ensure Columns Exist That the Query Will Use
####################################################
resource "honeycombio_column" "db-system" {
  count = var.create_required_columns_dataset ? 1 : 0
  key_name = "db.system"
  type = "string"
  dataset = var.required_columns_dataset_name
}

####################################################
# Define the Query Specification
####################################################
data "honeycombio_query_specification" "count_of_traces_by_db_system" {
  calculation {
    op     = "COUNT_DISTINCT"
    column = "trace.trace_id"
  }

  filter {
    column = "db.system"
    op     = "exists"
  }

  breakdowns = [ "db.system" ]

  order {
    op     = "COUNT_DISTINCT"
    column = "trace.trace_id"
    order  = "descending"
  }

  time_range = var.query_time_range

  depends_on = [
    honeycombio_column.trace-trace_id,
    honeycombio_column.db-system,
  ]
}

####################################################
# Implement the Query Using the Specification
####################################################
resource "honeycombio_query" "count_of_traces_by_db_system" {
  dataset    = "__all__"
  query_json = data.honeycombio_query_specification.count_of_traces_by_db_system.json
}

################################################################
# Attach an Annotation to the Query to Explain What it Does
################################################################
resource "honeycombio_query_annotation" "count_of_traces_by_db_system" {
  dataset     = "__all__"
  description = "Displays the number of trace interacting with a Database where the [type of database](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/trace/semantic_conventions/database.md#connection-level-attributes) is included in the span attributes."
  name        = "Database Systems Spans"
  query_id    = honeycombio_query.count_of_traces_by_db_system.id
}

####################################################
# Create Outputs for Use by Other Modules
####################################################
output "count_of_traces_by_db_system_id" {
  value = honeycombio_query.count_of_traces_by_db_system.id
}

output "count_of_traces_by_db_system_annotation_id" {
  value = honeycombio_query_annotation.count_of_traces_by_db_system.id
}
