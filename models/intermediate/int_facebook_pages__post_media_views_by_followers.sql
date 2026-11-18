{{ config(enabled=var('facebook_pages__using_lifetime_post_metrics_by_followers', True)) }}

with media_view_splits as (

    select *
    from {{ ref('stg_facebook_pages__lifetime_post_metrics_by_followers') }}

), final as (

    select
        source_relation,
        post_id,
        date_day,
        sum(case when is_from_followers then media_views end) as media_views_followers,
        sum(case when not is_from_followers then media_views end) as media_views_non_followers
    from media_view_splits
    group by 1, 2, 3
)

select *
from final
