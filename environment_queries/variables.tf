variable "query_time_range" {
  description = "Query Default Time Range (in seconds). Defaults to 86400 (24 hours)"
  type        = number
  default     = 86400
}

variable "min_long_duration" {
  description = "Number of milliseconds which classifies as a long duration span. Defaults to 1000ms"
  type        = number
  default     = 1000
}

variable "max_long_duration" {
  description = "Max number for long duration span to allow cutting off outliers. Defaults to 30000ms"
  type        = number
  default     = 30000
}

variable "create_required_columns_dataset" {
  description = "Create a dataset in an environment where columns can be created that are required by the OpenTelemetry Starter Pack.  If all required columns already exist in other datasets, you can choose to set this to false"
  type        = bool
  default     = true
}

variable "required_columns_dataset_name" {
  description = "The name of the dataset used to ensure that all required columns exist in an environment for queries to be implemented"
  type = string
  default = "-required-columns-"
}

variable "dc_log10_duration" {
  description = "The alias for the dc_log10_duration Derived Column"
  type = string
}

variable "dc_protocols" {
  description = "The alias for the dc_protocols Derived Column"
  type = string
}

variable "dc_bad_status_code_as_a_numeric" {
  description = "The alias for the dc_bad_status_code_as_a_numeric Derived Column"
  type = string
}

variable "dc_error_as_a_numeric" {
  description = "The alias for the dc_error_as_a_numeric Derived Column"
  type = string
}

variable "dc_ensure_nonroot_server_span" {
  description = "The alias for the dc_log10_duration Derived Column"
  type = string
}
