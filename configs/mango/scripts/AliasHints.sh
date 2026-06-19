#!/usr/bin/env bash
# /* ---- Custom Zsh Aliases & Functions Cheat Sheet using FZF ---- */

# Define shortcuts array
shortcuts=(
  "Zsh :: c :: Clear terminal :: clear"
  "Zsh :: q :: Exit terminal :: exit"
  "Zsh :: .. :: Go up one directory :: cd .."
  "Zsh :: - :: Go to previous directory :: cd -"
  "Zsh :: ls :: Modern file listing (eza) :: eza --icons --color=always --group-directories-first"
  "Zsh :: ll :: Detailed modern list :: eza -lah --icons --color=always --group-directories-first"
  "Zsh :: lt / tree :: Display directory tree :: eza --tree --icons"
  "Zsh :: cat :: Modern file view (bat) :: bat --style=plain"
  "Zsh :: grep :: Ripgrep file search :: rg"
  "Zsh :: find :: Fast file/dir find :: fd"
  "Zsh :: y :: Open Yazi (cd on exit) :: y"
  "Zsh :: zj :: Zellij multiplexer :: zellij"
  
  "FZF :: Ctrl + R :: Fuzzy search command history :: fzf history widget"
  "FZF :: Ctrl + F :: Fuzzy search files (no hidden) :: fzf file picker"
  "FZF :: Ctrl + T :: Fuzzy search files (with hidden) :: fzf Ctrl+T picker"
  "FZF :: Alt + C :: Fuzzy search directories and auto-cd :: fzf cd widget"
  
  "Config :: conf-nixos :: Edit NixOS configuration :: nvim ~/.config/nixos/configuration.nix"
  "Config :: conf-home :: Edit Home Manager config :: nvim ~/.config/nixos/home.nix"
  "Config :: conf-zsh :: Edit Zsh config :: nvim ~/.config/zsh/.zshrc"
  "Config :: conf-zj :: Edit Zellij config :: nvim ~/.config/zellij/config.kdl"
  "Config :: rebuild :: Rebuild NixOS switch :: sudo nixos-rebuild switch --flake ~/.config/nixos#default"
  "Config :: reload-mango :: Reload MangoWM config :: mmsg dispatch reload_config"
  "Config :: reload-zsh :: Reload Zsh config :: source ~/.config/zsh/.zshrc"
  
  "System :: update :: System update :: nix flake update && sudo nixos-rebuild switch --flake ~/.config/nixos#default"
  "System :: install :: Install system package temporarily :: nix shell nixpkgs#<pkg>"
  
  "Nix :: nxi <pkg> :: Install Nix package :: nix profile install nixpkgs#<pkg>"
  "Nix :: nxu <pkg> :: Remove Nix package :: nix profile remove <pkg>"
  "Nix :: nxl :: List installed Nix packages :: nix profile list"
  "Nix :: nxs <pkg> :: Enter temp shell with package :: nix shell nixpkgs#<pkg>"
  "Nix :: nxr <pkg> :: Run package without installing :: nix run nixpkgs#<pkg>"
  "Nix :: nxsearch <pkg> :: Search Nixpkgs registry :: nix search nixpkgs <pkg>"
  "Nix :: nxd :: Develop Nix environment :: nix develop"
  
  "Git :: g :: Git wrapper :: git"
  "Git :: gst :: Git status (short format) :: git status -sb"
  "Git :: gd :: Git diff :: git diff"
  "Git :: gp :: Git push :: git push"
  "Git :: gpl :: Git pull :: git pull"
  "Git :: ga <files> :: Stage files :: git add"
  "Git :: gc '<msg>' :: Commit with message :: git commit -m"
  "Git :: gadog :: Fancy git log graph :: git log --all --decorate --oneline --graph"
)

# Pipe array through column formatting and into FZF
selected=$(printf "%s\n" "${shortcuts[@]}" | column -t -s '::' | \
  fzf --header=" [ ENTER: Copiar comando/alias para o clipboard | ESC: Sair ]" \
      --layout=reverse \
      --border=rounded \
      --prompt="🔍 Pesquisar alias: ")

if [[ -n "$selected" ]]; then
  # Parse selected line to find match and copy action
  selected_trimmed=$(echo "$selected" | xargs)
  
  for item in "${shortcuts[@]}"; do
    item_formatted=$(echo "$item" | sed 's/ :: /   /g' | xargs)
    if [[ "$selected_trimmed" == "$item_formatted"* ]]; then
      action=$(echo "$item" | awk -F ' :: ' '{print $4}')
      if [[ -n "$action" ]]; then
        echo -n "$action" | wl-copy
        notify-send "Alias Copiado" "Comando '$action' copiado para o clipboard!" -t 2000 -i edit-copy
      fi
      break
    fi
  done
fi
