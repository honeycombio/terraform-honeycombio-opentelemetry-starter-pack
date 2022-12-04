variable "honeycomb_api_key" {
  description = "Honeycomb API key"
  type        = string
  default     = null
  # You can supply this via the environment variable HONEYCOMB_API_KEY or by setting the value in a .tfvars file
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
