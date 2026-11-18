{{ config(enabled=var('facebook_pages__using_lifetime_post_metrics_by_followers', True)) }}

with base as (

    select * 
    from {{ ref('stg_facebook_pages__lifetime_post_metrics_by_followers_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_facebook_pages__lifetime_post_metrics_by_followers_tmp')),
                staging_columns=get_lifetime_post_metrics_by_followers_columns()
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
        post_id,
        is_from_followers,
        post_media_view as media_views
    from fields
)

select *
from final
