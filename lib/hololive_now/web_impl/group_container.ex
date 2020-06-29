defmodule HololiveNow.WebImpl.GroupContainer do
  @moduledoc false

  def from_container_divs(divs) do
    list = Enum.reduce(divs, [], fn div, groups ->
      if has_date?(div) do
        [ new_group(div) | groups ]
      else
        add_last_group(groups, div)
      end
    end)

    Enum.reverse(list)
  end

  defp new_group(div) do
    %{
      date: get_date(div),
      containers: get_containers(div),
    }
  end

  defp add_last_group([], _div), do: []
  
  defp add_last_group([ last_group | groups ], div) do
    group = add_containers(last_group, div)
    [ group | groups ]
  end

  defp add_containers(%{ containers: containers } = group, div) do
    new_containers = get_containers(div)
    %{ group | containers: containers ++ new_containers }
  end

  defp has_date?(group_container) do
    datetime = Floki.find(group_container, ".navbar-text")
    not Enum.empty?(datetime)
  end
  
  defp get_date(div) do
    [date_str, _] = div
    |> Floki.find(".navbar-text")
    |> Enum.at(0)
    |> Floki.text()
    |> String.trim()
    |> String.split("\n")

    [month, date] = date_str
    |> String.trim()
    |> String.split("/")
    |> Enum.map(&Util.parse_int/1)

    year = DateTime.utc_now().year

    {:ok, date} = Date.new(year, month, date)
    date
  end

  defp get_containers(div) do
    div
    |> Floki.find(".thumbnail")
  end
end
