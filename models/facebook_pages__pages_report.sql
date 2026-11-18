with pages as (

    select *
    from {{ ref('stg_facebook_pages__page') }}

), page_metrics as (

    select *
    from {{ ref('stg_facebook_pages__daily_page_metrics_total') }}
    
{% if var('facebook_pages__using_daily_page_metrics_by_paid_organic', True) %}
), paid_organic_metrics as (

    select *
    from {{ ref('int_facebook_pages__page_media_views_by_paid_organic') }}

{% endif %}
), joined as (

    select 
        page_metrics.date_day,
        pages.page_id,
        pages.page_name,
        page_metrics.actions_post_reactions_total,
        page_metrics.fan_adds, -- Deprecated as of November, 2025. Will be removed in future release.
        page_metrics.fan_removes, -- Deprecated as of November, 2025. Will be removed in future release.
        page_metrics.impressions, -- Deprecated as of November, 2025. Will be removed in future release.
        -- Media view fields fall back to the matching deprecated impressions field so records before the media view metrics existed keep their values.
        coalesce(page_metrics.media_views, page_metrics.impressions) as media_views,
        {% if var('facebook_pages__using_daily_page_metrics_by_paid_organic', True) %}
        coalesce(paid_organic_metrics.media_views_paid, page_metrics.impressions_paid) as media_views_paid,
        coalesce(paid_organic_metrics.media_views_organic, page_metrics.impressions_organic) as media_views_organic,
        {% else %}
        page_metrics.impressions_paid as media_views_paid,
        page_metrics.impressions_organic as media_views_organic,
        {% endif %}
        page_metrics.post_engagements,
        page_metrics.posts_impressions,
        page_metrics.video_complete_views_30s,
        page_metrics.video_views,
        page_metrics.video_views_10s,
        page_metrics.views_total,    
        page_metrics.source_relation
    from page_metrics
    left join pages
        on page_metrics.page_id = pages.page_id
        and page_metrics.source_relation = pages.source_relation
    {% if var('facebook_pages__using_daily_page_metrics_by_paid_organic', True) %}
    left join paid_organic_metrics
        on page_metrics.page_id = paid_organic_metrics.page_id
        and page_metrics.date_day = paid_organic_metrics.date_day
        and page_metrics.source_relation = paid_organic_metrics.source_relation
    {% endif %}

)

select *
from joined