resource "honeycombio_dataset" "required_columns" {
  name = "-required_column_creation-"
  description = "Created by the Golden OTEL Starter Pack to ensure that a dataset exists with all necessary columns in case no data or not enough data has been added to the environment"
}
