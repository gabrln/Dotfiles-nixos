{ config, pkgs, lib, inputs, ... }:
let
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
  imports = [ inputs.nvf.homeManagerModules.default ];

  programs.nvf = {
    enable = true;

    settings = {
      vim = {
        viAlias = true;
        vimAlias = true;

        options = {
          number = true;
          relativenumber = true;
          termguicolors = true;
          signcolumn = "yes";
          cursorline = true;
          scrolloff = 8;
          sidescrolloff = 8;
          wrap = false;
          tabstop = 2;
          shiftwidth = 2;
          expandtab = true;
          smartindent = true;
          ignorecase = true;
          smartcase = true;
          splitright = true;
          splitbelow = true;
          undofile = true;
          swapfile = false;
          backup = false;
          clipboard = "unnamedplus";
          completeopt = "menu,menuone,noselect";
        };

        globals = {
          mapleader = " ";
          maplocalleader = "\\";
        };

        lsp = {
          enable = true;
          servers = {
            nil_ls.enable = true;
            bashls.enable = true;
            lua_ls.enable = true;
          };
        };

        languages = {
          enableFormat = true;
          enableTreesitter = true;
          nix.enable = true;
          bash.enable = true;
          lua.enable = true;
        };

        git = {
          enable = true;
          gitsigns.enable = true;
        };

        ui = {
          noice.enable = true;
          colorizer.enable = true;
        };

        statusline.lualine.enable = true;

        treesitter.enable = true;

        telescope.enable = true;

        utility.motion.flash-nvim.enable = true;

        binds = {
          whichKey.enable = true;
          cheatsheet.enable = true;
        };

        autopairs.nvim-autopairs.enable = true;

        comments.comment-nvim.enable = true;

        filetree.neo-tree.enable = true;

        tabline.nvimBufferline.enable = true;

        extraPlugins = {
          base16-nvim = {
            package = base16-nvim;
          };
          oil = {
            package = pkgs.vimPlugins.oil-nvim;
            setup = "require('oil').setup{}";
          };
          neogen = {
            package = pkgs.vimPlugins.neogen;
            setup = "require('neogen').setup{}";
          };
          todo-comments = {
            package = pkgs.vimPlugins.todo-comments-nvim;
            setup = "require('todo-comments').setup{}";
          };
          which-key = {
            package = pkgs.vimPlugins.which-key-nvim;
            setup = "require('which-key').setup{}";
          };
        };

        keymaps = [
          {
            key = "<leader>e";
            mode = "n";
            silent = true;
            action = "<cmd>Oil<CR>";
            desc = "Open Oil file explorer";
          }
          {
            key = "<leader>ff";
            mode = "n";
            silent = true;
            action = "<cmd>Telescope find_files<CR>";
            desc = "Find files";
          }
          {
            key = "<leader>fg";
            mode = "n";
            silent = true;
            action = "<cmd>Telescope live_grep<CR>";
            desc = "Live grep";
          }
          {
            key = "<leader>fb";
            mode = "n";
            silent = true;
            action = "<cmd>Telescope buffers<CR>";
            desc = "Find buffers";
          }
          {
            key = "<leader>fh";
            mode = "n";
            silent = true;
            action = "<cmd>Telescope help_tags<CR>";
            desc = "Help tags";
          }
        ];

        autocmds = [
          {
            event = [ "TextYankPost" ];
            callback = lib.generators.mkLuaInline "function() vim.highlight.on_yank() end";
          }
        ];

        additionalRuntimePaths = [
          "${config.home.homeDirectory}/.config/nvim"
        ];

        luaConfigRC = {
          matugen-setup = ''
            local function safe_require(name)
              local ok, module = pcall(require, name)
              return ok and module or nil
            end

            local matugen = safe_require('matugen')
            if matugen then
              matugen.setup()
            end

            local signal = vim.uv.new_signal()
            signal:start('sigusr1', vim.schedule_wrap(function()
              package.loaded['matugen'] = nil
              require('matugen').setup()
            end))
          '';
        };
      };
    };
  };

  programs.neovim.enable = false;
}
