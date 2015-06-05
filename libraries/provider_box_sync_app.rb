# Encoding: UTF-8
#
# Cookbook Name:: box-sync
# Library:: provider_box_sync_app
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
require 'net/http'
require_relative 'resource_box_sync_app'
require_relative 'provider_box_sync_app_mac_os_x'
# TODO: require_relative 'provider_box_sync_app_windows'

class Chef
  class Provider
    # A platform-agnostic parent provider for the Box Sync app.
    #
    # @author Jonathan Hartman <j@p4nt5.com>
    class BoxSyncApp < Provider::LWRPBase
      use_inline_resources

      #
      # WhyRun is supported by this provider.
      #
      # @return [TrueClass, FalseClass]
      #
      def whyrun_supported?
        true
      end

      #
      # Install the app if it's not already and set the new_resource installed
      # status to true.
      #
      action :install do
        install!
        new_resource.installed(true)
      end

      #
      # Remove the app if it's installed and set the new_resource installed
      # status to false.
      #
      action :remove do
        remove!
        new_resource.installed(false)
      end

      private

      #
      # Do the actual app installation.
      #
      # @raise [NotImplementedError] if not defined for this provider.
      #
      def install!
        fail(NotImplementedError,
             "`install!` method not implemented for #{self.class} provider")
      end

      #
      # Do the actual app removal.
      #
      # @raise [NotImplementedError] if not defined for this provider.
      #
      def remove!
        fail(NotImplementedError,
             "`remove!` method not implemented for #{self.class} provider")
      end

      #
      # Recursively follow a redirect to an eventual final URL. Box uses short
      # URLs that eventually resolve to lengthy package download URLs.
      #
      # @param [String] url
      # @return [String]
      #
      def chase_redirect(url)
        u = URI.parse(url)
        (0..9).each do
          opts = { use_ssl: u.scheme == 'https',
                   ca_file: Chef::Config[:ssl_ca_file] }
          resp = Net::HTTP.start(u.host, u.port, opts) { |h| h.head(u.to_s) }
          return u.to_s unless resp.is_a?(Net::HTTPRedirection)
          u = URI.parse(resp['location'])
        end
        nil
      end
    end
  end
end
