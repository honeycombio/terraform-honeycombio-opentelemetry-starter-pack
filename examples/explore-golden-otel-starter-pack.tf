module "honeycombio-golden-otel-starter-pack" {
  source = "honeycombio/golden-otel-starter-pack/honeycombio"

  count_400s_as_errors = false
  max_long_duration = 15000
  min_long_duration = 2000
  required_columns_dataset_name = "-delete-me-later-"
}