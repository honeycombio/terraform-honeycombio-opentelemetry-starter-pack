terraform {
  required_version = ">= 1.0"
  required_providers {
    honeycombio = {
      source  = "honeycombio/honeycombio"
      version = ">= 0.15.0"
    }
  }
}
