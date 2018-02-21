defmodule WeeklySummary.IssueRequester do
  @github_datetime_format "{ISO:Extended:Z}"

  def issues(organization, dates) do
    client = Tentacat.Client.new(%{access_token: System.get_env("GITHUB_ACCESS_TOKEN")})

    Tentacat.Repositories.list_orgs(organization, client)
    |> extract_names
    |> Task.async_stream(__MODULE__, :fetch_closed_pull_requests, [client, dates])
    |> Stream.filter(fn({status, _values}) -> status == :ok end)
    |> Stream.map(fn{_status, data} -> data end)
    |> Stream.filter(fn({_repo, closed_issues}) -> Enum.count(closed_issues) > 0 end)
    |> Enum.to_list
  end

  def extract_names(repos) do
    Enum.reduce repos, [], fn(repo, acc) ->
      [%{ owner: repo["owner"]["login"], name: repo["name"]} | acc]
    end
  end

  def fetch_closed_pull_requests(repo, client, dates) do
    { repo.name, get_recently_closed(repo, client, dates) }
  end

  def get_recently_closed(%{owner: owner, name: name}, client, %{start_date: start_date, end_date: end_date}) do
    # `since` deals with `updated_at`
    # This could result in returning isses that were updated recently
    # but were closed earlier
    #
    # As a result we need to also check the returned issues for `closed_at`
    #
    # If the `pull_request` key exists that means the issue is a PR
    # this can result in duplicates where we have the issue and the PR for the issue
    # Going to make sure it's a PR since that means code exists to do a thing
    #
    Tentacat.Issues.filter(owner, name, %{state: "closed", since: format_date(start_date)}, client)
    |> Stream.filter(&pull_request?/1)
    |> Stream.filter(&(closed_in_range?(&1, end_date)))
    |> Stream.map(fn(issue) -> issue["title"] end)
    |> Enum.to_list
  end

  def pull_request?(issue) do
    issue["pull_request"]
  end

  def closed_in_range?(issue, end_date) do
    {:ok, closed_at} = Timex.parse(issue["closed_at"], @github_datetime_format)

    Timex.before?(closed_at, end_date)
  end

  defp format_date(date) do
    {:ok, formatted_date} = Timex.format(date, @github_datetime_format)

    formatted_date
  end
end
