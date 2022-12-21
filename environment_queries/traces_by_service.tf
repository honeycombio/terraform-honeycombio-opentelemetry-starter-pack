####################################################
# Define the Query Specification
####################################################
data "honeycombio_query_specification" "count_of_traces_by_service" {
  calculation {
    op     = "COUNT"
  }

  filter {
    column = "trace.parent_id"
    op     = "exists"
  }

  breakdowns = [
    "service.name"
  ]

  order {
    op = "COUNT"
    order = "descending"
  }

  time_range = var.query_time_range
}

####################################################
# Implement the Query Using the Specification
####################################################
resource "honeycombio_query" "count_of_traces_by_service" {
  dataset    = "__all__"
  query_json = data.honeycombio_query_specification.count_of_traces_by_service.json
}

################################################################
# Attach an Annotation to the Query to Explain What it Does
################################################################
resource "honeycombio_query_annotation" "count_of_traces_by_service" {
  dataset     = "__all__"
  description = "Gets a count of the number of traces (not the number of spans) over time.  This provides an idea of which services are generating root spans, and at which volume they're being generated."
  name        = "Trace Counts By Service"
  query_id    = honeycombio_query.count_of_traces_by_service.id
}

####################################################
# Create Outputs for Use by Other Modules
####################################################
output "count_of_traces_by_service_id" {
  value = honeycombio_query.count_of_traces_by_service.id
}

output "count_of_traces_by_service_annotation_id" {
  value = honeycombio_query_annotation.count_of_traces_by_service.id
}
