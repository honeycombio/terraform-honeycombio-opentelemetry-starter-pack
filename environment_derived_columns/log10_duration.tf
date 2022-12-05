####################################################
# Ensure Columns Exist That the DC Will Use
####################################################
resource "honeycombio_column" "duration_ms" {
  count = var.create_required_columns_dataset ? 1 : 0
  key_name = "duration_ms"
  type = "float"
  dataset = var.required_columns_dataset_name
}

####################################################
# Create the Derived Column
####################################################
resource "honeycombio_derived_column" "dc_log10_duration" {
  alias       = "dc_log10_duration"
  dataset     = "__all__"
  description = "Logarithmic modification of the duration_ms value to be able to see greater granularity in the highest density part of the heatmap"
  expression  = templatefile("${path.module}/templates/log10_duration.tftpl", {})
  depends_on  = [
    honeycombio_column.duration_ms,
  ]
}

####################################################
# Output the Derived Column ID for Other Modules
####################################################

output "dc_log10_duration_alias" {
  value = honeycombio_derived_column.dc_log10_duration.alias
}
