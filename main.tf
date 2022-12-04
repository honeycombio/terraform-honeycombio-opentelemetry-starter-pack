terraform {
  required_version = ">= 0.13"
  required_providers {
    honeycombio = {
      source  = "honeycombio/honeycombio"
      version = "0.11.2"
    }
  }
}

provider "honeycombio" {
  api_key = var.honeycomb_api_key
  # You can supply this via the environment variable HONEYCOMB_API_KEY or by setting the value in a .tfvars file
}

module "environment_wide_queries" {
  source = "./environment_queries"
  honeycomb_api_key = var.honeycomb_api_key
  query_time_range = var.query_time_range
  min_long_duration = var.min_long_duration
  max_long_duration = var.max_long_duration
}

module "environment_wide_boards" {
  source = "./environment_boards"
  honeycomb_api_key = var.honeycomb_api_key
}
