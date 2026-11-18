# Decision Log

## Media views fall back to deprecated impressions fields
Facebook deprecated most impressions metrics on November 15, 2025. Fivetran replaced them with media view metrics: the `post_media_view` and `page_media_view` fields, and the `lifetime_post_metrics_by_paid_organic`, `lifetime_post_metrics_by_followers`, and `daily_page_metrics_by_paid_organic` tables.

To keep history, the `media_views*` fields in `facebook_pages__posts_report` and `facebook_pages__pages_report` use the media view value when it exists. Otherwise, they fall back to the matching deprecated impressions field:

| Field | Fallback |
| --- | --- |
| `media_views` | `impressions` |
| `media_views_paid` | `impressions_paid` |
| `media_views_organic` | `impressions_organic` |
| `media_views_followers` (posts only) | `impressions_fan` |

Media views and impressions are not the same metric. Facebook counts them differently, so expect a shift in these fields around the switchover date. If you need only one metric, use the deprecated `impressions*` fields, which we keep unchanged, or filter by date.

`media_views_non_followers` has no impressions counterpart, so it has no fallback. Followers and non-followers media views don't always add up to `media_views`, because Facebook doesn't report a full split for every post.

Viral and non-viral impressions have no replacement. We keep those deprecated fields unchanged for historical reporting.
