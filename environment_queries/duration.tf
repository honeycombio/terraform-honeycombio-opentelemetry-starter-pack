####################################################
# Define the Query Specification
####################################################
data "honeycombio_query_specification" "heatmap_duration" {
  calculation {
    op     = "HEATMAP"
    column = "duration_ms"
  }

  time_range = var.query_time_range

}

####################################################
# Implement the Query Using the Specification
####################################################
resource "honeycombio_query" "heatmap_duration" {
  dataset    = "__all__"
  query_json = data.honeycombio_query_specification.heatmap_duration.json
}

################################################################
# Attach an Annotation to the Query to Explain What it Does
################################################################
resource "honeycombio_query_annotation" "heatmap_duration" {
  dataset     = "__all__"
  description = "Heatmap of the `duration_ms` attribute for all services in the environment"
  name        = "Standard Duration Heatmap"
  query_id    = honeycombio_query.heatmap_duration.id
}

####################################################
# Create Outputs for Use by Other Modules
####################################################
output "heatmap_duration_id" {
  value = honeycombio_query.heatmap_duration.id
}

output "heatmap_duration_annotation_id" {
  value = honeycombio_query_annotation.heatmap_duration.id
}
