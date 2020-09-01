# ControlPlugin

Le greffon de contrôle _ControlPlugin_ est un greffon pour _Foreman_ permettant l'actualisation de l'environnement _Puppet_ de production à l'aide de _R10k_.

## Installation

L'installation se fait en tant qu'utilisateur `root` à l'aide du script `build_install.sh`:

1. Copier le répertoire `control_plugin` et son contenu dans un répertoire temporaire du serveur _Puppet_ hébergeant _Foreman_

```bash
rsync -avzr --delete ./control_plugin/ root@puppetmaster:/tmp/control_plugin
```

2. Configurer _Foreman_ pour qu'il utilise le greffon en ajoutant la ligne suivante au fichier `/usr/share/foreman/bundler.d/Gemfile.local.rb`

```ruby
gem 'control_plugin'
```

3. Sur le serveur _Puppet_, exécuter le script `build_install.sh` en tant qu'utilisateur `root`:

```bash
cd /tmp/control_plugin
./build_install.sh
```

 Pour une prise en compte immédiate du greffon le script `build_install` redémarre automatiquement les services `httpd` et `foreman-proxy.service`.

Pour pouvoir utiliser correctement le greffon:
- L'utilisateur système `foreman` doit avoir pouvoir escalader ses privilèges avec `sudo` afin d'éxécuter la commande `/usr/local/bin/r10k deploy environment production` en tant que _super utilisateur_ (`man 8 sudo` et `man 8 visudo` pour la configuration de l'escalade de privilèges).
- _SELinux_ doit être positionné à `permissive` afin de ne pas empêcher l'escalade des privilèges de l'utilisateur `foreman`

## Utilisation

L'utilisation du greffon _ControlPlugin_ se fait à l'aide de l'interface _Web_ de _Foreman_.

1. Se connecter sur le serveur hébergeant _Foreman_ avec un utilisateur ayant les permissions nécessaires (`Organization admin`)
2. Dans le menu `Administrer`, cliquer sur `Actualiser environnement`
3. Cliquer sur le bouton `Déployer` qui s'est affiché sur la page

Une fois le déploiement terminé un panneau d'information affichera l'état du déploiement.

En cas d'erreur le fichier de journalisation `/var/log/foreman/production.log` permettra de retrouver les éléments facilitant le déverminage de la situation.

## Copyright

Copyright (c) **2020** **Michaël Costa / MCO System / https://www.mcos.nc**

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

