{ inputs, config, ... }:

let
  domain = config.networking.domain;
  relay = "100.64.0.6"; # host `sid`
in
{
  imports = [ inputs.core.nixosModules.mailserver ];

  mailserver = {
    enable = true;
    subdomain = "mail";
    stateVersion = 3;
    loginAccounts = {
      "sid@${domain}" = {
        hashedPasswordFile = config.sops.secrets."mailserver/accounts/sid".path;
        aliases = [
          "postmaster@${domain}"
        ];
      };
    };
  };

  services.postfix.settings.main = {
    relayhost = [ "[${relay}]" ]; # `[]` to avoid MX lookup
    mynetworks = [
      "127.0.0.0/8"
      "[::1]/128"
      "${relay}/32"
    ];
  };
}
