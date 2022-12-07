variable "honeycomb_api_key" {
  description = "Honeycomb API key"
  type        = string
  default     = null
  # You can supply this via the environment variable HONEYCOMB_API_KEY or by setting the value in a .tfvars file
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

variable "include_rpc_protocol_info_in_queries" {
  description = "Include RPC Protocol Information In Derived Columns and Query Specifications"
  type = bool
  default = true
}

variable "count_400s_as_errors" {
  description = "By default, the boards will count http.status_code values of 400-499 as bad or error status codes, set to false to only count status codes greater than 500"
  type = bool
  default = true
}
