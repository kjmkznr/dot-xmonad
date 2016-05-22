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
       , commands = [ Run Weather "RJTT" ["-t",       "<skyCondition> / <tempC>C"
                                          ,"-L",      "18"
                                          ,"-H",      "25",
                                          "--normal", "green",
                                          "--high",   "red",
                                          "--low",    "lightblue"
                                          ] 36000
                    , Run Network "enp0s25" ["-L",        "0"
                                            ,"-H",        "32"
                                            ,"--normal",  "green"
                                            ,"--high",    "red"
                                            ] 10
                    , Run Network "wlp3s0" ["-L","0","-H","32",
                                          "--normal","green","--high","red"] 10
                    , Run Cpu ["-L","3","-H","50",
                               "--normal","green","--high","red"] 10
                    , Run Memory ["-t","Mem: <usedratio>%"] 10
                    , Run Swap [] 10
                    , Run Com "uname" ["-s","-r"] "" 36000
                    , Run BatteryP ["BAT0", "BAT1"]
                                   ["-t", "<acstatus>"
                                   , "-L", "10", "-H", "80"
                                   , "-l", "red", "-h", "green"
                                   , "--", "-O", "Charging", "-o", "Battery: <left>%"
                                   ] 10
                    , Run Date "%Y/%m/%d %H:%M:%S" "date" 10
                    ]
       , sepChar = "%"
       , alignSep = "}{"
       , template = "%cpu% | %memory% * %swap% | %enp0s25% - %wlp3s0% }{ %RJTT% | %battery% | <fc=#ee9a00>%date%</fc>"
       }
