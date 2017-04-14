# Github Weekly Summary Generator

This tool can be used to generate a Markdown File containing the last 7 days of closed pull requests for the `roirevolution` organization.

## Installation

1. Clone the repo
2. Build the escript `mix escript.build`

You may need to update elixir and dependecies. These things seem to do that:

1. `brew upgrade elixir`
2. `env MIX_ENV=dev mix deps.get`

Also, if you encounter this, answer with `Y`:

```
Mix requires Hex >= 0.14.0 but you have 0.13.2
Shall I abort the current command and update Hex? [Yn] Y
```

### Github Access Token

You will need a Github access token that has access to the `roirevolution` organization. Selecting the "repo" scope, which gives "Full control of private repositories", is both necessary and sufficient.

You can generate this token in [your Github setting](https://github.com/settings/tokens).

This `access_token` is accessed via an environmental variable. You can `export` it or specify it when running the script.

## Running

```bash
# Set the environmental variable
export GITHUB_ACCESS_TOKEN="MY_TOKEN"
./weekly_summary

# Set at run time
GITHUB_ACCESS_TOKEN=MY_TOKEN ./weekly_summary
```

This will print the Weekly Summary to `stdout`. This script is most useful to run and redirect ourput to a file

```bash
./weekly_summary > this_week.md
```
