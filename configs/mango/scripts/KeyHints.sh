#!/usr/bin/env bash
# /* ---- Custom Keybinds Cheat Sheet using FZF ---- */

# Define shortcuts array
shortcuts=(
  "App Launchers :: SUPER + Return :: Open Terminal :: kitty"
  "App Launchers :: SUPER + B :: Launch Browser :: firefox"
  "App Launchers :: SUPER + E :: File Manager (Yazi) :: kitty -e yazi"
  "App Launchers :: SUPER + D :: App Launcher :: noctalia msg panel-toggle launcher"
  "App Launchers :: SUPER + V :: Clipboard Manager :: noctalia msg panel-toggle clipboard"
  "App Launchers :: SUPER + P :: Control Center / Audio :: noctalia msg panel-toggle session"
  "App Launchers :: SUPER + SHIFT + E :: Noctalia Settings :: noctalia msg settings-toggle"
  "App Launchers :: SUPER + SHIFT + N :: Notification Panel :: noctalia msg panel-toggle control-center notifications"
  "App Launchers :: SUPER + SHIFT + D :: Active Window Info :: ~/.config/mango/scripts/WindowInfo.sh"
  
  "Session Control :: CTRL + ALT + L :: Lock Screen :: noctalia msg session lock"
  "Session Control :: CTRL + ALT + Delete :: Exit MangoWM Session :: mmsg dispatch quit"
  
  "Window Management :: SUPER + Q :: Close Window :: mmsg dispatch killclient"
  "Window Management :: ALT + F4 :: Force Kill Window (script) :: ~/.config/mango/scripts/AltF4.sh"
  "Window Management :: SUPER + SHIFT + Q :: Force Close Window :: mmsg dispatch killclient"
  "Window Management :: SUPER + F :: Toggle Fullscreen :: mmsg dispatch togglefullscreen"
  "Window Management :: SUPER + M :: Toggle Maximized :: mmsg dispatch togglemaximizescreen"
  "Window Management :: SUPER + Space :: Toggle Float :: mmsg dispatch togglefloating"
  "Window Management :: SUPER + O :: Toggle Overlay (Pin/Sticky) :: mmsg dispatch toggleoverlay"
  
  "Layout Scroller :: ALT + E :: Set Proportion to 1.0 :: mmsg dispatch set_proportion,1.0"
  "Layout Scroller :: ALT + X :: Switch Proportion Preset :: mmsg dispatch switch_proportion_preset"
  
  "Navigation :: SUPER + Arrow Keys :: Move Focus (Directional) :: mmsg dispatch focusdir [left|right|up|down]"
  "Navigation :: SUPER + SHIFT + Arrow Keys :: Swap Window Position :: mmsg dispatch exchange_client [left|right|up|down]"
  "Navigation :: CTRL + ALT + Arrow Keys :: Resize Window :: mmsg dispatch resizewin [x,y]"
  "Navigation :: SUPER + [0-9] :: Switch to Tag [1-10] :: mmsg dispatch view [1-10]"
  "Navigation :: SUPER + SHIFT + [0-9] :: Move Window to Tag [1-10] :: mmsg dispatch tag [1-10]"
  "Navigation :: SUPER + TAB :: Next Tag :: mmsg dispatch viewtoright"
  "Navigation :: SUPER + SHIFT + TAB :: Previous Tag :: mmsg dispatch viewtoleft"
  "Navigation :: ALT + TAB :: Toggle Overview :: mmsg dispatch toggleoverview"
  "Navigation :: SUPER + Mouse Scroll :: Next/Prev Tag :: axis scroll"
  
  "Noctalia Features :: SUPER + N :: Toggle Night Light :: noctalia msg nightlight-toggle"
  "Noctalia Features :: SUPER + Y :: Toggle Caffeine (No Sleep) :: noctalia msg caffeine-toggle"
  "Noctalia Features :: SUPER + W :: Random Wallpaper :: noctalia msg wallpaper-random"
  "Noctalia Features :: SUPER + SHIFT + T :: Toggle Dark/Light Theme :: noctalia msg theme-mode-toggle"
  "Noctalia Features :: SUPER + SHIFT + B :: Toggle Screen Blur :: ~/.config/mango/scripts/ToggleBlur.sh"
  "Noctalia Features :: SUPER + SHIFT + G :: Toggle Gamemode :: ~/.config/mango/scripts/ToggleGamemode.sh"
  
  "Scratchpads :: ALT + Z :: Toggle Scratchpad :: mmsg dispatch toggle_scratchpad"
  
  "Media & Hardware :: SUPER + Print :: Screenshot Fullscreen :: noctalia msg screenshot-fullscreen"
  "Media & Hardware :: SUPER + SHIFT + Print :: Screenshot Region :: noctalia msg screenshot-region"
  "Media & Hardware :: ALT + Print :: Screenshot Active Window :: noctalia msg screenshot-fullscreen pick"
  "Media & Hardware :: Volume/Brightness Keys :: Volume/Brightness controls :: noctalia volume/brightness"
  "Media & Hardware :: Play/Pause/Next/Prev :: Media controls :: noctalia msg media toggle/next/prev"
  "Media & Hardware :: SUPER + F2 :: Toggle Microphone Mute :: noctalia msg mic-mute"
  
  "Help Cheatsheets :: SUPER + H :: Show MangoWM Cheat Sheet :: KeyHints.sh"
  "Help Cheatsheets :: SUPER + SHIFT + H :: Show Zsh/Nix Cheat Sheet :: AliasHints.sh"
)

# Pipe array through column formatting and into FZF
selected=$(printf "%s\n" "${shortcuts[@]}" | column -t -s '::' | \
  fzf --header=" [ ENTER: Copiar comando para o clipboard | ESC: Sair ]" \
      --layout=reverse \
      --border=rounded \
      --prompt="🔍 Pesquisar atalho: ")

if [[ -n "$selected" ]]; then
  selected_trimmed=$(echo "$selected" | xargs)
  
  for item in "${shortcuts[@]}"; do
    item_formatted=$(echo "$item" | sed 's/ :: /   /g' | xargs)
    if [[ "$selected_trimmed" == "$item_formatted"* ]]; then
      action=$(echo "$item" | awk -F ' :: ' '{print $4}')
      if [[ -n "$action" ]]; then
        echo -n "$action" | wl-copy
        notify-send "Atalho Copiado" "Comando '$action' copiado para o clipboard!" -t 2000 -i edit-copy
      fi
      break
    fi
  done
fi
