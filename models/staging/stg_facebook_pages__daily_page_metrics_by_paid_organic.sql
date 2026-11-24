{{ config(enabled=var('facebook_pages__using_daily_page_metrics_by_paid_organic', True)) }}

with base as (

    select * 
    from {{ ref('stg_facebook_pages__daily_page_metrics_by_paid_organic_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_facebook_pages__daily_page_metrics_by_paid_organic_tmp')),
                staging_columns=get_daily_page_metrics_by_paid_organic_columns()
            )
        }}

        {{ fivetran_utils.apply_source_relation(package_name='facebook_pages') }}

    from base
),

final as (

    select
        source_relation,
        _fivetran_synced,
        date as date_day,
        page_id,
        is_from_ads,
        page_media_view as media_views
    from fields
)

select *
from final
