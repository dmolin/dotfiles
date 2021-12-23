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

import XMonad (MonadIO, WorkspaceId, Layout, Window, ScreenId, ScreenDetail, WindowSet, layoutHook, logHook, X, io, ScreenId(..), gets, windowset, xmonad)
import XMonad hiding ((|||), float, Screen)
import XMonad.Util.SpawnOnce
import XMonad.Util.Run
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat, doCenterFloat, doRectFloat, isDialog)
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.WorkspaceHistory (workspaceHistoryHook)
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Grid
import XMonad.Layout.ResizableTile
import XMonad.Layout.NoBorders
-- spacing between tiles
import XMonad.Layout.Spacing
import Data.Monoid
import System.Exit
-- import XMonad.Layout.MultiToggle
-- import XMonad.Layout.MultiToggle.Instances
import XMonad.Hooks.SetWMName
import XMonad.Actions.CycleWS
import XMonad.Actions.UpdatePointer (updatePointer)
import XMonad.Layout.IndependentScreens (countScreens)
import XMonad.Layout.LayoutCombinators
import XMonad.Util.WorkspaceCompare (getSortByXineramaRule)
import XMonad.Util.NamedScratchpad

import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))
import qualified XMonad.StackSet as W
import XMonad.StackSet (current, screen, visible, Screen, workspace, tag, sink, float, floating, RationalRect) 
import qualified Data.Map        as M

import XMonad.Hooks.FullscreenSupported (setFullscreenSupported)

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "alacritty"
color06         = "#ffffff"

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
    (customFloating $ W.RationalRect (3/5) (4/6) (1/5) (1/6))
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

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_z     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm .|. shiftMask, xK_m     ), spawn "xmonad --recompile; xmonad --restart")

    -- Run xmessage with a summary of the default keybindings (useful for beginners)
    , ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
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

    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_F11, xK_F10, xK_F12] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
 
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
    , name =? "win0" --> doCenterFloat
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
myEventHook = mempty

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

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Color of current window title in xmobar.
xmobarTitleColor = "#FFB6B0"
-- Color of current workspace in xmobar.
xmobarCurrentWorkspaceColor = "#CEFFAC"

myPP = def {
    ppCurrent = xmobarColor color06 "" . wrap ("<box type=Bottom width=2 mb=2 color=" ++ xmobarTitleColor ++ ">") "</box>"
  , ppTitle = xmobarColor xmobarTitleColor "" . shorten 50
  , ppSep = "   "
  -- , ppSort    = getSortByXineramaRule
  }

-- this all section is actually not used
type ScreenFoo = Screen WorkspaceId (Layout Window) Window ScreenId ScreenDetail

visibleScreens :: WindowSet -> [ScreenFoo]
visibleScreens cws = ([current cws]) ++ (visible cws)

joinToString :: [String] -> String
joinToString workspaceIds = foldl (++) "" workspaceIds

spawnXMobar :: MonadIO m => Int -> m (Int, Handle)
spawnXMobar i = (spawnPipe $ "xmobar" ++ " -x " ++ show i ++ " ~/.config/xmobar/xmobar.config." ++ show i) >>= (\handle -> return (i, handle))

spawnXMobars :: MonadIO m => Int -> m [(Int, Handle)]
spawnXMobars n = mapM spawnXMobar [0..n-1]

-- This shows only the ws on the current screen but it loses the advantage of dynamicLogWithPP (that is, showing the other workspaces and the current running app)
myLogHookForPipe :: WindowSet -> (Int, Handle) -> X ()
myLogHookForPipe currentWindowSet (i, xmobarPipe) =
  io $ hPutStrLn xmobarPipe $
  joinToString $ map (tag . workspace) $
  filter ((==) (S i) . screen) $
  visibleScreens currentWindowSet
-- end of unused section

mySimpleLogHookForPipe :: Handle -> X ()
mySimpleLogHookForPipe xmobarPipe =
  dynamicLogWithPP myPP { ppOutput = hPutStrLn xmobarPipe } 

myLogHook :: [Handle] -> X ()
myLogHook xmobarPipes = do
  workspaceHistoryHook
  fadeInactiveCurrentWSLogHook 0.8
  updatePointer (0.5, 0.5) (0, 0)
  mapM_ mySimpleLogHookForPipe xmobarPipes

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
  n <- countScreens
  xmobarPipes <- mapM (\i -> spawnPipe ("xmobar -x " ++ show i ++ " ~/.config/xmobar/xmobar.config." ++ show i)) [0..n-1]
  --xmonad $ ewmhFullscreen $ ewmh (docks defaults {
        --logHook = workspaceHistoryHook >> myLogHook xmobarPipes
  --})
  xmonad $ ewmhFullscreen $ ewmh $ docks $ defaults xmobarPipes

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults xmobadPipes = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
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
        logHook            = myLogHook xmobadPipes
    }

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The default modifier key is 'alt'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch xterminal",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]
