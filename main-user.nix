{ lib, config, pkgs, ... }:

{
    options = {
    };

    config = {
        users.users.idan = {
            isNormalUser = true;
            description = "idan reed";
            extraGroups = [ "networkmanager" "wheel" "docker" ];
            initialPassword = "password";
        };
    };
}