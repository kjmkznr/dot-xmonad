Config { font = "xft:Nasu M:size=10"
       , additionalFonts = []
       , borderColor = "black"
       , border = TopB
       , bgColor = "black"
       , fgColor = "grey"
       , alpha = 255
       , position = Top
       , textOffset = -1
       , iconOffset = -1
       , lowerOnStart = True
       , pickBroadest = False
       , persistent = False
       , hideOnStart = False
       , iconRoot = "."
       , allDesktops = True
       , overrideRedirect = True
       , commands = [ Run Weather "RJTT"        ["-t",       "<skyCondition> / <tempC>C"
                                                ,"-L",      "18"
                                                ,"-H",      "25",
                                                "--normal", "green",
                                                "--high",   "red",
                                                "--low",    "lightblue"
                                                ] 36000
                    , Run Network "enp0s31f6"   [ "-t"       , "eth0: <icon=/home/kazunori/.icons/sm4tik-icon-pack/xbm/net_down_03.xbm/><rx>  <icon=/home/kazunori/.icons/sm4tik-icon-pack/xbm/net_up_03.xbm/><tx>   "
                                                , "-L"       , "40"
                                                , "-H"       , "200"
                                                , "-m"       , "3"
                                                , "--normal" , "green"
                                                , "--high"   , "red"
                                                ] 10
                    , Run Network "wlp4s0"      [ "-t"       , "<icon=/home/kazunori/.icons/sm4tik-icon-pack/xbm/wifi_02.xbm/> <icon=/home/kazunori/.icons/sm4tik-icon-pack/xbm/net_down_03.xbm/><rx>  <icon=/home/kazunori/.icons/sm4tik-icon-pack/xbm/net_up_03.xbm/><tx>   "
                                                , "-L"       , "40"
                                                , "-H"       , "200"
                                                , "-m"       , "3"
                                                , "--normal" , "green"
                                                , "--high"   , "red"
                                                ] 10
                    , Run MultiCpu              [ "-t"        , "<icon=/home/kazunori/.icons/sm4tik-icon-pack/xbm/cpu.xbm/> <total0>.<total1>.<total2>.<total3>   "
                                                , "-L"        , "3"
                                                , "-H"        , "50"
                                                , "-m"        , "2"
                                                , "--normal"  , "green"
                                                , "--high"    , "red"
                                                ] 10
                    , Run Memory                [ "-t"       , "<icon=/home/kazunori/.icons/sm4tik-icon-pack/xbm/mem.xbm/> <usedratio>%   "
                                                , "-L"       , "40"
                                                , "-H"       , "90"
                                                , "-m"       , "2"
                                                , "--normal" , "#ffffff"
                                                , "--high"   , "#f44336"
                                                ] 10
--                    , Run Swap                  [
--                                                ] 10
--                    , Run Com "uname" ["-s","-r"] "" 36000
                    , Run BatteryP              ["BAT0", "BAT1"]
                                                [ "-t", "<icon=/home/kazunori/.icons/sm4tik-icon-pack/xbm/bat_full_02.xbm/> <acstatus>"
                                                , "-L", "10"
                                                , "-H", "80"
                                                , "-l", "red"
                                                , "-h", "green"
                                                , "--"
                                                    , "-o", "<left>% (<timeleft>)"
                                                    , "-O", "Charging: <left>%"
                                                    , "-i", "<left>%"
                                                ] 50
                    , Run Date "%Y/%m/%d %H:%M:%S" "date" 10
                    ]
       , sepChar = "%"
       , alignSep = "}{"
       , template = "%multicpu%%memory%%enp0s31f6%%wlp4s0% }{ %RJTT% %battery% <fc=#ee9a00>%date%</fc>"
       }
