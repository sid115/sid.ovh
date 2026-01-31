{
  inputs,
  outputs,
  ...
}:

{
  imports = [
    inputs.core.nixosModules.openssh

    outputs.nixosModules.tailscale

    ./headscale.nix
    # ./mailserver.nix
    ./matrix-synapse.nix
    ./netdata.nix
    ./nginx.nix
  ];
}
