{ inputs, ... }:

{
  imports = [ inputs.core.nixosModules.virtualisation ];
}
