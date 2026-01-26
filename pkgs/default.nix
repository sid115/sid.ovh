{
  pkgs ? import <nixpkgs>,
  ...
}:

{
  alditalk-true-unlimited = pkgs.callPackage ./alditalk-true-unlimited { };
}
