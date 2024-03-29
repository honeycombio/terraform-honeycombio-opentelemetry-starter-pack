<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_honeycombio"></a> [honeycombio](#requirement\_honeycombio) | >= 0.12.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_honeycombio"></a> [honeycombio](#provider\_honeycombio) | >= 0.12.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_environment_wide_boards"></a> [environment\_wide\_boards](#module\_environment\_wide\_boards) | ./environment_boards | n/a |
| <a name="module_environment_wide_columns"></a> [environment\_wide\_columns](#module\_environment\_wide\_columns) | ./environment_columns | n/a |
| <a name="module_environment_wide_derived_columns"></a> [environment\_wide\_derived\_columns](#module\_environment\_wide\_derived\_columns) | ./environment_derived_columns | n/a |
| <a name="module_environment_wide_queries"></a> [environment\_wide\_queries](#module\_environment\_wide\_queries) | ./environment_queries | n/a |

## Resources

| Name | Type |
|------|------|
| [honeycombio_dataset.required-columns-dataset](https://registry.terraform.io/providers/honeycombio/honeycombio/latest/docs/resources/dataset) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_count_400s_as_errors"></a> [count\_400s\_as\_errors](#input\_count\_400s\_as\_errors) | By default, the boards will count http.status\_code values of 400-499 as bad or error status codes, set to false to only count status codes greater than 500 | `bool` | `true` | no |
| <a name="input_create_required_columns"></a> [create\_required\_columns](#input\_create\_required\_columns) | Create columns that are required by the OpenTelemetry Starter Pack. If used, you must set the `required_columns_dataset_name` variable to determine where the columns will be created | `bool` | `false` | no |
| <a name="input_create_required_columns_dataset"></a> [create\_required\_columns\_dataset](#input\_create\_required\_columns\_dataset) | Create a dataset in an environment where columns can be created that are required by the OpenTelemetry Starter Pack. Used when applying the starter pack to an environment without any OpenTelemtry data already existing | `bool` | `false` | no |
| <a name="input_include_rpc_protocol_info_in_queries"></a> [include\_rpc\_protocol\_info\_in\_queries](#input\_include\_rpc\_protocol\_info\_in\_queries) | Include RPC Protocol Information In Derived Columns and Query Specifications. Defaults to true | `bool` | `true` | no |
| <a name="input_max_long_duration"></a> [max\_long\_duration](#input\_max\_long\_duration) | Max number for long duration span to allow cutting off outliers. Defaults to 30000ms | `number` | `30000` | no |
| <a name="input_min_long_duration"></a> [min\_long\_duration](#input\_min\_long\_duration) | Number of milliseconds which classifies as a long duration span. Defaults to 1000ms | `number` | `1000` | no |
| <a name="input_query_time_range"></a> [query\_time\_range](#input\_query\_time\_range) | Query Default Time Range (in seconds). Defaults to 86400 (24 hours) | `number` | `86400` | no |
| <a name="input_required_columns_dataset_name"></a> [required\_columns\_dataset\_name](#input\_required\_columns\_dataset\_name) | The name of the dataset used to ensure that all required columns exist in an environment for queries to be implemented | `string` | `"-required-columns-"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_all_services_board_url"></a> [all\_services\_board\_url](#output\_all\_services\_board\_url) | URL for accessing the "All Services Board" in the Honeycomb UI |
<!-- END_TF_DOCS -->