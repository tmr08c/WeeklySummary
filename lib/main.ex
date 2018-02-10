defmodule WeeklySummary.Main do
  alias WeeklySummary.IssueRequester
  alias WeeklySummary.Report

  def main(_args) do
    IssueRequester.issues
    |> IO.inspect
    |> Report.generate
  end
end
