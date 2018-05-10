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

  def get_recently_closed(%{owner: owner, name: name}, client, dates = %{start_date: start_date, end_date: end_date}) do
    Tentacat.Issues.filter(owner, name, %{state: "closed", since: format_date(start_date)}, client)
    |> Stream.filter(&pull_request?/1)
    |> Stream.filter(&(closed_in_range?(&1, dates)))
    |> Stream.map(fn(issue) -> issue["title"] end)
    |> Enum.to_list
  end

  @doc """
  Checks the `Issue` response for the existence of the `pull_request` key. This
  indicates that the `Issue` is actually a `Pull Request` .
  """
  def pull_request?(issue) do
    issue["pull_request"]
  end

  @doc """
  The GutHub API allows you to filter on `since` which deals with `updated_at`.
  This can result in returning isses that were updated (e.g., a comment was added,
  the branch was removed) recently but were closed earlier.

  As a result we need to also check the returned issues for `closed_at` to see when the issue
  was actually closed, rather than it was most recently updated.
  """
  def closed_in_range?(issue, %{start_date: start_date, end_date: end_date}) do
    {:ok, closed_at} = Timex.parse(issue["closed_at"], @github_datetime_format)

    Timex.between?(closed_at, start_date, end_date)
  end

  defp format_date(date) do
    {:ok, formatted_date} = Timex.format(date, @github_datetime_format)

    formatted_date
  end
end
