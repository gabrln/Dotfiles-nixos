{ config, pkgs, ... }:

{
  # User Packages
  home.packages = with pkgs; [
    eza
    bat
    fd
    ripgrep
    fzf
    zoxide
    starship
    neovim
    kitty
    libnotify
    jq
  ];

  # Zsh Shell Config
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history = {
      size = 100000;
      save = 100000;
      share = true;
      ignoreDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
    };
    plugins = [
      {
        name = "zsh-vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
      {
        name = "zsh-history-substring-search";
        src = pkgs.zsh-history-substring-search;
        file = "share/zsh-history-substring-search/zsh-history-substring-search.zsh";
      }
    ];
    shellAliases = {
      c = "clear";
      q = "exit";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "-" = "cd -";
      g = "git";
      gst = "git status -sb";
      gd = "git diff";
      gl = "git log --oneline -n 10";
      gp = "git push";
      gpl = "git pull";
      ga = "git add";
      gc = "git commit -m";
      glog = "PAGER=\"less -F -X\" git log";
      gadog = "PAGER=\"less -F -X\" git log --all --decorate --oneline --graph";
      zj = "zellij";
      zja = "zellij attach";
      zjl = "zellij list-sessions";
      zjda = "zellij delete-all-sessions --force";
      conf-zj = "nvim ~/.config/zellij/config.kdl";
      nxi = "nix profile install nixpkgs#";
      nxu = "nix profile remove";
      nxl = "nix profile list";
      nxs = "nix shell nixpkgs#";
      nxr = "nix run nixpkgs#";
      nxsearch = "nix search nixpkgs";
      nxd = "nix develop";
    };
    initExtra = ''
      # Source bindings and aliases
      if [ -f ~/.config/zsh/bindings.zsh ]; then
        source ~/.config/zsh/bindings.zsh
      fi
      if [ -f ~/.config/zsh/fzf.zsh ]; then
        source ~/.config/zsh/fzf.zsh
      fi
    '';
  };

  # Zoxide (Autojump)
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
