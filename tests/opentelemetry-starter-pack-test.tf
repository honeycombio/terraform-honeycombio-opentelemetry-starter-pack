module "honeycombio-opentelemetry-starter-pack" {
  source = "../"

  count_400s_as_errors                 = false
  include_rpc_protocol_info_in_queries = false
  max_long_duration                    = 15000
  min_long_duration                    = 2000
  query_time_range                     = 604800
  required_columns_dataset_name        = "-delete-me-later-"
}

output "all_services_board_url" {
  value       = module.honeycombio-opentelemetry-starter-pack.all_services_board_url
  description = "URL for accessing the \"All Services Board\" in the Honeycomb UI"
}