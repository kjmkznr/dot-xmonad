import XMonad hiding (Tall)
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
import XMonad.Util.WorkspaceCompare     -- getSortByXineramaRule
{- import XMonad.Util.Scratchpad -}
{- import XMonad.StackSet as W -}

myTerminal = "xterm"
myXMobar = "xmobar $HOME/.xmonad/xmobarrc.hs"

-- Font settings
myFont = "xft:Nasu M:size=10"

-- Color Setting
colorBlue      = "#9fc7e8"
colorGreen     = "#a5d6a7"
colorRed       = "#ef9a9a"
colorGray      = "#9e9e9e"
colorWhite     = "#ffffff"
colorGrayAlt   = "#eceff1"
colorNormalbg  = "#1c1c1c"
colorfg        = "#9fa8b1"

main = do
    myStatusBar <- spawnPipe myXMobar
    xmonad $ ewmh
           $ defaultConfig {
                   layoutHook      = myLayoutHook
                 , manageHook      = myManageHook
                 , handleEventHook = myHandleEventHook
                 , modMask         = myModMask
                 , logHook         = myLogHook myStatusBar
                 , startupHook     = myStartupHook
                 }
                 `additionalKeysP` myAdditionalKeysP

myModMask = mod4Mask

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
             {- <+> manageScratchPad -}

-- Scratchpad
{- manageScratchPad :: ManageHook -}
{- manageScratchPad = scratchpadManageHook (W.RationalRect l t w h) -}
  {- where -}
    {- h = 0.1     -- terminal height, 10% -}
    {- w = 1       -- terminal width, 100% -}
    {- t = 1 - h   -- distance from top edge, 90% -}
    {- l = 1 - w   -- distance from left edge, 0% -}

-- 
myHandleEventHook =   docksEventHook
                  <+> fullscreenEventHook

myLogHook h = dynamicLogWithPP xmobarPP {
                    ppSep    = " | "
                  , ppTitle  = xmobarColor colorGreen "" . shorten 80
                  , ppOutput = hPutStrLn h
                  , ppSort   = getSortByXineramaRule
                  }

myStartupHook = do
    setDefaultCursor xC_left_ptr
    unsafeSpawn myTerminal

myAdditionalKeysP = [
      ("M-p",   shellPrompt myXPConfig)
    , ("M-g",   windowPromptGoto myXPConfig)
    , ("M-m",   withFocused (sendMessage . maximizeRestore))
    , ("M-n",   withFocused minimizeWindow)
    , ("M-S-n", sendMessage RestoreNextMinimizedWin)

    -- spawn scratchpad
    {- , ("M-s", scratchPad) -}

    -- toggle dock visibility
    , ("M-b", sendMessage ToggleStruts)

    -- split screen
    , ("M1-<Space>",   layoutSplitScreen 2 (TwoPane (3/100) 0.7))
    , ("M-M1-<Space>", rescreen)

    -- volume control
    , ("<XF86AudioRaiseVolume>", unsafeSpawn "amixer set Master playback 10+")
    , ("<XF86AudioLowerVolume>", unsafeSpawn "amixer set Master playback 10-")
    , ("<XF86AudioMute>",        unsafeSpawn "amixer set Master toggle")

    -- other commands
    , ("M-S-l", unsafeSpawn "alock -auth pam -bg blank")
    , ("M-c",   unsafeSpawn "chromium --incognito --force-device-scale-factor=1.6")
    ]

    {- where -}
      {- scratchPad = scratchpadSpawnActionTerminal myTerminal -}

myXPConfig = greenXPConfig {
                   font              = myFont
                 , promptBorderWidth = 0
                 , position          = Top
                 , alwaysHighlight   = True
                 , height            = 30
                 }
