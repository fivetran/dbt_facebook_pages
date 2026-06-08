{% if var('facebook_pages_union_schemas', []) | length > 0 or var('facebook_pages_union_databases', []) | length > 0 %}

{{
    fivetran_utils.union_data(
        table_identifier='daily_page_metrics_total', 
        database_variable='facebook_pages_database', 
        schema_variable='facebook_pages_schema', 
        default_database=target.database,
        default_schema='facebook_pages',
        default_variable='daily_page_metrics_total',
        union_schema_variable='facebook_pages_union_schemas',
        union_database_variable='facebook_pages_union_databases'
    )
}}

{% else %}

{{
    fivetran_utils.union_connections(
        connection_dictionary='facebook_pages_sources',
        single_source_name='facebook_pages',
        single_table_name='daily_page_metrics_total'
    )
}}

{% endif %}