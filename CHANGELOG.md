# dbt_facebook_pages v1.1.1

[PR #25](https://github.com/fivetran/dbt_facebook_pages/pull/25) includes the following updates:

## Schema/Data Change
**2 total change • 0 possible breaking changes**

| Data Model(s) | Change type | Old | New | Notes |
| ---------- | ----------- | -------- | -------- | ----- |
| `facebook_pages__posts_report`, `stg_facebook_pages__lifetime_post_metrics_total` | New Field | N/A | `media_views` | Added new field to track media/content views on the post |

# dbt_facebook_pages v1.1.0

[PR #22](https://github.com/fivetran/dbt_facebook_pages/pull/22) includes the following updates:

## Schema/Data Change
**2 total changes • 0 possible breaking changes**

| Data Model(s) | Change type | Old | New | Notes |
| ---------- | ----------- | -------- | -------- | ----- |
| `facebook_pages__pages_report`, `stg_facebook_pages__daily_page_metrics_total` | New Field | N/A | `media_views` | Added new field to track media/content views on the page |
| `facebook_pages__pages_report`, `facebook_pages__posts_report`, `stg_facebook_pages__daily_page_metrics_total`, `stg_facebook_pages__lifetime_post_metrics_total` | Deprecated Fields | Multiple impression and fan-related fields | Marked as [DEPRECATED] | Fields deprecated as of November 2025 and will not be populated by the Fivetran Facebook Pages connector after this date. Fields will be removed in a future release. Deprecated fields include: `fan_adds`, `fan_removes`, `fans`, `fans_online_per_day`, `impressions`, `impressions_nonviral`, `impressions_organic`, `impressions_paid`, `impressions_viral`, `impressions_fan`, `negative_feedback`, and `places_checkin_total` |

## Documentation
- Added deprecation notices to all affected fields in yml documentation files, clearly indicating these fields will not be populated by the Fivetran Facebook Pages connector following November 2025 and will be removed in a future release.
- Updated inline comments in staging models to indicate deprecated fields.

## Under the Hood
- Updated integration test schema names to standardize naming convention.
- Added `integration_tests/tests/` directory for validation tests.
- Updated integration test configuration to include models schema setting.

# dbt_facebook_pages v1.0.0
[PR #18](https://github.com/fivetran/dbt_facebook_pages/pull/18) includes the following updates:

## Breaking Changes

### Source Package Consolidation
- Removed the dependency on the `fivetran/facebook_pages_source` package.
  - All functionality from the source package has been merged into this transformation package for improved maintainability and clarity.
  - If you reference `fivetran/facebook_pages_source` in your `packages.yml`, you must remove this dependency to avoid conflicts.
  - Any source overrides referencing the `fivetran/facebook_pages_source` package will also need to be removed or updated to reference this package.
  - Update any facebook_pages_source-scoped variables to be scoped to only under this package. See the [README](https://github.com/fivetran/dbt_facebook_pages?tab=readme-ov-file#change-the-build-schema) for how to configure the build schema of staging models.
- As part of the consolidation, vars are no longer used to reference staging models, and only sources are represented by vars. Staging models are now referenced directly with `ref()` in downstream models.

### dbt Fusion Compatibility Updates
- Updated package to maintain compatibility with dbt-core versions both before and after v1.10.6, which introduced a breaking change to multi-argument test syntax (e.g., `unique_combination_of_columns`).
- Temporarily removed unsupported tests to avoid errors and ensure smoother upgrades across different dbt-core versions. These tests will be reintroduced once a safe migration path is available.
  - Removed all `dbt_utils.unique_combination_of_columns` tests.
  - Moved `loaded_at_field: _fivetran_synced` under the `config:` block in `src_facebook_pages.yml`.

### Under the Hood
- Updated conditions in `.github/workflows/auto-release.yml`.
- Added `.github/workflows/generate-docs.yml`.  

## Documentation
- Added Quickstart model counts to README. ([#15](https://github.com/fivetran/dbt_facebook_pages/pull/15))
- Corrected references to connectors and connections in the README. ([#15](https://github.com/fivetran/dbt_facebook_pages/pull/15))

# dbt_facebook_pages v0.3.0

[PR #11](https://github.com/fivetran/dbt_facebook_pages/pull/11) includes the following breaking changes:
## 🚨 Breaking Changes 🚨:
- This change is made breaking since columns have been removed in the source package (see the [dbt_facebook_pages_source v0.3.0 CHANGELOG](https://github.com/fivetran/dbt_facebook_pages_source/blob/main/CHANGELOG.md#dbt_facebook_pages_source-v030) for more details). 
    - No columns were removed from the end models in this package, however if you use the staging models independently, you will need to update your downstream use cases accordingly.
    - Columns removed from staging model `stg_facebook_pages__daily_page_metrics_total`:
        - `consumptions`
        - `content_activity`
        - `engaged_users`
        - `places_checkin_mobile`
        - `views_external_referrals`
        - `views_logged_in_total`
        - `views_logout`
    - Columns removed from staging model `stg_facebook_pages__lifetime_post_metrics_total`:
        - `impressions_fan_paid`

## Documentation Update
- Updated documentation to reflect the current schema. 

## Under the Hood:
- Incorporated the new `fivetran_utils.drop_schemas_automation` macro into the end of each Buildkite integration test job.
- Updated the pull request templates.
- Included auto-releaser GitHub Actions workflow to automate future releases.

# dbt_facebook_pages v0.2.0

## 🚨 Breaking Changes 🚨:
[PR #6](https://github.com/fivetran/dbt_facebook_pages/pull/6/) includes the following breaking changes:
- Dispatch update for dbt-utils to dbt-core cross-db macros migration. Specifically `{{ dbt_utils.<macro> }}` have been updated to `{{ dbt.<macro> }}` for the below macros:
    - `any_value`
    - `bool_or`
    - `cast_bool_to_text`
    - `concat`
    - `date_trunc`
    - `dateadd`
    - `datediff`
    - `escape_single_quotes`
    - `except`
    - `hash`
    - `intersect`
    - `last_day`
    - `length`
    - `listagg`
    - `position`
    - `replace`
    - `right`
    - `safe_cast`
    - `split_part`
    - `string_literal`
    - `type_bigint`
    - `type_float`
    - `type_int`
    - `type_numeric`
    - `type_string`
    - `type_timestamp`
    - `array_append`
    - `array_concat`
    - `array_construct`
- For `current_timestamp` and `current_timestamp_in_utc` macros, the dispatch AND the macro names have been updated to the below, respectively:
    - `dbt.current_timestamp_backcompat`
    - `dbt.current_timestamp_in_utc_backcompat`
- Dependencies on `fivetran/fivetran_utils` have been upgraded, previously `[">=0.3.0", "<0.4.0"]` now `[">=0.4.0", "<0.5.0"]`.

# dbt_facebook_pages v0.1.0

The original release! The main focus of the package is to transform the core social media object tables into analytics-ready models that can be easily unioned in to other social media platform packages to get a single view. This is especially easy using our [Social Media Reporting package](https://github.com/fivetran/dbt_social_media_reporting).
