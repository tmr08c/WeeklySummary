defmodule WeeklySummary.Main do
  alias WeeklySummary.IssueRequester
  alias WeeklySummary.Report

  def main(args) do
    {parsed, org, _} = OptionParser.parse(args, switches: [num_days: :integer])

    case length(org) do
      0 -> exit("Organization name required")
      1 ->
        org
        |> IssueRequester.issues(calculate_date_range(parsed))
        |> Report.generate
      _ -> exit("Only one organization may be specified")
    end
  end

  defp calculate_date_range([num_days: num_days]) do
    today = Timex.now() |>  Timex.beginning_of_day()
    start_date = today |> Timex.shift(days: -num_days)

    %{start_date: start_date, end_date: today}
  end

  defp calculate_date_range([]) do
    today = Timex.now() |> Timex.beginning_of_day()
    start_date = today |> Timex.shift(days: -7)

    %{start_date: start_date, end_date: today}
  end
end
