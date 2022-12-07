####################################################
# Ensure Columns Exist That the Query Will Use
####################################################

# Column dependencies defined elsewhere

####################################################
# Define the Query Specification
####################################################
data "honeycombio_query_specification" "count_long_duration_spans" {
  calculation {
    op     = "COUNT"
  }

  filter {
    column = "duration_ms"
    op = ">="
    value = var.min_long_duration
  }

  filter {
    column = "duration_ms"
    op = "<="
    value = var.max_long_duration
  }

  breakdowns = [ "service.name" ]

  time_range = var.query_time_range

  depends_on = [
    honeycombio_column.duration_ms,
  ]
}

####################################################
# Implement the Query Using the Specification
####################################################
resource "honeycombio_query" "count_long_duration_spans" {
  dataset    = "__all__"
  query_json = data.honeycombio_query_specification.count_long_duration_spans.json
}

################################################################
# Attach an Annotation to the Query to Explain What it Does
################################################################
resource "honeycombio_query_annotation" "count_long_duration_spans" {
  dataset     = "__all__"
  description = "Displays the number of spans with a `duration_ms` running longer than ${var.min_long_duration} milliseconds, but also sets an upper bound of ${var.max_long_duration} milliseconds to limit long running tasks of some services from skewing the data"
  name        = "High Duration Span Count"
  query_id    = honeycombio_query.count_long_duration_spans.id
}

####################################################
# Create Outputs for Use by Other Modules
####################################################
output "count_long_duration_spans_id" {
  value = honeycombio_query.count_long_duration_spans.id
}

output "count_long_duration_spans_annotation_id" {
  value = honeycombio_query_annotation.count_long_duration_spans.id
}
