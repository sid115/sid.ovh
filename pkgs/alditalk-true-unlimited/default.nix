{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  chromium,
  nodejs,
}:
buildNpmPackage (finalAttrs: {
  pname = "alditalk-true-unlimited";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "gommzystudio";
    repo = "AldiTalk-True-Unlimited";
    rev = "d45e39ebffc5c7e2e049d1a6ef17fb28012913f1";
    hash = "sha256-y/zvNxwA4RWFJZwbEo6K32MtqLYKSRJlj7zQ+6Rc6/o=";
  };

  # 1. Update this hash. Since we are changing install flags, 
  # the 'hash' of the node_modules cache will change.
  npmDepsHash = "sha256-7X9K4s+uYx2nS4zXPwhRM9CztwNpzNk43wO/b2rQnE0=";

  nativeBuildInputs = [ makeWrapper ];

  # 2. Tell the dependency fetcher to also ignore scripts
  npmFlags = [ "--ignore-scripts" ];

  # 3. Environment variables for both fetch and build phases
  PUPPETEER_SKIP_CHROMIUM_DOWNLOAD = "1";
  ULIXEE_SKIP_DOWNLOAD = "1";

  npmBuildScript = "build";

  postInstall = ''
    makeWrapper ${nodejs}/bin/node $out/bin/alditalk-extender \
      --add-flags "$out/lib/node_modules/AldiTalkExtender/dist/index.js" \
      --set PUPPETEER_EXECUTABLE_PATH "${chromium}/bin/chromium"
  '';

  meta = {
    description = "Automatically book AldiTalk 1GB data packages to bypass throttling";
    homepage = "https://github.com/gommzystudio/AldiTalk-True-Unlimited";
    mainProgram = "alditalk-extender";
    platforms = lib.platforms.linux;
  };
})
