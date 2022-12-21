####################################################
# Define the Query Specification
####################################################
data "honeycombio_query_specification" "rate_of_bad_status_code_spans" {
  calculation {
    op     = "AVG"
    column = var.dc_bad_status_code_as_a_numeric
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
    column = var.dc_bad_status_code_as_a_numeric
    order = "descending"
  }

  time_range = var.query_time_range
}

####################################################
# Implement the Query Using the Specification
####################################################
resource "honeycombio_query" "rate_of_bad_status_code_spans" {
  dataset    = "__all__"
  query_json = data.honeycombio_query_specification.rate_of_bad_status_code_spans.json
}

################################################################
# Attach an Annotation to the Query to Explain What it Does
################################################################
resource "honeycombio_query_annotation" "rate_of_bad_status_code_spans" {
  dataset     = "__all__"
  description = "This uses the AVG against a Derived Column to determine the rate at which a service returns a bad status code, this could be from multiple status code fields OpenTelemetry may provide:\n- `http.status_code`\n- `rpc.grpc.status_code`\n- `status_code`"
  name        = "Average Bad Status Code Rate Across Services"
  query_id    = honeycombio_query.rate_of_bad_status_code_spans.id
}

####################################################
# Create Outputs for Use by Other Modules
####################################################
output "rate_of_bad_status_code_spans_id" {
  value = honeycombio_query.rate_of_bad_status_code_spans.id
}

output "rate_of_bad_status_code_spans_annotation_id" {
  value = honeycombio_query_annotation.rate_of_bad_status_code_spans.id
}
