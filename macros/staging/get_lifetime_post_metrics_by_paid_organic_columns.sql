{% macro get_lifetime_post_metrics_by_paid_organic_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "date", "datatype": dbt.type_timestamp()},
    {"name": "is_from_ads", "datatype": dbt.type_boolean()},
    {"name": "post_id", "datatype": dbt.type_string()},
    {"name": "post_media_view", "datatype": dbt.type_int()}
] %}

{{ return(columns) }}

{% endmacro %}
