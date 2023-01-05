variable "create_required_columns_dataset" {
  description = "Create a dataset in an environment where columns can be created that are required by the OpenTelemetry Starter Pack.  If set to false, the `required_columns_dataset_name` must be set to the name of an existing dataset or the build will fail"
  type        = bool
  default     = true
}

variable "required_columns_dataset_name" {
  description = "The name of the dataset used to ensure that all required columns exist in an environment for queries to be implemented"
  type        = string
  default     = "-required-columns-"
}

variable "required_columns" {
  type = map(string)
  description = "The list of columns required by other Environment-wide modules that need to exist"
}
