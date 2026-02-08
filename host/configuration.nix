{ ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };
    supergfxd.enable = true;
  };

  hardware.asus.battery = {
    chargeUpto = 60;
    enableChargeUptoScript = true;
  };

  hardware = {
    steam-hardware.enable = true;
    uinput.enable = true;
    xpadneo.enable = true;
  };

  users.users.chumi = {
    extraGroups = [
      "input"
      "uinput"
    ];
  };
}
