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
