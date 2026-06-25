{ config, pkgs, lib, inputs, ... }:
let
  nixCats = inputs.nixCats;
  utils = nixCats.utils;

  base16-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "base16-nvim";
    version = "2024-01-01";
    src = pkgs.fetchFromGitHub {
      owner = "RRethy";
      repo = "base16-nvim";
      rev = "master";
      hash = "sha256-Dizi44p6XYaQlXEL5qnfJFX44nXKIAkZAZvQ5QH11eA=";
    };
  };
in {
  imports = [ nixCats.homeModule ];

  nixCats = {
    enable = true;
    addOverlays = [ (utils.standardPluginOverlay inputs) ];
    packageNames = [ "nvim" ];
    luaPath = ../dotfiles/nvim/nixcats;

    categoryDefinitions.replace = ({ pkgs, ... }: {
      lspsAndRuntimeDeps = {
        general = [
          pkgs.ripgrep
          pkgs.fd
        ];
        nix = [
          pkgs.nil
          pkgs.nixd
        ];
        lua = [
          pkgs.lua-language-server
        ];
        bash = [
          pkgs.bash-language-server
        ];
      };

      startupPlugins = {
        general = [
          pkgs.vimPlugins.vim-sleuth
          pkgs.vimPlugins.lazy-nvim
          pkgs.vimPlugins.nvim-web-devicons
          pkgs.vimPlugins.plenary-nvim
          pkgs.vimPlugins.tokyonight-nvim
          base16-nvim
        ];
      };

      optionalPlugins = {
        general = [
          pkgs.vimPlugins.nvim-treesitter.withAllGrammars
          pkgs.vimPlugins.nvim-lspconfig
          pkgs.vimPlugins.nvim-cmp
          pkgs.vimPlugins.cmp-nvim-lsp
          pkgs.vimPlugins.cmp-buffer
          pkgs.vimPlugins.cmp-path
          pkgs.vimPlugins.luasnip
          pkgs.vimPlugins.telescope-nvim
          pkgs.vimPlugins.telescope-fzf-native-nvim
          pkgs.vimPlugins.which-key-nvim
          pkgs.vimPlugins.gitsigns-nvim
          pkgs.vimPlugins.conform-nvim
          pkgs.vimPlugins.noice-nvim
          pkgs.vimPlugins.nui-nvim
          pkgs.vimPlugins.todo-comments-nvim
        ];
        ui = [
          pkgs.vimPlugins.lualine-nvim
          pkgs.vimPlugins.bufferline-nvim
          pkgs.vimPlugins.indent-blankline-nvim
        ];
        git = [
          pkgs.vimPlugins.lazygit-nvim
        ];
        code = [
          pkgs.vimPlugins.oil-nvim
          pkgs.vimPlugins.neogen
        ];
      };
    });

    packageDefinitions.replace = {
      nvim = { pkgs, name, ... }: {
        settings = {
          suffix-path = true;
          suffix-LD = true;
          wrapRc = false;
          configDirName = "nvim";
          aliases = [ "vim" "vi" ];
          hosts.python3.enable = true;
          hosts.node.enable = true;
        };
        categories = {
          general = true;
          nix = true;
          lua = true;
          bash = true;
          ui = true;
          git = true;
          code = true;
        };
      };
    };
  };

  programs.neovim.enable = false;

  xdg.configFile."nvim/init.lua".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.config/nixos/modules/home/dotfiles/nvim/nixcats/init.lua";

  xdg.configFile."nvim/lua".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.config/nixos/modules/home/dotfiles/nvim/nixcats/lua";
}
