####################################################
# Ensure Columns Exist That the DC Will Use
####################################################
resource "honeycombio_column" "rpc-system" {
  count = var.create_required_columns_dataset && var.include_rpc_protocol_info_in_queries ? 1 : 0
  key_name = "rpc.system"
  type = "string"
  dataset = var.required_columns_dataset_name
}

resource "honeycombio_column" "http-flavor" {
  count = var.create_required_columns_dataset ? 1 : 0
  key_name = "http.flavor"
  type = "string"
  dataset = var.required_columns_dataset_name
}

####################################################
# Create the Derived Column
####################################################
resource "honeycombio_derived_column" "dc_protocols" {
  alias       = "dc_protocols"
  dataset     = "__all__"
  description = var.include_rpc_protocol_info_in_queries ? "Returns the RPC system used or what flavor of HTTP protocol used in a span" : "Returns the flavor of HTTP protocol used in a span"
  expression  = templatefile("${path.module}/templates/protocols.tftpl", { query_rpc = var.include_rpc_protocol_info_in_queries })
  depends_on  = [
    honeycombio_column.rpc-system,
    honeycombio_column.http-flavor,
  ]
}

####################################################
# Output the Derived Column ID for Other Modules
####################################################

output "dc_protocols_alias" {
  value = honeycombio_derived_column.dc_protocols.alias
}
