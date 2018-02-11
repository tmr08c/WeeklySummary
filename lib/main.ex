defmodule WeeklySummary.Main do
  alias WeeklySummary.IssueRequester
  alias WeeklySummary.Report

  def main(args) do
    {_parsed, org, _} = OptionParser.parse(args)

    case length(org) do
      0 -> exit("Organization name required")
      1 ->
        org
        |> IssueRequester.issues
        |> Report.generate
      _ -> exit("Only one organization may be specified")
    end
  end
end
