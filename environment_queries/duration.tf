####################################################
# Ensure Columns Exist That the Query Will Use
####################################################
resource "honeycombio_column" "duration_ms" {
  count = var.create_required_columns_dataset ? 1 : 0
  key_name = "duration_ms"
  type = "float"
  dataset = var.required_columns_dataset_name
}

####################################################
# Define the Query Specification
####################################################
data "honeycombio_query_specification" "heatmap_duration" {
  calculation {
    op     = "HEATMAP"
    column = "duration_ms"
  }

  time_range = var.query_time_range

  depends_on = [
    honeycombio_column.duration_ms,
  ]
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
