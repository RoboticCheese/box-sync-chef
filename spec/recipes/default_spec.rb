# Encoding: UTF-8

require_relative '../spec_helper'

describe 'box-sync::default' do
  let(:runner) { ChefSpec::SoloRunner.new }
  let(:chef_run) { runner.converge(described_recipe) }

  it 'installs the Box Sync app' do
    expect(chef_run).to install_box_sync_app('default')
  end
end
