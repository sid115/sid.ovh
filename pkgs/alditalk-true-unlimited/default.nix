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

  npmDepsHash = "sha256-7X9K4s+uYx2nS4zXPwhRM9CztwNpzNk43wO/b2rQnE0=";

  nativeBuildInputs = [ makeWrapper ];

  npmFlags = [ "--ignore-scripts" ];
  PUPPETEER_SKIP_CHROMIUM_DOWNLOAD = "1";
  ULIXEE_SKIP_DOWNLOAD = "1";

  npmBuildScript = "build";

  preBuild = ''
    sed -i 's/const page = await browser.newPage();/const page = await browser.newPage(); await page.setUserAgent(process.env.USER_AGENT || "Mozilla\/5.0 (X11; Linux x86_64) AppleWebKit\/537.36 (KHTML, like Gecko) Chrome\/120.0.0.0 Safari\/537.36");/' src/index.ts
    sed -i 's/SHORT_WAIT: 5/SHORT_WAIT: 10/g' src/index.ts
  '';

  postInstall = ''
    makeWrapper ${nodejs}/bin/node $out/bin/alditalk-extender \
      --add-flags "$out/lib/node_modules/AldiTalkExtender/dist/index.js" \
      --set PUPPETEER_EXECUTABLE_PATH "${chromium}/bin/chromium" \
      --set CHROME_PATH "${chromium}/bin/chromium" \
      --set USER_AGENT "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
  '';

  meta = {
    description = "Automatically book AldiTalk 1GB data packages to bypass throttling";
    homepage = "https://github.com/gommzystudio/AldiTalk-True-Unlimited";
    mainProgram = "alditalk-extender";
    platforms = lib.platforms.linux;
  };
})
