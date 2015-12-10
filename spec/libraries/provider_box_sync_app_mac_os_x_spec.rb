# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_box_sync_app_mac_os_x'

describe Chef::Provider::BoxSyncApp::MacOsX do
  let(:name) { 'default' }
  let(:run_context) { ChefSpec::SoloRunner.new.converge.run_context }
  let(:new_resource) { Chef::Resource::BoxSyncApp.new(name, run_context) }
  let(:provider) { described_class.new(new_resource, run_context) }

  describe '.provides?' do
    let(:platform) { nil }
    let(:node) { ChefSpec::Macros.stub_node('node.example', platform) }
    let(:res) { described_class.provides?(node, new_resource) }

    context 'Mac OS X' do
      let(:platform) { { platform: 'mac_os_x', version: '10.10' } }

      it 'returns true' do
        expect(res).to eq(true)
      end
    end
  end

  describe '#install!' do
    it 'uses a dmg_package resource to prep the installer' do
      p = provider
      expect(p).to receive(:dmg_package).with('Box Sync').and_yield
      expect(p).to receive(:source).with(described_class::URL)
      expect(p).to receive(:volumes_dir).with('Box Sync Installer')
      expect(p).to receive(:action).with(:install)
      expect(p).to receive(:not_if).and_yield
      expect(File).to receive(:exist?).with(described_class::PATH)
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
end
