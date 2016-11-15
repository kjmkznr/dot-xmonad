import System.IO                        -- for xmobar
import XMonad hiding (Tall)

import XMonad.Actions.UpdatePointer

import XMonad.Hooks.DynamicLog          -- logHook-related
import XMonad.Hooks.EwmhDesktops        -- ewmh, fullscreenEventHook
import XMonad.Hooks.InsertPosition
import XMonad.Hooks.ManageDocks         -- manageDocks, avoidStruts, docksEventHook
import XMonad.Hooks.ManageHelpers       -- isFullscreen, doFullFloat

import XMonad.Layout.HintedTile
import XMonad.Layout.LayoutScreens      -- layoutSplitScreen
import XMonad.Layout.Maximize
import XMonad.Layout.Minimize
import XMonad.Layout.NoBorders          -- smartBorders, noBorders
import XMonad.Layout.Renamed
import XMonad.Layout.TwoPane

import XMonad.Prompt                    -- XPConfig
import XMonad.Prompt.Shell              -- shellPrompt
import XMonad.Prompt.Window

import XMonad.Util.Cursor               -- setDefaultCursor
import XMonad.Util.EZConfig             -- additionalKeysP
import XMonad.Util.Run                  -- unsafeSpawn, spawnPipe, hPutStrLn
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.WorkspaceCompare     -- getSortByXineramaRule

--------------------------------------------------------------------------- }}}
-- local variables                                                          {{{
-------------------------------------------------------------------------------

myTerminal = "xterm"

myModMask = mod4Mask

-- Font settings
myFont = "xft:Nasu M:size=10"

-- Color Setting
colorBlue      = "#9fc7e8"
colorGreen     = "#70be74"
colorRed       = "#ef9a9a"
colorGray      = "#9e9e9e"
colorWhite     = "#ffffff"
colorBlack     = "#000000"
colorGrayAlt   = "#eceff1"
colorfg        = "#9fa8b1"

--------------------------------------------------------------------------- }}}
-- main                                                                     {{{
-------------------------------------------------------------------------------

main = do
  wsbar <- spawnPipe myWsBar
  xmonad $ ewmh
         $ def
              { layoutHook      = myLayoutHook
              , manageHook      = myManageHook
              , handleEventHook = myHandleEventHook
              , modMask         = myModMask
              -- xmobar setting
              , logHook         = myLogHook wsbar
                                  >> updatePointer (0.99, 0.99) (1, 1)
              , startupHook     = myStartupHook
              }
            `additionalKeysP` myAdditionalKeysP

myLayoutHook =   renamed [CutWordsLeft 2]
                 $ smartBorders $ avoidStruts $ maximize $ minimize
                 $ (hintedTile Tall ||| hintedTile Wide)
             ||| (avoidStruts $ noBorders Full)
    where
        hintedTile = HintedTile nmaster delta ratio TopLeft
        nmaster    = 1
        ratio      = 1/2
        delta      = 3/100

myManageHook =   manageDocks
             <+> composeAll [
                        isFullscreen                      --> doFullFloat
                      , className =? "mpv"                --> doFloat
                      , className =? "Gimp"               --> doFloat
                      ]
             <+> insertPosition Below Newer

-- 
myHandleEventHook =   docksEventHook
                  <+> fullscreenEventHook

--------------------------------------------------------------------------- }}}
---- myLogHook:         loghock settings                                    {{{
-------------------------------------------------------------------------------

myLogHook h = dynamicLogWithPP $ wsPP { ppOutput = hPutStrLn h }

--------------------------------------------------------------------------- }}}
-- myWsBar:           xmobar setting                                        {{{
-------------------------------------------------------------------------------

myWsBar = "xmobar $HOME/.xmonad/xmobarrc.hs"

wsPP = xmobarPP { ppOrder           = \(ws:l:t:_)  -> [ws,t]
                , ppCurrent         = xmobarColor colorGreen    colorBlack . \s -> "●"
                , ppUrgent          = xmobarColor colorRed      colorBlack . \s -> "●"
                , ppVisible         = xmobarColor colorfg       colorBlack . \s -> "●"
                , ppHidden          = xmobarColor colorGray     colorBlack . \s -> "●"
                , ppHiddenNoWindows = xmobarColor colorGrayAlt  colorBlack . \s -> "◯"
                , ppTitle           = xmobarColor colorGreen    colorBlack
                , ppOutput          = putStrLn
                , ppWsSep           = " "
                , ppSep             = "  "
                }

--------------------------------------------------------------------------- }}}

myStartupHook = do
    setDefaultCursor xC_left_ptr
    unsafeSpawn myTerminal

myAdditionalKeysP = [
      ("M-r",   shellPrompt myXPConfig)
    , ("M-g",   windowPromptGoto myXPConfig)
    , ("M-m",   withFocused (sendMessage . maximizeRestore))
    , ("M-n",   withFocused minimizeWindow)
    , ("M-S-n", sendMessage RestoreNextMinimizedWin)

    -- toggle dock visibility
    , ("M-b", sendMessage ToggleStruts)

    -- split screen
    , ("M1-<Space>",   layoutSplitScreen 2 (TwoPane (3/100) 0.7))
    , ("M-M1-<Space>", rescreen)

    -- Volume setting media keys
    , ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume 0 +5% && paplay /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga")
    , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume 0 -5% && paplay /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga")
    , ("<XF86AudioMute>", spawn "pactl set-sink-mute 0 toggle")
    -- Brightness Keys
    , ("<XF86MonBrightnessUp>", spawn "xbacklight + 5 -time 100 -steps 1")
    , ("<XF86MonBrightnessDown>", spawn "xbacklight - 5 -time 100 -steps 1")

    -- other commands
    , ("M-S-l", unsafeSpawn "alock -auth pam -bg blank")
    , ("M-c",   unsafeSpawn "chromium --incognito --force-device-scale-factor=1.0")
    ]

myXPConfig = greenXPConfig {
                   font              = myFont
                 , promptBorderWidth = 0
                 , position          = Top
                 , alwaysHighlight   = True
                 , height            = 30
                 }
