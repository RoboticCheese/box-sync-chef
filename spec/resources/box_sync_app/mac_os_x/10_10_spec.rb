require_relative '../../../spec_helper'

describe 'resource_box_sync_app::mac_os_x::10_10' do
  let(:action) { nil }
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: 'box_sync_app',
      platform: 'mac_os_x',
      version: '10.10'
    )
  end
  let(:converge) { runner.converge("box_sync_app_test::#{action}") }

  context 'the default action (:install)' do
    let(:action) { :default }
    cached(:chef_run) { converge }

    it 'installs the Box Sync app' do
      expect(chef_run).to install_box_sync_app('default')
    end

    it 'installs the Box Sync .dmg package' do
      expect(chef_run).to install_dmg_package('Box Sync').with(
        source: Chef::Resource::BoxSyncAppMacOsX::URL,
        volumes_dir: 'Box Sync Installer'
      )
    end
  end

  context 'the :remove action' do
    let(:action) { :remove }
    cached(:chef_run) { converge }

    it 'removes the Box Sync app' do
      expect(chef_run).to remove_box_sync_app('default')
    end

    it 'deletes the main app dir' do
      d = '/Applications/Box Sync.app'
      expect(chef_run).to delete_directory(d).with(recursive: true)
    end

    it 'deletes the application support dir' do
      d = File.expand_path('~/Library/Application Support/Box/Box Sync')
      expect(chef_run).to delete_directory(d).with(recursive: true)
    end

    it 'deletes the log dir' do
      d = File.expand_path('~/Library/Logs/Box/Box Sync')
      expect(chef_run).to delete_directory(d).with(recursive: true)
    end
  end
end
