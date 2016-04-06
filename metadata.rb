# Encoding: UTF-8

name 'box-sync'
maintainer 'Jonathan Hartman'
maintainer_email 'j@p4nt5.com'
license 'apache2'
description 'Installs the Box Sync app'
long_description 'Installs the Box Sync app'
version '1.0.1'

source_url 'https://github.com/roboticcheese/box-sync-chef'
issues_url 'https://github.com/roboticcheese/box-sync-chef/issues'

supports 'mac_os_x'
supports 'windows'

depends 'dmg', '~> 2.2'
depends 'windows', '~> 1.37'
