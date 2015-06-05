# Encoding: UTF-8

require_relative '../spec_helper'

describe 'box-sync::app' do
  describe file('/Applications/Box Sync.app'), if: os[:family] == 'darwin' do
    it 'does not exist' do
      expect(subject).not_to be_directory
    end
  end

  describe package('Box Sync'), if: os[:family] == 'windows' do
    it 'is not installed' do
      pending
      expect(subject).not_to be_installed
    end
  end
end
