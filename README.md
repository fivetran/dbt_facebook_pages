[![Apache License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) ![dbt logo and version](https://img.shields.io/static/v1?logo=dbt&label=dbt-version&message=>=[0.20.0,1.0.0]&color=orange)
# Facebook Pages

This package models Facebook Pages data from [Fivetran's connector](https://fivetran.com/docs/applications/facebook-pages). It uses data in the format described by [this ERD](https://fivetran.com/docs/applications/facebook-pages#schemainformation).

The main focus of the package is to transform the core social media object tables into analytics-ready models that can be easily unioned in to other social media platform packages to get a single view. This is especially easy using our [Social Media Reporting package](https://github.com/fivetran/dbt_social_media_reporting).

## Models

This package contains transformation models, designed to work simultaneously with our [Facebook Pages source package](https://github.com/fivetran/dbt_facebook_pages_source) and our [multi-platform Social Media Reporting package](https://github.com/fivetran/dbt_social_media_reporting). A dependency on the source package is declared in this package's `packages.yml` file, so it will automatically download when you run `dbt deps`. The primary outputs of this package are described below.

| **model**                    | **description**                                                                                                        |
| ---------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| [facebook_pages__pages_report](https://github.com/fivetran/dbt_facebook_pages/blob/main/models/facebook_pages__pages_report.sql)         | Each record represents the daily performance of a Facebook Page. |
| [facebook_pages__posts_report](https://github.com/fivetran/dbt_facebook_pages/blob/main/models/facebook_pages__posts_report.sql)     | Each record represents the daily performance of a Facebook post.                                                      |

## Installation Instructions
Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

Include in your `packages.yml`

```yaml
packages:
  - package: fivetran/facebook_pages
    version: [">=0.1.0", "<0.2.0"]
```

## Configuration
By default, this package will look for your Facebook Pages data in the `facebook_pages` schema of your [target database](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile). If this is not where your Facebook Pages data is, please add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
    facebook_pages_schema: your_schema_name
    facebook_pages_database: your_database_name 
```

### Unioning Multiple Facebook Pages Connectors
If you have multiple Facebook Pages connectors in Fivetran and would like to use this package on all of them simultaneously, we have provided functionality to do so. The package will union all of the data together and pass the unioned table(s) into the final models. You will be able to see which source it came from in the `source_relation` column(s) of each model. To use this functionality, you will need to set either (**note that you cannot use both**) the `union_schemas` or `union_databases` variables:

```yml
# dbt_project.yml
...
config-version: 2
vars:
    ##You may set EITHER the schemas variables below
    facebook_pages_union_schemas: ['facebook_pages_one','facebook_pages_two']

    ##Or may set EITHER the databases variables below
    facebook_pages_union_databases: ['facebook_pages_one','facebook_pages_two']
```
### Changing the Build Schema

By default, this package will build the Facebook Pages staging models within a schema titled (`<target_schema>` + `_stg_facebook_pages`) and the final Facebook Pages models within a schema titled (`<target_schema>` + `_facebook_pages`) in your target database. If this is not where you would like your Facebook Pages staging data to be written to, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
models:
    facebook_pages:
      +schema: my_new_schema_name # leave blank for just the target_schema
    facebook_pages_source:
      +schema: my_new_schema_name # leave blank for just the target_schema
```

## Contributions

Don't see a model or specific metric you would have liked to be included? Notice any bugs when installing and running the package? If so, we highly encourage and welcome contributions to this package! 
Please create issues or open PRs against `main`. See [the Discourse post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) for information on how to contribute to a package.

## Database Support

This package has been tested on BigQuery, Snowflake, Redshift, Postgres, and Databricks.

### Databricks Dispatch Configuration
dbt `v0.20.0` introduced a new project-level dispatch configuration that enables an "override" setting for all dispatched macros. If you are using a Databricks destination with this package you will need to add the below (or a variation of the below) dispatch configuration within your `dbt_project.yml`. This is required in order for the package to accurately search for macros within the `dbt-labs/spark_utils` then the `dbt-labs/dbt_utils` packages respectively.
```yml
# dbt_project.yml

dispatch:
  - macro_namespace: dbt_utils
    search_order: ['spark_utils', 'dbt_utils']
```

## Resources:
- Provide [feedback](https://www.surveymonkey.com/r/DQ7K7WW) on our existing dbt packages or what you'd like to see next
- Have questions or feedback, or need help? Book a time during our office hours [here](https://calendly.com/fivetran-solutions-team/fivetran-solutions-team-office-hours) or email us at solutions@fivetran.com.
- Find all of Fivetran's pre-built dbt packages in our [dbt hub](https://hub.getdbt.com/fivetran/)
- Learn how to orchestrate dbt transformations with Fivetran [here](https://fivetran.com/docs/transformations/dbt).
- Learn more about Fivetran overall [in our docs](https://fivetran.com/docs)
- Check out [Fivetran's blog](https://fivetran.com/blog)
- Learn more about dbt [in the dbt docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the dbt blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
