####################################################
# Ensure Columns Exist That the Query Will Use
####################################################

# Column dependencies already provided in other queries

####################################################
# Define the Query Specification
####################################################
data "honeycombio_query_specification" "count_distinct_traces_by_protocol" {
  calculation {
    op     = "COUNT_DISTINCT"
    column = "trace.trace_id"
  }

  filter {
    column = "dc_protocols"
    op     = "exists"
  }

  breakdowns = [ "dc_protocols" ]

  order {
    op     = "COUNT_DISTINCT"
    column = "trace.trace_id"
    order  = "descending"
  }

  time_range = var.query_time_range

  depends_on = [
    honeycombio_column.trace-trace_id,
  ]
}

####################################################
# Implement the Query Using the Specification
####################################################
resource "honeycombio_query" "count_distinct_traces_by_protocol" {
  dataset    = "__all__"
  query_json = data.honeycombio_query_specification.count_distinct_traces_by_protocol.json
}

################################################################
# Attach an Annotation to the Query to Explain What it Does
################################################################
resource "honeycombio_query_annotation" "count_distinct_traces_by_protocol" {
  dataset     = "__all__"
  description = "Displays the number of traces utilizing different data protocols like HTTP/2 and GRPC"
  name        = "Protocol Utilization"
  query_id    = honeycombio_query.count_distinct_traces_by_protocol.id
}

####################################################
# Create Outputs for Use by Other Modules
####################################################
output "count_distinct_traces_by_protocol_id" {
  value = honeycombio_query.count_distinct_traces_by_protocol.id
}

output "count_distinct_traces_by_protocol_annotation_id" {
  value = honeycombio_query_annotation.count_distinct_traces_by_protocol.id
}
