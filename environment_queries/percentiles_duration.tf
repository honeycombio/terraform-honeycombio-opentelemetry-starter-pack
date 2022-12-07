####################################################
# Ensure Columns Exist That the Query Will Use
####################################################

# Column dependencies defined elsewhere

####################################################
# Define the Query Specification
####################################################
data "honeycombio_query_specification" "percentiles_of_duration" {
  calculation {
    op     = "P999"
    column = "duration_ms"
  }

  calculation {
    op     = "P99"
    column = "duration_ms"
  }

  calculation {
    op     = "P95"
    column = "duration_ms"
  }

  calculation {
    op     = "P90"
    column = "duration_ms"
  }

  calculation {
    op     = "P75"
    column = "duration_ms"
  }

  calculation {
    op     = "P50"
    column = "duration_ms"
  }

  breakdowns = [ "service.name" ]

  order {
    op     = "P999"
    column = "duration_ms"
    order  = "descending"
  }

  time_range = var.query_time_range

  depends_on = [
    honeycombio_column.duration_ms,
  ]
}

####################################################
# Implement the Query Using the Specification
####################################################
resource "honeycombio_query" "percentiles_of_duration" {
  dataset    = "__all__"
  query_json = data.honeycombio_query_specification.percentiles_of_duration.json
}

################################################################
# Attach an Annotation to the Query to Explain What it Does
################################################################
resource "honeycombio_query_annotation" "percentiles_of_duration" {
  dataset     = "__all__"
  description = "A series of percentile line graphs focusing on span duration, grouped by the `service.name` attribute"
  name        = "Duration Percentiles By Service"
  query_id    = honeycombio_query.percentiles_of_duration.id
}

####################################################
# Create Outputs for Use by Other Modules
####################################################
output "percentiles_of_duration_id" {
  value = honeycombio_query.percentiles_of_duration.id
}

output "percentiles_of_duration_annotation_id" {
  value = honeycombio_query_annotation.percentiles_of_duration.id
}
