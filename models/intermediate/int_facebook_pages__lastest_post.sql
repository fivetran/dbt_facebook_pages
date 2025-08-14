with posts as (
    
    select *
    from {{ ref('stg_facebook_pages__post_history') }}

), most_recent_posts as (

    select
        *,
        row_number() over (partition by post_id, source_relation order by _fivetran_synced desc) = 1 as is_most_recent_record
    from posts
)

select *
from most_recent_posts