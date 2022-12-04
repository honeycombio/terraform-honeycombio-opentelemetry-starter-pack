resource "honeycombio_column" "http-status-code" {
  dataset = honeycombio_dataset.required_columns.id
  key_name = "http.status_code"
  type = "integer"
}
resource "honeycombio_column" "status-code" {
  dataset = honeycombio_dataset.required_columns.id
  key_name = "status_code"
  type = "integer"
}
resource "honeycombio_column" "rpc-grpc-status-code" {
  dataset = honeycombio_dataset.required_columns.id
  key_name = "rpc.grpc.status_code"
  type = "integer"
}
resource "honeycombio_column" "trace-parent-id" {
  dataset = honeycombio_dataset.required_columns.id
  key_name = "trace.parent_id"
  type = "string"
}
resource "honeycombio_column" "span-kind" {
  dataset = honeycombio_dataset.required_columns.id
  key_name = "span.kind"
  type = "string"
}
resource "honeycombio_column" "error" {
  dataset = honeycombio_dataset.required_columns.id
  key_name = "error"
  type = "boolean"
}
resource "honeycombio_column" "duration-ms" {
  dataset = honeycombio_dataset.required_columns.id
  key_name = "duration_ms"
  type = "float"
}
resource "honeycombio_column" "rpc-system" {
  dataset = honeycombio_dataset.required_columns.id
  key_name = "rpc.system"
  type = "string"
}
resource "honeycombio_column" "http-flavor" {
  dataset = honeycombio_dataset.required_columns.id
  key_name = "http.flavor"
  type = "string"
}
resource "honeycombio_column" "service-name" {
  dataset = honeycombio_dataset.required_columns.id
  key_name = "http.status_code"
  type = "string"
}
resource "honeycombio_column" "meta-annotation-type" {
  dataset = honeycombio_dataset.required_columns.id
  key_name = "meta.annotation_type"
  type = "string"
}
resource "honeycombio_column" "trace-trace_id" {
  dataset = honeycombio_dataset.required_columns.id
  key_name = "trace.trace_id"
  type = "string"
}
resource "honeycombio_column" "telemetry-sdk-language" {
  dataset = honeycombio_dataset.required_columns.id
  key_name = "telemetry.sdk.language"
  type = "string"
}
resource "honeycombio_column" "telemetry-sdk-version" {
  dataset = honeycombio_dataset.required_columns.id
  key_name = "telemetry.sdk.version"
  type = "string"
}
resource "honeycombio_column" "telemetry-sdk-name" {
  dataset = honeycombio_dataset.required_columns.id
  key_name = "telemetry.sdk.name"
  type = "string"
}
