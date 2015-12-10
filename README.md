Box Sync Cookbook
=================
[![Cookbook Version](https://img.shields.io/cookbook/v/box-sync.svg)][cookbook]
[![OS X Build Status](https://img.shields.io/travis/RoboticCheese/box-sync-chef.svg)][travis]
[![Windows Build Status](https://img.shields.io/appveyor/ci/RoboticCheese/box-sync-chef.svg)][appveyor]
[![Code Climate](https://img.shields.io/codeclimate/github/RoboticCheese/box-sync-chef.svg)][codeclimate]
[![Coverage Status](https://img.shields.io/coveralls/RoboticCheese/box-sync-chef.svg)][coveralls]

[cookbook]: https://supermarket.chef.io/cookbooks/box-sync
[travis]: https://travis-ci.org/RoboticCheese/box-sync-chef
[appveyor]: https://ci.appveyor.com/project/RoboticCheese/box-sync-chef
[codeclimate]: https://codeclimate.com/github/RoboticCheese/box-sync-chef
[coveralls]: https://coveralls.io/r/RoboticCheese/box-sync-chef

A Chef cookbook for Box Sync.

Requirements
============

As of v1.0.0, this cookbook requires Chef 12.5+, or Chef 12.1+ if the
[compat_resource](https://supermarket.chef.io/cookbooks/compat_resource)
cookbook is used.

This cookbook currently supports OS X and Windows.

Usage
=====

Either add the default recipe to your run_list or implement the resources
directly in a recipe of your own.

The cookbook will complete the initial install, but Box Sync will still prompt
you for a password in OS X the first time it's started.

Recipes
=======

***default***

Installs Box Sync.

Resources
=========

***box_sync_app***

Used to install or remove the Box Sync app.

Syntax:

    box_sync_app 'default' do
        action :install
    end

Actions:

| Action     | Description       |
|------------|-------------------|
| `:install` | Install the app   |
| `:remove`  | Uninstall the app |

Attributes:

| Attribute  | Default        | Description          |
|------------|----------------|----------------------|
| action     | `:install`     | Action(s) to perform |

***box_sync_app_mac_os_x***

An OS X implementation of the `box_sync_app` resource.

***box_sync_app_windows***

A Windows implementation of the `box_sync_app` resource.

Contributing
============

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add tests for the new feature; ensure they pass (`rake`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

License & Authors
=================
- Author: Jonathan Hartman <j@p4nt5.com>

Copyright 2015 Jonathan Hartman

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
