# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_box_sync_app_mac_os_x'

describe Chef::Provider::BoxSyncApp::MacOsX do
  let(:name) { 'default' }
  let(:new_resource) { Chef::Resource::BoxSyncApp.new(name, nil) }
  let(:provider) { described_class.new(new_resource, nil) }

  describe '#install!' do
    it 'preps and runs the installer' do
      p = provider
      expect(p).to receive(:set_up_installer)
      expect(p).to receive(:run_installer)
      p.send(:install!)
    end
  end

  describe '#remove!' do
    it 'deletes the app, support, and log directories' do
      dirs = ['/Applications/Box Sync.app',
              File.expand_path('~/Library/Application Support/Box/Box Sync'),
              File.expand_path('~/Library/Logs/Box/Box Sync')]
      p = provider
      dirs.each do |d|
        expect(p).to receive(:directory).with(d).and_yield
        expect(p).to receive(:recursive).with(true)
        expect(p).to receive(:action).with(:delete)
      end
      p.send(:remove!)
    end
  end

  describe '#run_installer' do
    it 'uses an execute resource to run the installer' do
      p = provider
      expect(p).to receive(:execute).with('install Box Sync').and_yield
      expect(p).to receive(:command).with(Chef::Config[:file_cache_path] <<
                                          '/Box\ Sync\ Installer.app' \
                                          '/Contents/MacOS/Box\ Sync')
      expect(p).to receive(:creates).with(described_class::PATH)
      expect(p).to receive(:action).with(:run)
      p.send(:run_installer)
    end
  end

  describe '#set_up_installer' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:chase_redirect)
        .with(described_class::URL).and_return('http://example.com/box.dmg')
    end

    it 'uses a dmg_package resource to prep the installer' do
      p = provider
      expect(p).to receive(:dmg_package).with('Box Sync').and_yield
      expect(p).to receive(:source).with('http://example.com/box.dmg')
      expect(p).to receive(:volumes_dir).with('Box Sync Installer')
      expect(p).to receive(:destination).with(Chef::Config[:file_cache_path])
      expect(p).to receive(:action).with(:install)
      expect(p).to receive(:not_if).and_yield
      expect(File).to receive(:exist?).with(described_class::PATH)
      p.send(:set_up_installer)
    end
  end
end
