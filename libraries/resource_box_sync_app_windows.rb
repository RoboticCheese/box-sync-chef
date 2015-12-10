# Encoding: UTF-8
#
# Cookbook Name:: box-sync
# Library:: resource_box_sync_app_windows
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
    # A Windows implementation of the box_sync_app resource.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class BoxSyncAppWindows < BoxSyncApp
      URL ||= 'https://e3.boxcdn.net/box-installers/sync/Sync+4+External/' \
              'BoxSyncSetup.exe'
      PATH ||= ::File.expand_path('/Program Files/Box/Box Sync')

      include ::Windows::Helper

      provides :box_sync_app, platform_family: 'windows'

      #
      # Use a windows_package resource to install Box Sync.
      #
      action :install do
        windows_package 'Box Sync' do
          source URL
          installer_type :nsis
          action :install
        end
      end

      #
      # Use an execute resource to remove the package. Use execute instead
      # of windows_package because the windows_package provider doesn't
      # parse the uninstall_string correctly.
      #
      action :remove do
        execute 'Remove Box Sync' do
          command(
            'start "" /wait ' \
            "#{(installed_packages['Box Sync'] || {})[:uninstall_string]} /S"
          )
          action :run
          only_if { installed_packages.include?('Box Sync') }
        end
      end
    end
  end
end
