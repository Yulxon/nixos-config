{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_zen;
  };

  hardware = {
    graphics.enable = true;
    nvidia = {
      modesetting.enable = true;
      open = true;
      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
      };
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    steam-hardware.enable = true;
    uinput.enable = true;
    xpadneo.enable = true;
  };

  time.timeZone = "Asia/Shanghai";

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall.enable = false;
    # proxy = {
    #   default = "http://127.0.0.1:7890";
    #   noProxy = "127.0.0.1,localhost,internal.domain";
    # };
  };

  services = {
    xserver = {
      videoDrivers = [ "nvidia" ];
      xkb.layout = "us";
    };

    mihomo = {
      enable = false;
      configFile = "/home/chumi/.var/config.yaml";
    };
    dae = {
      enable = true;
      configFile = "/home/chumi/.var/network/config.dae";
    };

    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    flatpak.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    asusd = {
      enable = true;
      enableUserService = true;
    };
    supergfxd.enable = true;
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "zh_CN.UTF-8/UTF-8"
    ];
    extraLocaleSettings = {
      LC_ALL = "en_US.UTF-8";
    };
    inputMethod = {
      enable = true;
      type = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ rime ];
    };
  };

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      source-code-pro
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
    ];
    fontconfig = {
      defaultFonts = {
        sansSerif = [
          "Noto Sans"
          "Noto Sans CJK SC"
        ];
        serif = [
          "Noto Serif"
          "Noto Serif CJK SC"
        ];
        monospace = [
          "Noto Sans Mono"
          "JetBrainsMono Nerd Font"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  users.users.chumi = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "uinput"
    ];
  };

  virtualisation.podman.enable = true;

  system = {
    stateVersion = "25.05";
    autoUpgrade = {
      enable = true;
      allowReboot = true;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      git
      vim
      wget
    ];
    variables.EDITOR = "vim";
  };

  nix = {
    optimise.automatic = true;
    settings = {
      substituters = [
        "https://mirrors.cernet.edu.cn/nix-channels/store"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs.config.allowUnfree = true;
  zramSwap.enable = true;
  # programs.nix-ld.enable = true;
}
