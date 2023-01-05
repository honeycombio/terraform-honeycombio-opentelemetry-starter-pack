resource "honeycombio_column" "required_column" {
  count = length(var.required_columns)
  name = keys(var.required_columns)[count.index]
  type = values(var.required_columns)[count.index]
  dataset = var.required_columns_dataset_name
}
