####################################################
# Ensure Columns Exist That the DC Will Use
####################################################
resource "honeycombio_column" "rpc-grpc-status_code" {
  count = var.create_required_columns_dataset && var.include_rpc_protocol_info_in_queries ? 1 : 0
  key_name = "rpc.grpc.status_code"
  type = "integer"
  dataset = var.required_columns_dataset_name
}

resource "honeycombio_column" "http-status_code" {
  count = var.create_required_columns_dataset ? 1 : 0
  key_name = "http.status_code"
  type = "integer"
  dataset = var.required_columns_dataset_name
}

resource "honeycombio_column" "status_code" {
  count = var.create_required_columns_dataset ? 1 : 0
  key_name = "status_code"
  type = "integer"
  dataset = var.required_columns_dataset_name
}

####################################################
# Create the Derived Column
####################################################
resource "honeycombio_derived_column" "dc_bad_status_code_as_a_numeric" {
  alias       = "dc_bad_status_code_as_a_numeric"
  dataset     = "__all__"
  description = var.include_rpc_protocol_info_in_queries ? "If $http.status_code, $rpc.grpc.status_code, or $status_code are reporting a failing status code, return 100, else return 0.  This can then be averaged for a rate percentage" : "If $http.status_code or $status_code are reporting a failing status code, return 100, else return 0.  This can then be averaged for a rate percentage"
  expression  = templatefile("${path.module}/templates/bad_status_code_as_a_numeric.tftpl", { query_rpc = var.include_rpc_protocol_info_in_queries, count_400s_as_errors = var.count_400s_as_errors })
  depends_on  = [
    honeycombio_column.rpc-grpc-status_code,
    honeycombio_column.http-status_code,
    honeycombio_column.status_code,
  ]
}

####################################################
# Output the Derived Column ID for Other Modules
####################################################

output "dc_bad_status_code_as_a_numeric_alias" {
  value = honeycombio_derived_column.dc_bad_status_code_as_a_numeric.alias
}
