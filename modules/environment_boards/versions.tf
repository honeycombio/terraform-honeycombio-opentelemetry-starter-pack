terraform {
  required_version = ">= 0.13"
  required_providers {
    honeycombio = {
      source  = "honeycombio/honeycombio"
      version = ">= 0.12.0"
    }
  }
}
