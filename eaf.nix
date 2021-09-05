{ melpaBuild
, fetchFromGitHub
, writeText
, pkgs

# Elisp dependencies
, ctable
, deferred
, epc
, s

# Native dependencies
, nodejs
, python3
, wmctrl
, xdotool
}:

let
  # TODO: Package nodejs environment

  pythonEnv = ((python3.withPackages(ps: [
    ps.pyqtwebengine
    ps.pyqt5
    ps.qrcode
    ps.qtconsole
    ps.retry
    ps.pymupdf
    # Wrap native dependencies in python env $PATH
    pkgs.aria2
  ])).override { ignoreCollisions = true; });

  node = "${nodejs}/bin/node";

  pname = "eaf";
  version = "20210309.0";

in melpaBuild {

  inherit pname version;

  src = fetchFromGitHub {
    owner = "manateelazycat";
    repo = "emacs-application-framework";
    rev = "c8a2316b4864998ed9c88cea636aadd3bf348f4e";
    sha256 = "1h3wcm34b9y4ha2wswlq2mq3a906q1bap85xh8f0b46dl2rzg9vz";
  };

  dontConfigure = true;
  dontBuild = true;

  postPatch = ''
    substituteInPlace eaf.el \
      --replace '"xdotool' '"${xdotool}/bin/xdotool' \
      --replace '"wmctrl' '"${wmctrl}'
    sed -i s#'defcustom eaf-python-command .*'#'defcustom eaf-python-command "${pythonEnv.interpreter}"'# eaf.el
    substituteInPlace app/terminal/buffer.py --replace \
      '"node"' \
      '"${node}"'
    substituteInPlace app/markdown-previewer/buffer.py --replace \
      '"node"' \
      '"${node}"'
  '';

  installPhase = ''
    rm -r screenshot
    mkdir -p $out/share/emacs/site-lisp/elpa/emacs-$pname-$version
    cp -rv * $out/share/emacs/site-lisp/elpa/emacs-$pname-$version/
  '';

  recipe = writeText "recipe" ''
    (eaf
    :repo "manateelazycat/emacs-application-framework"
    :fetcher github
    :files ("*")
  '';

  packageRequires = [
    ctable
    deferred
    epc
    s
  ];

}
