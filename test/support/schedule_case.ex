defmodule HoliliveNow.ScheduleCase do
  def container() do
    {"div", [{"class", "container"}],
     [
       {"div", [{"class", "row"}],
        [
          {"div",
           [
             {"class", "col-12 col-sm-12 col-md-12"},
             {"style", "padding-left:5px;padding-right: 5px;"}
           ],
           [
             {"div",
              [
                {"class", "navbar navbar-inverse"},
                {"style", "background-color: #303030;border-radius: 4px;color:skyblue;"}
              ],
              [
                {"div",
                 [
                   {"class", "holodule navbar-text"},
                   {"style", "letter-spacing: 0.3em;"}
                 ],
                 [
                   "\n                                05/10\n                                (日)\n                            "
                 ]}
              ]}
           ]},
          {"div", [{"class", "col-12 col-sm-12 col-md-12"}], []}
        ]}
     ]}
  end

  def head() do
    {"div", [{"class", "col-12 col-sm-12 col-md-12"}, {"style", "padding:0;"}],
     [
       {"div", [{"class", "row no-gutters"}],
        [
          {"div",
           [
             {"class", "col-5 col-sm-5 col-md-5 text-left datetime"},
             {"style", "line-height:30px;"}
           ],
           [
             {"img",
              [
                {"src", "https://schedule.hololive.tv/dist/images/icons/youtube.png"},
                {"style",
                 "vertical-align:middle;position: relative;top:-0.1em; width:17px;height:17px;"}
              ], []},
             "\r\n                        00:02\r\n                    "
           ]},
          {"div",
           [
             {"class", "col text-right name"},
             {"style", "line-height:30px;margin-right:5px;"}
           ],
           [
             "\r\n                                                    百鬼あやめ\r\n                                            "
           ]}
        ]}
     ]}
  end

  def thumbnail() do
    {"div",
     [
       {"class", "col-12 col-sm-12 col-md-12"},
       {"style", "padding:0 0 5px 0;text-align: center;"}
     ],
     [
       {"img",
        [
          {"src", "https://img.youtube.com/vi/7ePTTaERAF8/mqdefault.jpg"},
          {"style", "box-shadow: 0 0 5px 5px black inset;"}
        ], []}
     ]}
  end
end
