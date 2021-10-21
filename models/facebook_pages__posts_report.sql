with posts as (

    select *
    from {{ var('posts') }}
    where is_most_recent_record = True

), pages as (

    select *
    from {{ var('pages') }}

), post_metrics as (

    select *
    from {{ var('post_metrics') }}

), joined as (

    select 
        posts.created_timestamp,
        posts.post_id,
        posts.post_message,
        posts.page_id,
        pages.page_name,
        post_metrics.date_day,
        post_metrics.clicks,
        post_metrics.impressions,
        post_metrics.video_avg_time_watched,
        post_metrics.video_view_time,
        post_metrics.video_views,
        post_metrics.video_views_10s,
        post_metrics.video_views_15s,
        post_metrics.reactions_like_total as likes
    from post_metrics
    left join posts
        on post_metrics.post_id = posts.post_id
    left join pages
        on posts.page_id = pages.page_id

)

select *
from joined