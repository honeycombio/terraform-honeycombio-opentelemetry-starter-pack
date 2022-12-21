####################################################
# Create the Derived Column
####################################################
resource "honeycombio_derived_column" "dc_error_as_a_numeric" {
  alias       = "dc_error_as_a_numeric"
  dataset     = "__all__"
  description = "A Derived Column where errors are marked as 100 and successes marked as 0. This can be used with the AVG vizualizer"
  expression  = templatefile("${path.module}/templates/error_as_a_numeric.tftpl", {})
}

####################################################
# Output the Derived Column ID for Other Modules
####################################################

output "dc_error_as_a_numeric_alias" {
  value = honeycombio_derived_column.dc_error_as_a_numeric.alias
}
