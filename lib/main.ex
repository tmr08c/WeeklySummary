defmodule WeeklySummary.Main do
  alias WeeklySummary.IssueRequester
  alias WeeklySummary.Report

  def main(_args) do
    IssueRequester.issues
    |> Report.generate
  end
end
