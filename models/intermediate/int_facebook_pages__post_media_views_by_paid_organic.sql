{{ config(enabled=var('facebook_pages__using_lifetime_post_metrics_by_paid_organic', True)) }}

with media_view_splits as (

    select *
    from {{ ref('stg_facebook_pages__lifetime_post_metrics_by_paid_organic') }}

), final as (

    select
        source_relation,
        post_id,
        date_day,
        sum(case when is_from_ads then media_views end) as media_views_paid,
        sum(case when not is_from_ads then media_views end) as media_views_organic
    from media_view_splits
    group by 1, 2, 3
)

select *
from final
