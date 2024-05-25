# sudo nixos-rebuild switch
# nixos-help
# sudo nixos-rebuild switch --flake /etc/nixos/#default

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./main-user.nix
    ];
    
  environment.systemPackages = with pkgs; [
    nano
    git
    firefox
    pkgs.spice
    pkgs.spice-vdagent
    pkgs.vscode
    pkgs.tailscale
  ];

  nixpkgs.config = {
	  allowUnfree = true;
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];
  programs.nix-ld.enable = true;
  services.tailscale.enable = true;

  programs.bash.shellAliases = {
    rebuild = "sudo nixos-rebuild switch";
    config = "cd /etc/nixos/";
  };

  # Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  boot.loader.grub.enableCryptodisk=true;

  boot.initrd.luks.devices."luks-3309a2a1-a2bc-4acf-a9b0-e6755cfb014e".keyFile = "/crypto_keyfile.bin";
  networking.hostName = "idanreed"; 

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone
  time.timeZone = "America/Chicago";

  # Select internationalisation properties
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };
 
  # Enable CUPS to print documents
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  
  system.stateVersion = "23.11";
}
