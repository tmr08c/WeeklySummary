# Github Weekly Summary Generator

This tool can be used to generate a Markdown File containing the last 7 days of closed pull requests for the `roirevolution` organization.

## Installation 

1. Clone the repo
2. Build the escript `mix escript.build`

### Github Access Token

You will need a Github access token that has access to the organization you are fetching pull request information for.

You can generate this token in [your Github setting](https://github.com/settings/tokens).

This `access_token` is accessed via an environmental variable. You can `export` it or specify it when running the script. 

## Running

```bash
# Set the environmental variable
export GITHUB_ACCESS_TOKEN="MY_TOKEN"
./weekly_summary ORGANIZATION_NAME

# Set at run time
GITHUB_ACCESS_TOKEN=MY_TOKEN ./weekly_summary ORGANIZATION_NAME
```

This will print the Weekly Summary to `stdout`. This script is most useful to run and redirect ourput to a file

```bash
./weekly_summary > this_week.md
``` 
