defmodule WeeklySummary.Report do
  def generate(issues) do
     Enum.each(issues, &repo_section/1)
  end

  defp repo_section({repo_name, issues}) do
    IO.puts "# #{repo_name}\n"
    Enum.each(issues, fn(issue) -> IO.puts "* #{issue}" end)
    IO.puts ""
  end
end
