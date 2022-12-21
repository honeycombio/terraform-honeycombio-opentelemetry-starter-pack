####################################################
# Create the Derived Column
####################################################
resource "honeycombio_derived_column" "dc_protocols" {
  alias       = "dc_protocols"
  dataset     = "__all__"
  description = var.include_rpc_protocol_info_in_queries ? "Returns the RPC system used or what flavor of HTTP protocol used in a span" : "Returns the flavor of HTTP protocol used in a span"
  expression  = templatefile("${path.module}/templates/protocols.tftpl", { query_rpc = var.include_rpc_protocol_info_in_queries })
}

####################################################
# Output the Derived Column ID for Other Modules
####################################################

output "dc_protocols_alias" {
  value = honeycombio_derived_column.dc_protocols.alias
}
