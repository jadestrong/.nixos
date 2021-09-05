{ config, lib, pkgs, ... }:

{
  environment.shellAliases = {
    ll = "exa -l -g --icons";
    lla = "ll -a";
  };
}
