#!/bin/bash
# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
BUILD_DIR=/tmp/control_plugin

# ------------------------------------------------------------------------------
# Fonctions
# ------------------------------------------------------------------------------

function on_error {
  echo -e "\033[91m[!] $@\033[0m"
  exit 1
}

function notify {
  echo -e "\033[96m[+] $@\033[0m"
}

function on_warning {
  echo -e "\033[93m[?] $@\033[0m"
}

function item {
  echo -e "\033[95m '-> $@\033[0m"
}

# ------------------------------------------------------------------------------
# Main
# ------------------------------------------------------------------------------
if [ ! $(id -u) -eq 0 ]; then
  on_error "Vous devez être super utilisateur pour éxécuter ce script"
fi
notify "Arrêt du service"
sudo systemctl stop httpd
sudo systemctl stop foreman-proxy.service
notify "Désinstallation du greffon"
scl enable tfm "gem uninstall --ignore-dependencies control_plugin"
notify "Construction du greffon"
gem build ${BUILD_DIR}/control_plugin.gemspec
notify "Installation du greffon"
scl enable tfm "gem install --ignore-dependencies ${BUILD_DIR}/control_plugin-1.0.0.gem"
notify "Démarrage du service"
sudo systemctl start foreman-proxy.service
sudo systemctl start httpd