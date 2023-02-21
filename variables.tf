variable "create_required_columns_dataset" {
  description = "Create a dataset in an environment where columns can be created that are required by the OpenTelemetry Starter Pack. Used when applying the starter pack to an environment without any OpenTelemtry data already existing"
  type        = bool
  default     = false
}

variable "create_required_columns" {
  description = "Create columns that are required by the OpenTelemetry Starter Pack. If used, you must set the `required_columns_dataset_name` variable to determine where the columns will be created"
  type        = bool
  default     = false
}

variable "required_columns_dataset_name" {
  description = "The name of the dataset used to ensure that all required columns exist in an environment for queries to be implemented"
  type        = string
  default     = "-required-columns-"
}

variable "include_rpc_protocol_info_in_queries" {
  description = "Include RPC Protocol Information In Derived Columns and Query Specifications. Defaults to true"
  type        = bool
  default     = true
}

variable "count_400s_as_errors" {
  description = "By default, the boards will count http.status_code values of 400-499 as bad or error status codes, set to false to only count status codes greater than 500"
  type        = bool
  default     = true
}

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
