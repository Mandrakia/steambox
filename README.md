# steambox

Image Bazzite custom pour la console de salon (base `bazzite-deck:stable`).

Cuit dans l'image :
- **SSH activé** dès le premier boot + dépôt automatique de la clé publique
  dans le `~/.ssh/authorized_keys` du premier utilisateur (service firstboot).
- **Réveil manette** : règle udev wakeup pour les dongles USB 8BitDo (2dc8).
- **Hook AV suspend/resume** (`/usr/libexec/steambox-av`) : WoL + Tizen WebSocket
  pour la TV Samsung, API MusicCast YXC pour la Yamaha YSP-2700.
  Paramètres dans `/etc/steambox/av.env` (modifiable après install).
- **Workaround UDP-GSO** kernel 7.x sur Realtek r8169/RTL8125 (service systemd).
- **OpenRGB** (ruban ARGB) + `samsungtvws` (pip, dans /usr).

Ce dépôt est un overlay sur [ublue-os/image-template](https://github.com/ublue-os/image-template) :
les workflows GitHub Actions (`build.yml` → image ghcr.io, `build-disk.yml` → ISO
d'installation) viennent du template. Voir `~/restore/bazzite/BOOTKEY.md` pour le
mode d'emploi complet.
