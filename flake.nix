{
  description = "typstarLatexCompat nix flake for development";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem =
        { system, ... }:
        let
          pkgs = import nixpkgs { inherit system; };
          typstarLatexCompat = pkgs.vimUtils.buildVimPlugin {
            name = "typstarLatexCompat";
            src = self;
            buildInputs = with pkgs.vimPlugins; [
              nvim-treesitter-parsers.latex
              luasnip
            ];
          };
        in
        {
          packages = {
            default = typstarLatexCompat;
            nvim =
              let
                config = pkgs.neovimUtils.makeNeovimConfig {
                  customRC = ''
                    lua << EOF
                    print("Welcome to TypstarLatexCompat! This is just a demo.")

                    vim.g.mapleader = " "

                    require('nvim-treesitter.configs').setup {
                      highlight = {
                          enable = true,
                          disable = {"latex"}
                      },
                    }

                    local ls = require('luasnip')
                    ls.config.set_config({
                      enable_autosnippets = true,
                      store_selection_keys = "<Tab>",
                    })

                    local typstarLatexCompat = require('typstarLatexCompat')
                    typstarLatexCompat.setup({})

                    vim.keymap.set({'n', 'i'}, '<M-t>', '<Cmd>TypstarLatexCompatToggleSnippets<CR>', { silent = true, noremap = true })
                    vim.keymap.set({'s', 'i'}, '<M-j>', '<Cmd>TypstarLatexCompatSmartJump<CR>', { silent = true, noremap = true })
                    vim.keymap.set({'s', 'i'}, '<M-k>', '<Cmd>TypstarLatexCompatSmartJumpBack<CR>', { silent = true, noremap = true })

                    vim.keymap.set('n', '<leader>e', '<Cmd>TypstarLatexCompatInsertExcalidraw<CR>', { silent = true, noremap = true })
                    vim.keymap.set('n', '<leader>r', '<Cmd>TypstarLatexCompatInsertRnote<CR>', { silent = true, noremap = true })
                    vim.keymap.set('n', '<leader>o', '<Cmd>TypstarLatexCompatOpenDrawing<CR>', { silent = true, noremap = true })

                    EOF
                  '';
                  plugins =
                    with pkgs.vimPlugins;
                    [
                      vimtex
                      luasnip
                      nvim-treesitter
                      nvim-treesitter-parsers.latex
                    ]
                    ++ [
                      typstarLatexCompat
                    ];
                };
              in
              pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped config;
          };
        };
    };
}
