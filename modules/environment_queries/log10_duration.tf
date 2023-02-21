####################################################
# Define the Query Specification
####################################################
data "honeycombio_query_specification" "heatmap_log10_duration" {
  calculation {
    op     = "HEATMAP"
    column = "dc_log10_duration"
  }

  time_range = var.query_time_range
}

####################################################
# Implement the Query Using the Specification
####################################################
resource "honeycombio_query" "heatmap_log10_duration" {
  dataset    = "__all__"
  query_json = data.honeycombio_query_specification.heatmap_log10_duration.json
}

################################################################
# Attach an Annotation to the Query to Explain What it Does
################################################################
resource "honeycombio_query_annotation" "heatmap_log10_duration" {
  dataset     = "__all__"
  description = "This shows a LOG10 representation of the `duration_ms` attribute value of the service:\n\n- 0.x values correlate to a duration of <1ms to 10ms\n- 1.x values correlate to a duration between 10ms and 100ms\n- 2.x values correlate to a duration between 100ms and 1000ms"
  name        = "Logarithmic Duration Heatmap"
  query_id    = honeycombio_query.heatmap_log10_duration.id
}

####################################################
# Create Outputs for Use by Other Modules
####################################################
output "heatmap_log10_duration_id" {
  value = honeycombio_query.heatmap_log10_duration.id
}

output "heatmap_log10_duration_annotation_id" {
  value = honeycombio_query_annotation.heatmap_log10_duration.id
}
