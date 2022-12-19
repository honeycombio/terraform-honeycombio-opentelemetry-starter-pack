####################################################
# Ensure Columns Exist That the Query Will Use
####################################################

# Using derived columns, or already defined columns

####################################################
# Define the Query Specification
####################################################
data "honeycombio_query_specification" "count_of_traces_by_db_system" {
  calculation {
    op     = "COUNT"
  }

  filter {
    column = "dc_db_system_or_type"
    op     = "exists"
  }

  breakdowns = [ "dc_db_system_or_type" ]

  order {
    op     = "COUNT"
    order  = "descending"
  }

  time_range = var.query_time_range
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
  description = "Displays the number of spans interacting with a Database where the [type of database](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/trace/semantic_conventions/database.md#connection-level-attributes) is included in the span attributes."
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
