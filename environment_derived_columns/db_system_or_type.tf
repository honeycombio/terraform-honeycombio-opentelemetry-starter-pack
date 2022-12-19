####################################################
# Create the Derived Column
####################################################
resource "honeycombio_derived_column" "dc_db_system_or_type" {
  alias       = "dc_db_system_or_type"
  dataset     = "__all__"
  description = "Returns the database system if available or the database type if available"
  expression  = templatefile("${path.module}/templates/db_system_or_type.tftpl", {})
  depends_on  = [
    honeycombio_column.db-system,
    honeycombio_column.db-type,
  ]
}

####################################################
# Output the Derived Column ID for Other Modules
####################################################

output "dc_db_system_or_type" {
  value = honeycombio_derived_column.dc_db_system_or_type.alias
}
