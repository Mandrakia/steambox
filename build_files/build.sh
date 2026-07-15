#!/bin/bash
# Steambox build — exécuté DANS le build de l'image (voir Containerfile).
set -ouex pipefail

# Copie des fichiers système du repo vers / (SSH, udev wake, hook AV, firstboot…)
cp -avf "/ctx/system_files"/. /

### Paquets (dépôts Fedora)
# openrgb : pilotage du ruban ARGB (header ASUS) — livre aussi ses règles udev
# python3-pip : pour installer samsungtvws dans l'image
dnf5 install -y openrgb python3-pip

### CoolerControl (COPR) — courbes ventilos boîtier. Décommenter si voulu.
# dnf5 -y copr enable codifryed/CoolerControl
# dnf5 -y install coolercontrol
# dnf5 -y copr disable codifryed/CoolerControl
# systemctl enable coolercontrold.service

### API TV Samsung (Tizen WebSocket) — utilisée par le hook AV suspend/resume
pip3 install --prefix=/usr --no-cache-dir samsungtvws websocket-client requests

### Droits d'exécution des scripts embarqués
chmod 0755 /usr/libexec/steambox-av \
           /usr/libexec/steambox-firstboot \
           /usr/libexec/steambox-udp-gso-off \
           /etc/systemd/system-sleep/10-steambox-av

### Services
# sshd : accès SSH garanti dès le premier boot, quoi qu'il arrive
systemctl enable sshd.service
# firstboot : dépose la clé SSH publique dans ~/.ssh du 1er utilisateur (UID 1000)
systemctl enable steambox-firstboot.service
# workaround régression UDP-GSO kernel 7.x sur Realtek r8169/RTL8125
systemctl enable steambox-udp-gso-off.service
