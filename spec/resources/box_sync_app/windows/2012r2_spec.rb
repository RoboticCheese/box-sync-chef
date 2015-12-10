require_relative '../../../spec_helper'

describe 'resource_box_sync_app::windows::2012r2' do
  let(:version) { nil }
  let(:action) { nil }
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: 'box_sync_app',
      platform: 'windows',
      version: '2012R2'
    )
  end
  let(:converge) { runner.converge("box_sync_app_test::#{action}") }

  context 'the default action (:install)' do
    let(:action) { :default }
    cached(:chef_run) { converge }

    it 'installs the Box Sync app' do
      expect(chef_run).to install_box_sync_app('default')
    end

    it 'installs the Box Sync .exe package' do
      expect(chef_run).to install_windows_package('Box Sync').with(
        source: Chef::Resource::BoxSyncAppWindows::URL,
        installer_type: :nsis
      )
    end
  end

  context 'the :remove action' do
    let(:action) { :remove }
    let(:installed?) { nil }

    before(:each) do
      pkgs = if installed?
               { 'Thing 1' => {},
                 'Box Sync' => { uninstall_string: 'something' } }
             else
               { 'Thing 1' => {} }
             end
      allow_any_instance_of(Chef::Resource::BoxSyncAppWindows)
        .to receive(:installed_packages).and_return(pkgs)
    end

    shared_examples_for 'any installed state' do
      it 'removes the Box Sync app' do
        expect(chef_run).to remove_box_sync_app('default')
      end
    end

    context 'Box Sync installed' do
      let(:installed?) { true }
      cached(:chef_run) { converge }

      it_behaves_like 'any installed state'

      it 'removes the Box Sync Windows package' do
        expect(chef_run).to run_execute('Remove Box Sync').with(
          command: 'start "" /wait something /S'
        )
      end
    end

    context 'Box Sync not installed' do
      let(:installed?) { false }
      cached(:chef_run) { converge }

      it_behaves_like 'any installed state'

      it 'does nothing' do
        expect(chef_run).to_not run_execute('Remove Box Sync')
      end
    end
  end
end
