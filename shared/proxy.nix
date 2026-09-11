# Single source of truth for the local proxy endpoint (mihomo mixed port).
# Imported by modules/proxy.nix (system env proxy) and
# home/gui/gnome.nix (GNOME dconf system/proxy settings), so the address
# only has to change in one place.
{
  host = "127.0.0.1";
  port = 7890;
}
