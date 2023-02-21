####################################################
# Create the Derived Column
####################################################
resource "honeycombio_derived_column" "dc_ensure_nonroot_server_span" {
  alias       = "dc_ensure_nonroot_server_span"
  dataset     = "__all__"
  description = "Returns true if the span is a child span of a trace, but where the span is also a `server` type. Using this in a WHERE or a GROUP BY will show events where a result occurred as part of a serving function of the trace"
  expression  = templatefile("${path.module}/templates/ensure_nonroot_server_span.tftpl", {} )

}

####################################################
# Output the Derived Column ID for Other Modules
####################################################

output "dc_ensure_nonroot_server_span_alias" {
  value = honeycombio_derived_column.dc_ensure_nonroot_server_span.alias
}
