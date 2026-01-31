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
    ./matrix-synapse.nix
    ./netdata.nix
    ./nginx.nix

    # ./smtp-relay.nix # FIXME
  ];
}
