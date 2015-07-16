# Encoding: UTF-8
#
# Cookbook Name:: box-sync
# Library:: provider_box_sync_app_windows
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
      # An provider for managing the Box Sync app on Windows.
      #
      # @author Jonathan Hartman <j@p4nt5.com>
      class Windows < BoxSyncApp
        URL ||= 'http://box.com/sync4windows'
        PATH ||= ::File.expand_path('/Program Files/Box/Box Sync')

        include ::Windows::Helper

        provides :box_sync_app, platform_family: 'windows'

        private

        #
        # Download and then install the Box Sync .exe package
        #
        # (see BoxSyncApp#install!)
        #
        def install!
          download_package
          install_package
        end

        #
        # Use an execute resource to remove the package. Use execute instead
        # of windows_package because the windows_package provider doesn't
        # parse the uninstall_string correctly.
        #
        # (see BoxSyncApp#remove!)
        #
        def remove!
          execute 'remove Box Sync' do
            command 'start "" /wait ' \
                    "#{installed_packages['Box Sync'][:uninstall_string]} /S"
            action :run
            only_if { installed_packages.include?('Box Sync') }
          end
        end

        #
        # Use a windows_package resource to install the .exe file.
        #
        def install_package
          s = download_path
          windows_package 'Box Sync' do
            source s
            installer_type :nsis
            action :install
          end
        end

        #
        # Use a remote_file resource to download the .exe file.
        #
        def download_package
          s = chase_redirect(URL)
          remote_file download_path do
            source s
            action :create
            only_if { !::File.exist?(PATH) }
          end
        end

        #
        # Construct a download destination under Chef's cache dir.
        #
        # @return [String]
        #
        def download_path
          ::File.join(Chef::Config[:file_cache_path], 'Box Sync.exe')
        end
      end
    end
  end
end
