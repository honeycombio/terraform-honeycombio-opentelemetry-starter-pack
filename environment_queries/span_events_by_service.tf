####################################################
# Ensure Columns Exist That the Query Will Use
####################################################
resource "honeycombio_column" "meta-annotation_type" {
  count = var.create_required_columns_dataset ? 1 : 0
  key_name = "meta.annotation_type"
  type = "string"
  dataset = var.required_columns_dataset_name
}

####################################################
# Define the Query Specification
####################################################
data "honeycombio_query_specification" "count_of_span_events_by_service" {
  calculation {
    op     = "COUNT"
  }

  filter {
    column = "meta.annotation_type"
    op     = "="
    value = "span_event"
  }

  breakdowns = [
    "service.name"
  ]

  order {
    op = "COUNT"
    order = "descending"
  }

  time_range = var.query_time_range

  depends_on = [
    honeycombio_column.meta-annotation_type,
  ]
}

####################################################
# Implement the Query Using the Specification
####################################################
resource "honeycombio_query" "count_of_span_events_by_service" {
  dataset    = "__all__"
  query_json = data.honeycombio_query_specification.count_of_span_events_by_service.json
}

################################################################
# Attach an Annotation to the Query to Explain What it Does
################################################################
resource "honeycombio_query_annotation" "count_of_span_events_by_service" {
  dataset     = "__all__"
  description = "Number of span events over time, grouped by the service sending the event."
  name        = "Span Events by Service"
  query_id    = honeycombio_query.count_of_span_events_by_service.id
}

####################################################
# Create Outputs for Use by Other Modules
####################################################
output "count_of_span_events_by_service_id" {
  value = honeycombio_query.count_of_span_events_by_service.id
}

output "count_of_span_events_by_service_annotation_id" {
  value = honeycombio_query_annotation.count_of_span_events_by_service.id
}
