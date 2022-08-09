{ config, pkgs, lib, ... }:

{
  home.stateVersion = "22.05";
  xdg.enable = true;
  xdg.configFile."nvim/lua/base.lua".source = ./base.lua;


  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
    PAGER = "less -FirSwX";
    MANPAGER = "sh -c 'col -bx | ${pkgs.bat}/bin/bat -l man -p'";
  };

  # https://github.com/malob/nixpkgs/blob/master/home/default.nix

  # Direnv, load and unload environment variables depending on the current directory.
  # https://direnv.net
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.direnv.enable
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # Htop
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.htop.enable
  programs.htop.enable = true;
  programs.htop.settings.show_program_path = true;

  # Starship Prompt
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.starship.enable
  programs.starship.enable = true;

  programs.zoxide = {
    enable = true;
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = false;
  };

  programs.bat.enable = true;

  programs.starship.settings = {
    # See docs here: https://starship.rs/config/
    # Symbols config configured ./starship-symbols.nix.

    directory.fish_style_pwd_dir_length = 1; # turn on fish directory truncation
    directory.truncation_length = 2; # number of directories not to truncate
    gcloud.disabled = true; # annoying to always have on
    hostname.style = "bold green"; # don't like the default
    memory_usage.disabled = true; # because it includes cached memory it's reported as full a lot
    username.style_user = "bold blue"; # don't like the default
  };
  
  programs.fish = {
    enable = true;
    interactiveShellInit = lib.strings.concatStrings (lib.strings.intersperse "\n" [
      # "source ${sources.theme-bobthefish}/functions/fish_prompt.fish"
      # "source ${sources.theme-bobthefish}/functions/fish_right_prompt.fish"
      # "source ${sources.theme-bobthefish}/functions/fish_title.fish"
      # (builtins.readFile ./conf.fish)
      "set -g SHELL ${pkgs.fish}/bin/fish"
      # set -gx fish_user_paths $HOME/go/bin $HOME/.cargo/bin                           
      # "set -g theme_nerd_fonts yes"                                                       
      # "set -g theme_newline_cursor yes"                                                   
      "set -gx FZF_DEFAULT_COMMAND 'fd --type file'"                                     
      "set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND"                                 
      "set -gx FZF_ALT_C_COMMAND fd -t d . $HOME"
      "set fzf_preview_dir_cmd exa --all --color=always"
      "set -gx EDITOR nvim"
      # To deal with fish not ordering the nix paths first https://github.com/LnL7/nix-darwin/issues/122
      "fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin"
      "fzf_configure_bindings"
    ]);

    shellAliases = {
      ga = "git add";
      gc = "git commit";
      gco = "git checkout";
      gcp = "git cherry-pick";
      gdiff = "git diff";
      gl = "git prettylog";
      gp = "git push";
      gs = "git status";
      gt = "git tag";

      # Two decades of using a Mac has made this such a strong memory
      # that I'm just going to keep it consistent.
      pbcopy = "xclip";
      pbpaste = "xclip -o";

      wo = "cd ~/Developer/workspace";
      ll = "exa -l -g --icons";
      la = "${pkgs.exa}/bin/exa -a";
      lt = "${pkgs.exa}/bin/exa --tree";
      lla = "${pkgs.exa}/bin/exa -la";
    };
    plugins = [
      {
        name = "fzf-fish";
        src = pkgs.fetchFromGitHub {
          owner = "PatrickF1";
          repo = "fzf.fish";
          rev = "c8c7d9903e0327b0d76e51ba4378ec8d5ef6477e";
          sha256 = "0v653v5g3fnnlbar8ljrclf0qpn4fp4r8flqi7pfypqm0nv8zf9q";
        };
      }
    ];


  };

  programs.exa.enable = true;
  programs.jq.enable = true;
  programs.lsd.enable = true;
  programs.feh.enable = true;



  home.packages = [
    pkgs.fd
    pkgs.git-crypt
    pkgs.ripgrep
    pkgs.tree
    pkgs.watch
    pkgs.zathura

    pkgs.go
    pkgs.gopls

    pkgs.tetex
    
    pkgs.delta
    pkgs.du-dust
    pkgs.duf
    pkgs.broot
    pkgs.cheat
    pkgs.tldr
    pkgs.bottom
    pkgs.glances
    pkgs.gtop
    pkgs.gping
    pkgs.procs
    pkgs.dogdns
    # pkgs.neofetch
    pkgs.nmap
    pkgs.gcc
    pkgs.wget
    pkgs.unzip
    pkgs.luajit
    pkgs.luajitPackages.luacheck
    pkgs.luajitPackages.gitsigns-nvim
    pkgs.statix
    pkgs.nodejs
    pkgs.nerdfonts
    pkgs.diff-so-fancy
    pkgs.nodePackages.yarn
    pkgs.nodePackages.eslint
    pkgs.nodePackages.prettier
    pkgs.tree-sitter

    pkgs.fishPlugins.foreign-env
    pkgs.fishPlugins.done
  ];

  # Misc configuration files --------------------------------------------------------------------{{{

  # https://docs.haskellstack.org/en/stable/yaml_configuration/#non-project-specific-config
  # home.file.".stack/config.yaml".text = lib.generators.toYAML {} {
  #   templates = {
  #     scm-init = "git";
  #     params = {
  #       author-name = "Your Name"; # config.programs.git.userName;
  #       author-email = "youremail@example.com"; # config.programs.git.userEmail;
  #       github-username = "yourusername";
  #     };
  #   };
  #   nix.enable = true;
  # };

  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./kitty;
  };

  # home.file."/Users/chandy/.config/test.lua".source = ./base.lua;
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs; [

      vimPlugins.which-key-nvim
      vimPlugins.plenary-nvim
      vimPlugins.popup-nvim
      vimPlugins.telescope-nvim
      vimPlugins.telescope-fzf-native-nvim
      vimPlugins.telescope-file-browser-nvim
      vimPlugins.nvim-treesitter
      vimPlugins.nvim-treesitter-textobjects
      vimPlugins.nvim-treesitter-refactor
      vimPlugins.nvim-treesitter-context
      vimPlugins.playground
      vimPlugins.nvim-lspconfig
      vimPlugins.lsp-status-nvim
      vimPlugins.null-ls-nvim
      vimPlugins.trouble-nvim
      vimPlugins.nvim-cmp
      vimPlugins.cmp-nvim-lsp
      vimPlugins.cmp-buffer
      vimPlugins.cmp-path
      vimPlugins.cmp-cmdline
      vimPlugins.cmp-treesitter
      vimPlugins.cmp-spell
      vimPlugins.cmp_luasnip
      vimPlugins.luasnip
      vimPlugins.lualine-nvim
      vimPlugins.kanagawa-nvim
      vimPlugins.nvim-web-devicons
      vimPlugins.vim-startify
      vimPlugins.neoformat
    ];

    # extraConfig = (import ./vim-config.nix) { inherit sources; };
    extraConfig = ''
lua require('base')
    '';

    extraPackages = with pkgs; [
      # Language server packages (executables)
      rnix-lsp
      sumneko-lua-language-server
      nodePackages.vim-language-server
      stylua
      nixfmt
      rustfmt
    ];    
  };

  # Apps
  # `home-manager` currently has issues adding them to `~/Applications`
  # Issue: https://github.com/nix-community/home-manager/issues/1341
  home.activation = lib.mkIf pkgs.stdenv.isDarwin {
      copyApplications = let
        apps = pkgs.buildEnv {
          name = "home-manager-applications";
          paths = config.home.packages;
          pathsToLink = "/Applications";
        };
      in lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        baseDir="$HOME/Applications/Home Manager Apps"
        if [ -d "$baseDir" ]; then
          rm -rf "$baseDir"
        fi
        mkdir -p "$baseDir"
        for appFile in ${apps}/Applications/*; do
          target="$baseDir/$(basename "$appFile")"
          $DRY_RUN_CMD cp ''${VERBOSE_ARG:+-v} -fHRL "$appFile" "$baseDir"
          $DRY_RUN_CMD chmod ''${VERBOSE_ARG:+-v} -R +w "$target"
        done
      '';
  };

}
