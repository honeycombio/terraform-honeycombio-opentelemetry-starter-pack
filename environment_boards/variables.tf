variable "honeycomb_api_key" {
  description = "Honeycomb API key"
  type        = string
  default     = null
  # You can supply this via the environment variable HONEYCOMB_API_KEY or by setting the value in a .tfvars file
}

variable "count_of_traces_by_service_id" {
  description = "Query ID for count_of_traces_by_service query"
  type        = string
}

variable "count_of_traces_by_service_annotation_id" {
  description = "Query Annotation ID for count_of_traces_by_service query"
  type        = string
}

variable "count_of_traces_by_http_status_code_id" {
  description = "Query ID for count_of_traces_by_http_status_code query"
  type        = string
}

variable "count_of_traces_by_http_status_code_annotation_id" {
  description = "Query Annotation ID for count_of_traces_by_http_status_code query"
  type        = string
}

variable "count_of_total_spans_by_service_id" {
  description = "Query ID for count_of_total_spans_by_service query"
  type        = string
}

variable "count_of_total_spans_by_service_annotation_id" {
  description = "Query Annotation ID for count_of_total_spans_by_service query"
  type        = string
}

variable "count_of_span_events_by_service_id" {
  description = "Query ID for count_of_span_events_by_service query"
  type        = string
}

variable "count_of_span_events_by_service_annotation_id" {
  description = "Query Annotation ID for count_of_span_events_by_service query"
  type        = string
}

variable "count_of_traces_by_telemetry_sdks_id" {
  description = "Query ID for count_of_traces_by_telemetry_sdks query"
  type        = string
}

variable "count_of_traces_by_telemetry_sdks_annotation_id" {
  description = "Query Annotation ID for count_of_traces_by_telemetry_sdks query"
  type        = string
}

variable "rate_of_error_spans_id" {
  description = "Query ID for rate_of_error_spans query"
  type        = string
}

variable "rate_of_error_spans_annotation_id" {
  description = "Query Annotation ID for rate_of_error_spans query"
  type        = string
}

variable "rate_of_bad_status_code_spans_id" {
  description = "Query ID for rate_of_bad_status_code_spans query"
  type        = string
}

variable "rate_of_bad_status_code_spans_annotation_id" {
  description = "Query Annotation ID for rate_of_bad_status_code_spans query"
  type        = string
}
