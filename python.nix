{ config, lib, pkgs, ... }:

with pkgs;
let
  my-python-packages = python39Packages: with python39Packages; [
    pip
    pyqt5
    pyqtwebengine
    epc
    lxml
    # openshot-qt
    qtconsole
    sip
    qrcode
  ];
  python-with-my-packages = python39.withPackages my-python-packages;
in
python-with-my-packages
