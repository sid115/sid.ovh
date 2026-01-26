{
  pkgs ? import <nixpkgs>,
  ...
}:

{
  aldi-talk-true-unlimited = pkgs.callPackage ./aldi-talk-true-unlimited { };
}
