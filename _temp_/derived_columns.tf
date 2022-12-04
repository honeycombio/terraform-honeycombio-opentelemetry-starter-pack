resource "honeycombio_derived_column" "dc_bad_status_code_as_a_numeric" {
  depends_on = [
    honeycombio_dataset.required_columns,
    honeycombio_column.http-status-code,
    honeycombio_column.status-code,
    honeycombio_column.rpc-grpc-status-code,
  ]
  alias       = "dc_bad_status_code_as_a_numeric"
  dataset     = "__all__"
  description = "If http.status_code, $rpc.grpc.status_code, or $status_code are reporting a failing status code, return 100, else return 0.  This can then be averaged for a rate percentage"
  expression  = "IF(\n  BOOL(\n    OR(\n      AND(\n        EXISTS($http.status_code),\n        GTE($http.status_code, 400)\n      ),\n      AND(\n        EXISTS($status_code),\n        GT($status_code, 1)\n      ),\n      AND(\n        EXISTS($rpc.grpc.status_code),\n        GT($rpc.grpc.status_code, 1)\n      )\n    )\n  ),\n  100,\n  0\n)"
}

resource "honeycombio_derived_column" "dc_ensure_nonroot_server_span" {
  depends_on = [
    honeycombio_dataset.required_columns,
    honeycombio_column.trace-parent-id,
    honeycombio_column.span-kind,
  ]
  alias       = "dc_ensure_nonroot_server_span"
  dataset     = "__all__"
  description = "Returns true if the span is a child span of a trace, but where the span is also a \"server\" type. Using this in a WHERE or a GROUP BY will show events where a result occurred as part of a serving function of the trace"
  expression  = "OR(\n    NOT(EXISTS($trace.parent_id)),\n    EQUALS($span.kind, \"server\")\n)"
}

resource "honeycombio_derived_column" "dc_error_as_a_numeric" {
  depends_on = [
    honeycombio_dataset.required_columns,
    honeycombio_column.error,
  ]
  alias       = "dc_error_as_a_numeric"
  dataset     = "__all__"
  description = "A Derived Column where errors are marked as 100 and successes marked as 0."
  expression  = "IF(\n  AND(\n    EXISTS($error),\n    NOT(\n      IN($error, \" \", \"\", \"false\")\n    )\n  ),\n  100,\n  0\n)"
}

resource "honeycombio_derived_column" "dc_log10_duration_all" {
  depends_on = [
    honeycombio_dataset.required_columns,
    honeycombio_column.duration-ms,
  ]
  alias       = "dc_log10_duration_all"
  dataset     = "__all__"
  description = "Logarithmic modification of the duration_ms value to be able to see greater granularity in the highest density part of the heatmap"
  expression  = "LOG10($duration_ms)"
}

resource "honeycombio_derived_column" "dc_protocols" {
  depends_on = [
    honeycombio_dataset.required_columns,
    honeycombio_column.rpc-system,
    honeycombio_column.http-flavor,
  ]
  alias       = "dc_protocols"
  dataset     = "__all__"
  description = "Returns the RPC system used, or what flavor of HTTP is used in the span"
  expression  = "IF(\n  OR(EXISTS($rpc.system),EXISTS($http.flavor)),\n  COALESCE(\n    IF(EXISTS($rpc.system), $rpc.system),\n    IF(EQUALS($http.flavor, \"1.0\"), \"HTTP/1.0\"),\n    IF(EQUALS($http.flavor, \"1.1\"), \"HTTP/1.1\"),\n    IF(EQUALS($http.flavor, \"2.0\"), \"HTTP/2\"),\n    IF(EQUALS($http.flavor, \"3.0\"), \"HTTP/3\"),\n    $http.flavor\n  )\n)"
}
