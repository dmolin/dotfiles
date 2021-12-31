--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--
import GHC.IO.Handle.Types (Handle)
import Data.Ratio
import Data.List (isInfixOf)
import Data.Maybe (fromJust)
import qualified Data.Map        as M
import Control.Monad (unless, when)
import Foreign.C (CInt)
import Data.Foldable (find)
import Data.Monoid
import System.Exit

import XMonad (MonadIO, WorkspaceId, Layout, Window, ScreenId, ScreenDetail, WindowSet, layoutHook, logHook, X, io, ScreenId(..), gets, windowset, xmonad)
import XMonad hiding ((|||), float, Screen)
import XMonad.Util.SpawnOnce
import XMonad.Util.Run
import XMonad.Util.EZConfig (additionalKeysP)

import XMonad.Hooks.DynamicProperty
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat, doCenterFloat, doRectFloat, isDialog)
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.WorkspaceHistory (workspaceHistoryHook)
import XMonad.Hooks.StatusBar
import XMonad.Hooks.SetWMName
import XMonad.Hooks.FullscreenSupported (setFullscreenSupported)

import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Grid
import XMonad.Layout.ResizableTile
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
-- import XMonad.Layout.MultiToggle
-- import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.IndependentScreens
import XMonad.Layout.LayoutCombinators
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))

import XMonad.Actions.CycleWS (prevScreen, nextScreen, shiftPrevScreen, shiftNextScreen, swapNextScreen, swapPrevScreen, toggleOrDoSkip)
import XMonad.Actions.PhysicalScreens (getScreen, viewScreen, sendToScreen, onNextNeighbour, onPrevNeighbour)
import XMonad.Actions.UpdatePointer (updatePointer)
import XMonad.Actions.OnScreen (onlyOnScreen)

import XMonad.Util.WorkspaceCompare (getSortByXineramaRule)
import XMonad.Util.NamedScratchpad
import XMonad.Util.Loggers (logLayoutOnScreen, logTitleOnScreen, shortenL, wrapL, xmobarColorL)

import qualified XMonad.StackSet as W
import XMonad.StackSet (current, screen, visible, Screen, workspace, tag, sink, float, floating, RationalRect) 


-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "alacritty"
color06         = "#ffffff"

grey1, grey2, grey3, grey4, cyan, orange :: String
grey1  = "#2B2E37"
grey2  = "#555E70"
grey3  = "#697180"
grey4  = "#8691A8"
cyan   = "#8BABF0"
orange = "#ff7812"

actionPrefix, actionButton, actionSuffix :: [Char]
actionPrefix = "<action=`xdotool key super+"
actionButton = "` button="
actionSuffix = "</action>"

addActions :: [(String, Int)] -> String -> String
addActions [] ws = ws
addActions (x:xs) ws = addActions xs (actionPrefix ++ k ++ actionButton ++ show b ++ ">" ++ ws ++ actionSuffix)
    where k = fst x
          b = snd x

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth   = 2

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#ff0000"

toggleGreedyWS :: X ()
toggleGreedyWS = toggleOrDoSkip [] W.greedyView =<< gets (W.currentTag . windowset)

-- Toggle float/tiled mode for a window
toggleFloat :: Window -> X ()
toggleFloat w =
  windows
    ( \s ->
        if M.member w (W.floating s)
          then W.sink w s
          else (W.float w (W.RationalRect (1 / 3) (1 / 4) (1 / 2) (1 / 2)) s)
    )

scratchpads :: [NamedScratchpad]
scratchpads = [
  NS "term" "terminator -r scratchpad" (stringProperty "WM_WINDOW_ROLE" =? "scratchpad")
    (customFloating $ W.RationalRect (1/4) (2/4) (3/4) (1/4))
  ]

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    ---------------------------------------------------
    -- Applications
    ---------------------------------------------------
    -- launch a terminal
    [ ((modm, xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((modm,               xK_p     ), spawn "dmenu_run")

    -- launch gmrun
    , ((modm .|. shiftMask, xK_p     ), spawn "gmrun")

    -- file manager
    , ((modm, xK_F2), spawn "terminator --geometry 1600x1000 --role pop-up -e ranger")
    , ((modm, xK_F3), spawn "pcmanfm-qt")

    ---------------------------------------------------
    -- General functionalities (screenshots, audio etc)
    ---------------------------------------------------
    -- audio controls
    , ((0, xK_Pause), spawn "amixer set Master 2%+ && volnoti-show $(amixer get Master | grep -Po '[0-9]+(?=%)' | head -1)")
    , ((0, xK_Scroll_Lock), spawn "amixer set Master 2%- && volnoti-show $(amixer get Master | grep -Po '[0-9]+(?=%)' | head -1)")
    , ((modm .|. controlMask, xK_m), spawn "pavucontrol")
    -- XF86AudioRaiseVolume
    , ((modm, xK_F6), spawn "amixer set Master 2%+ && volnoti-show $(amixer get Master | grep -Po '[0-9]+(?=%)' | head -1)")
    -- XF86AudioLowerVolume
    , ((modm, xK_F5), spawn "amixer set Master 2%- && volnoti-show $(amixer get Master | grep -Po '[0-9]+(?=%)' | head -1)")
    -- screenshots
    , ((0, xK_Print), spawn "flameshot gui -p ~/Pictures")

    -- Lock the screen with mod + F1
    , ((modm, xK_F1), spawn "betterlockscreen -l")

    ---------------------------------------------------
    -- Windows and Workspaces
    ---------------------------------------------------
    -- close focused window
    , ((modm, xK_q     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)
    , ((modm .|. shiftMask, xK_space ), spawn "rofi -modi drun -show drun")
    , ((modm, xK_d ), spawn "rofi -show window")

    -- Switch to specific layouts
    , ((modm, xK_f), sendMessage $ JumpToLayout "Full")
    , ((modm, xK_t), sendMessage $ JumpToLayout "Spacing ResizableTall")
    , ((modm, xK_e), sendMessage $ JumpToLayout "Tabbed Simplest")
    , ((modm, xK_r), withFocused toggleFloat)

    ---------------------------------------------
    -- scratchpad
    ---------------------------------------------
    , ((modm, xK_grave), namedScratchpadAction scratchpads "term")

    -- Toggle powermenu
    -- , ((modm, xK_BackSpace), toggleWS' ["NSP"])
    , ((modm, xK_BackSpace), spawn "~/.config/rofi/scripts/powermenu.sh")

    --  Reset the layouts on the current workspace to default
    , ((modm, xK_0 ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_k     ), windows W.focusDown)
    , ((modm,               xK_Right  ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_j     ), windows W.focusUp  )
    , ((modm,               xK_Left  ), windows W.focusUp)

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm .|. shiftMask, xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapDown  )
    , ((modm .|. shiftMask, xK_Right     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapUp    )
    , ((modm .|. shiftMask, xK_Left     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)
    , ((modm .|. mod1Mask,  xK_Left  ), sendMessage Shrink)
    , ((modm .|. mod1Mask,  xK_Down    ), sendMessage MirrorShrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)
    , ((modm .|. mod1Mask,  xK_Right ), sendMessage Expand)
    , ((modm .|. mod1Mask,  xK_Up  ), sendMessage MirrorExpand)

    -- Push window back into tiling (no need. modm + r does it all)
    -- , ((modm .|. shiftMask,    xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Workspace controls

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_z     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm .|. shiftMask, xK_m     ), spawn "killall xmobar; xmonad --recompile; xmonad --restart")

    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    -- [((m .|. modm, k), windows $ f i)
    --     | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
    --     , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    [((m .|. modm, k), windows $ onCurrentScreen f i)
        | (i, k) <- zip (workspaces' conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    --[((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
    --    | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
    --    , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

    -- ++

    [((m .|. modm, key), f sc)
        | (key, sc) <- zip [xK_F10, xK_F11, xK_F12] [0..]
        , (f, m) <- [(viewScreen def, 0), (sendToScreen def, shiftMask)]]

myAdditionalKeys :: [(String, X ())]
myAdditionalKeys =
    -- workspace control
  [ ("M-]", onNextNeighbour def W.view)
  , ("M-[", onPrevNeighbour def W.view)
  , ("M-S-]", onNextNeighbour def W.shift)
  , ("M-S-[", onPrevNeighbour def W.shift)
  ]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                      >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myTabConfig = def {
  inactiveBorderColor = "#222222",
  fontName = "xft:agave Nerd Font:pixelsize=13:antialias=true:hinting=true",
  inactiveBorderWidth = 0
}

myLayout = avoidStruts $ smartBorders (tiled ||| Mirror tiled ||| tabs ||| grid ||| layoutFull)
-- myLayout = avoidStruts $ smartBorders $ lessBorders Screen (tiled ||| Mirror tiled ||| simpleTabbed ||| Grid ||| layoutFull)
  where
     spacing = 5
     -- default tiling algorithm partitions the screen into two panes
     tiled   = spacingRaw False (Border spacing spacing spacing spacing) True (Border spacing spacing spacing spacing) True $ ResizableTall nmaster delta ratio []

     grid   = spacingRaw False (Border spacing spacing spacing spacing) True (Border spacing spacing spacing spacing) True $ Grid 

     tabs = noBorders (tabbed shrinkText myTabConfig)

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100
     --layoutFull = noBorders Full
     layoutFull = Full

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
--

myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , className =? "alsamixer" --> doFloat
    , className =? "File Transfer" --> doFloat
    , className =? "Lightdm-settings" --> doFloat
    , className =? "Lxappearance" --> doFloat
    , className =? "Manjaro Settings Manager" --> doFloat
    , className =? "Pamac-manager" --> doRectFloat (W.RationalRect (1 % 4) (1 % 4) (1 % 2) (1 % 2))
    , className =? "Pavucontrol" --> doCenterFloat
    , className =? "qt5ct" --> doFloat
    , className =? "Skype" --> doFloat
    , className =? "VirtualBox Manager" --> doCenterFloat
    , resource  =? "kdesktop"       --> doIgnore
    , className =? "GParted" --> doCenterFloat
    , className =? "Gnome-calendar" --> doCenterFloat
    , role  =? "pop-up" --> doRectFloat (W.RationalRect (1 % 4) (1 % 4) (1 % 2) (1 % 2))
    , role  =? "GtkFileChooserDialog" --> doRectFloat (W.RationalRect (1 % 4) (1 % 4) (1 % 2) (1 % 2))
    , className =? "Cypress" --> doCenterFloat
    , name =? "int_test - Chromium" --> doCenterFloat
    , name =? "win0" --> doCenterFloat
    , name =? "Firewall" --> doCenterFloat
    , isDialog --> doCenterFloat
    , role =? "scratchpad" --> doCenterFloat
    ]
  where 
    role = stringProperty "WM_WINDOW_ROLE"
    name = stringProperty "WM_NAME"

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook :: Event -> X All
--myEventHook = mempty
myEventHook = dynamicPropertyChange "WM_NAME" (title =? "Slack" --> doShift "1_9")
  <+> multiScreenFocusHook

multiScreenFocusHook :: Event -> X All
multiScreenFocusHook MotionEvent { ev_x = x, ev_y = y } = do
  ms <- getScreenForPos x y
  case ms of
    Just cursorScreen -> do
      let cursorScreenID = W.screen cursorScreen
      focussedScreenID <- gets (W.screen . W.current . windowset)
      when (cursorScreenID /= focussedScreenID) (focusWS $ W.tag $ W.workspace cursorScreen)
      return (All True)
    _ -> return (All True)
  where getScreenForPos :: CInt -> CInt
            -> X (Maybe (W.Screen WorkspaceId (Layout Window) Window ScreenId ScreenDetail))
        getScreenForPos x y = do
          ws <- windowset <$> get
          let screens = W.current ws : W.visible ws
              inRects = map (inRect x y . screenRect . W.screenDetail) screens
          return $ fst <$> find snd (zip screens inRects)
        inRect :: CInt -> CInt -> Rectangle -> Bool
        inRect x y rect = let l = fromIntegral (rect_x rect)
                              r = l + fromIntegral (rect_width rect)
                              t = fromIntegral (rect_y rect)
                              b = t + fromIntegral (rect_height rect)
                           in x >= l && x < r && y >= t && y < b
        focusWS :: WorkspaceId -> X ()
        focusWS ids = windows (W.view ids)
multiScreenFocusHook _ = return (All True)

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
--myLogHook = do
    --fadeInactiveCurrentWSLogHook fadeAmount
      --where fadeAmount = 0.8

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do
        spawn "~/.config/xmonad/xmonad-startup.sh"
        spawnOnce "volnoti -a 0.9"
        spawnOnce "hsetroot -cover ~/.config/xmonad/wallpapers/wp2608227-wallpaper-4k.jpg"
        spawnOnce "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
        spawnOnce "xfce4-power-manager"
        spawnOnce "pamac-tray"
        spawnOnce "~/Applications/pcloud &"
        spawnOnce "conky &"
        spawnOnce "nm-applet"
        spawnOnce "xautolock -time 40 -locker blurlock"
        spawnOnce "fix-cursor"
        spawnOnce "~/.config/picom/start_picom.sh"
        spawnOnce "~/.config/_scripts_/redshift.sh &"
        spawn "~/.config/_scripts_/post.sh"
        setWMName "LG3D"
        modify $ \xstate -> xstate { windowset = onlyOnScreen 1 "1_1" (windowset xstate) }
        modify $ \xstate -> xstate { windowset = onlyOnScreen 2 "2_1" (windowset xstate) }

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

myWorkspaceIndices :: M.Map [Char] Integer
myWorkspaceIndices = M.fromList $ zip myWorkspaces [1..]

clickable :: [Char] -> [Char] -> [Char]
clickable icon ws = addActions [ (show i, 1), ("q", 2), ("Left", 4), ("Right", 5) ] icon
                    where i = fromJust $ M.lookup ws myWorkspaceIndices

-- Color of current window title in xmobar.
xmobarTitleColor = "#FFB6B0"
-- Color of current workspace in xmobar.
xmobarCurrentWorkspaceColor = "#CEFFAC"

myLogHook = do
  workspaceHistoryHook
  fadeInactiveCurrentWSLogHook 0.8
  updatePointer (0.5, 0.5) (0, 0)

myStatusBarSpawner :: Applicative f => ScreenId -> f StatusBarConfig
myStatusBarSpawner (S s) = do
  pure $ statusBarPropTo ("_XMONAD_LOG_" ++ show s)
         ("xmobar -x " ++ show s ++ " ~/.config/xmobar/xmobar.config." ++ show s)
         (pure $ myXmobarPP (S s))
         
myXmobarPP :: ScreenId -> PP
myXmobarPP s  = filterOutWsPP [scratchpadWorkspaceTag] . marshallPP s $ def
  { ppSep = "  "
  , ppWsSep = " "
  , ppCurrent = xmobarColor color06 "" . wrap ("<box type=Bottom width=2 mb=2 color=" ++ xmobarTitleColor ++ ">") "</box>"
  , ppTitle = xmobarColor xmobarTitleColor "" . shorten 50
  , ppVisible = xmobarColor grey4 "" . wrap ("") ""
  -- , ppVisibleNoWindows = Just(xmobarColor grey4 "")
  -- , ppHidden = xmobarColor grey2 "" 
  -- , ppHiddenNoWindows = xmobarColor grey2 ""
  -- , ppUrgent = xmobarColor orange "" . clickable wsIconFull
  , ppOrder = \(ws : _ : _ : extras) -> ws : extras
  , ppExtras  = [ layoutColorActive s (logLayoutOnScreen s)
                ,  titleColorIsActive s (shortenL 90 $ logTitleOnScreen s)
                ]
  }
  where
    titleColorIsActive n l = do
      c <- withWindowSet $ return . W.screen . W.current
      if n == c then xmobarColorL cyan "" l else xmobarColorL grey3 "" l
    layoutColorIsActive n l = do
      c <- withWindowSet $ return . W.screen . W.current
      if n == c then wrapL "<icon=" "_selected.xpm/>" l else wrapL "<icon=" ".xpm/>" l
    layoutColorActive n l = do
      c <- withWindowSet $ return . W.screen . W.current
      if n == c then xmobarColorL orange "" l else xmobarColorL grey3 "" l     
                          
-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
  n <- countScreens
  -- xmobarPipes <- mapM (\i -> spawnPipe ("xmobar -x " ++ show i ++ " ~/.config/xmobar/xmobar.config." ++ show i)) [0..n-1]
  xmonad $ ewmh $ ewmhFullscreen $ dynamicSBs myStatusBarSpawner $ docks $ defaults n

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults screens = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = withScreens screens myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        startupHook        = myStartupHook,
        logHook            = myLogHook
    } `additionalKeysP` myAdditionalKeys

