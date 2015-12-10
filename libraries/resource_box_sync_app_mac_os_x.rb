# Encoding: UTF-8
#
# Cookbook Name:: box-sync
# Library:: resource_box_sync_app_mac_os_x
#
# Copyright 2015 Jonathan Hartman
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require_relative 'resource_box_sync_app'

class Chef
  class Resource
    # An OS X implementation of the box_sync_app resource.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class BoxSyncAppMacOsX < BoxSyncApp
      URL ||= 'https://e3.boxcdn.net/box-installers/sync/Sync+4+External/' \
              'Box%20Sync%20Installer.dmg'
      PATH ||= '/Applications/Box Sync.app'

      provides :box_sync_app, platform_family: 'mac_os_x'

      #
      # Install the Box Sync .dmg package.
      #
      action :install do
        dmg_package 'Box Sync' do
          source URL
          volumes_dir 'Box Sync Installer'
          action :install
        end
      end

      #
      # Remove Box Sync and all its supporting directories.
      #
      action :remove do
        [
          PATH,
          ::File.expand_path('~/Library/Application Support/Box/Box Sync'),
          ::File.expand_path('~/Library/Logs/Box/Box Sync')
        ].each do |d|
          directory d do
            recursive true
            action :delete
          end
        end
      end
    end
  end
end
