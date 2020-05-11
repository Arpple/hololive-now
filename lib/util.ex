defmodule Util do
  def parse_int(str) do
    {num, _} = Integer.parse(str)
    num
  end
end
