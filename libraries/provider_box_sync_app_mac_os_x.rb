# Encoding: UTF-8
#
# Cookbook Name:: spotify
# Library:: provider_spotify_app_mac_os_x
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

require 'chef/provider/lwrp_base'
require_relative 'provider_box_sync_app'

class Chef
  class Provider
    class BoxSyncApp < Provider::LWRPBase
      # An provider for managing the Box Sync on OS X.
      #
      # @author Jonathan Hartman <j@p4nt5.com>
      class MacOsX < BoxSyncApp
        URL ||= 'http://box.com/sync4mac'
        PATH ||= '/Applications/Box Sync.app'

        private

        #
        # Install the Box Sync .dmg package.
        #
        # (see BoxSyncApp#install!)
        #
        def install!
          s = chase_redirect(URL)
          dmg_package 'Box Sync' do
            source s
            volumes_dir 'Box Sync Installer'
            action :install
            not_if { ::File.exist?(PATH) }
          end
        end

        #
        # (see BoxSyncApp#remove!)
        #
        def remove!
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
end
