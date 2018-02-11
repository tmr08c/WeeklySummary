defmodule WeeklySummary.Main do
  alias WeeklySummary.DateOptionParser
  alias WeeklySummary.IssueRequester
  alias WeeklySummary.Report

  def main(args) do
    {parsed, org, _} = OptionParser.parse(args, switches: [num_days: :integer])

    case length(org) do
      0 -> exit("Organization name required")
      1 ->
        org
        |> IssueRequester.issues(DateOptionParser.calculate_date_range(parsed))
        |> Report.generate
      _ -> exit("Only one organization may be specified")
    end
  end
end
