with posts as (

    select *
    from {{ ref('int_facebook_pages__lastest_post') }}
    where is_most_recent_record = True

), pages as (

    select *
    from {{ ref('stg_facebook_pages__page') }}

), post_metrics as (

    select *
    from {{ ref('stg_facebook_pages__lifetime_post_metrics_total') }}

{% if var('facebook_pages__using_lifetime_post_metrics_by_paid_organic', True) %}
), paid_organic_metrics as (

    select *
    from {{ ref('int_facebook_pages__post_media_views_by_paid_organic') }}

{% endif %}
{% if var('facebook_pages__using_lifetime_post_metrics_by_followers', True) %}
), follower_metrics as (

    select *
    from {{ ref('int_facebook_pages__post_media_views_by_followers') }}

{% endif %}
), joined as (

    select 
        posts.created_timestamp,
        posts.post_id,
        posts.post_message,
        posts.post_url,
        posts.page_id,
        pages.page_name,
        post_metrics.date_day,
        post_metrics.clicks,
        post_metrics.impressions, -- Deprecated as of November, 2025. Will be removed in future release.
        -- Media view fields fall back to the matching deprecated impressions field so records before the media view metrics existed keep their values.
        coalesce(post_metrics.media_views, post_metrics.impressions) as media_views,
        {% if var('facebook_pages__using_lifetime_post_metrics_by_paid_organic', True) %}
        coalesce(paid_organic_metrics.media_views_paid, post_metrics.impressions_paid) as media_views_paid,
        coalesce(paid_organic_metrics.media_views_organic, post_metrics.impressions_organic) as media_views_organic,
        {% else %}
        post_metrics.impressions_paid as media_views_paid,
        post_metrics.impressions_organic as media_views_organic,
        {% endif %}
        {% if var('facebook_pages__using_lifetime_post_metrics_by_followers', True) %}
        coalesce(follower_metrics.media_views_followers, post_metrics.impressions_fan) as media_views_followers,
        follower_metrics.media_views_non_followers,
        {% else %}
        post_metrics.impressions_fan as media_views_followers,
        {% endif %}
        post_metrics.video_avg_time_watched,
        post_metrics.video_view_time,
        post_metrics.video_views,
        post_metrics.video_views_10s,
        post_metrics.video_views_15s,
        post_metrics.reactions_like_total as likes,
        post_metrics.source_relation,
        post_metrics.is_most_recent_record
    from post_metrics
    left join posts
        on post_metrics.post_id = posts.post_id
        and post_metrics.source_relation = posts.source_relation
    left join pages
        on posts.page_id = pages.page_id
        and posts.source_relation = pages.source_relation
    {% if var('facebook_pages__using_lifetime_post_metrics_by_paid_organic', True) %}
    left join paid_organic_metrics
        on post_metrics.post_id = paid_organic_metrics.post_id
        and post_metrics.date_day = paid_organic_metrics.date_day
        and post_metrics.source_relation = paid_organic_metrics.source_relation
    {% endif %}
    {% if var('facebook_pages__using_lifetime_post_metrics_by_followers', True) %}
    left join follower_metrics
        on post_metrics.post_id = follower_metrics.post_id
        and post_metrics.date_day = follower_metrics.date_day
        and post_metrics.source_relation = follower_metrics.source_relation
    {% endif %}

)

select *
from joined