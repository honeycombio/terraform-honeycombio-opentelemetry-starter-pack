####################################################
# Ensure Columns Exist That the DC Will Use
####################################################
resource "honeycombio_column" "db-system" {
  count = var.create_required_columns_dataset ? 1 : 0
  key_name = "db.system"
  type = "string"
  dataset = var.required_columns_dataset_name
}

resource "honeycombio_column" "db-type" {
  count = var.create_required_columns_dataset ? 1 : 0
  key_name = "db.type"
  type = "string"
  dataset = var.required_columns_dataset_name
}

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
