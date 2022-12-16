#####################
# Output Board URLs
#####################
output "all_services_board_url" {
  value       = module.environment_wide_boards.all_services_board_url
  description = "URL for accessing the \"All Services Board\" in the Honeycomb UI"
}
