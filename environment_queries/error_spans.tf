####################################################
# Ensure Columns Exist That the Query Will Use
####################################################

# Previously Ensured Column Dependencies

####################################################
# Define the Query Specification
####################################################
data "honeycombio_query_specification" "rate_of_error_spans" {
  calculation {
    op     = "AVG"
    column = var.dc_error_as_a_numeric
  }

  filter {
    column = var.dc_ensure_nonroot_server_span
    op = "="
    value = true
  }
  filter {
    column = "meta.annotation_type"
    op     = "does-not-exist"
  }

  breakdowns = [
    "service.name"
  ]

  order {
    op = "AVG"
    column = var.dc_error_as_a_numeric
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
resource "honeycombio_query" "rate_of_error_spans" {
  dataset    = "__all__"
  query_json = data.honeycombio_query_specification.rate_of_error_spans.json
}

################################################################
# Attach an Annotation to the Query to Explain What it Does
################################################################
resource "honeycombio_query_annotation" "rate_of_error_spans" {
  dataset     = "__all__"
  description = "Uses a derived column to show any span that has an $error field populated as 100, and any span without that as a 0.  This way we can VIZUALIZE the AVG of the derived column, and we'll be able to see a percentage value 0 being 0% and 100 being 100%"
  name        = "Average Error Rate Across Services"
  query_id    = honeycombio_query.rate_of_error_spans.id
}

####################################################
# Create Outputs for Use by Other Modules
####################################################
output "rate_of_error_spans_id" {
  value = honeycombio_query.rate_of_error_spans.id
}

output "rate_of_error_spans_annotation_id" {
  value = honeycombio_query_annotation.rate_of_error_spans.id
}
