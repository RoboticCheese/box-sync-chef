# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_box_sync_app'

describe Chef::Provider::BoxSyncApp do
  let(:name) { 'default' }
  let(:new_resource) { Chef::Resource::BoxSyncApp.new(name, nil) }
  let(:provider) { described_class.new(new_resource, nil) }

  describe '#whyrun_supported?' do
    it 'returns true' do
      expect(provider.whyrun_supported?).to eq(true)
    end
  end

  describe '#action_install' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:install!)
    end

    it 'calls the child `install!` method ' do
      expect_any_instance_of(described_class).to receive(:install!)
      provider.action_install
    end

    it 'sets the resource installed status' do
      p = provider
      p.action_install
      expect(p.new_resource.installed?).to eq(true)
    end
  end

  describe '#action_remove' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:remove!)
    end

    it 'calls the child `remove!` method ' do
      expect_any_instance_of(described_class).to receive(:remove!)
      provider.action_remove
    end

    it 'sets the resource installed status' do
      p = provider
      p.action_remove
      expect(p.new_resource.installed?).to eq(false)
    end
  end

  describe '#install!' do
    it 'raises an error' do
      expect { provider.send(:install!) }.to raise_error(NotImplementedError)
    end
  end

  describe '#remove!' do
    it 'raises an error' do
      expect { provider.send(:remove!) }.to raise_error(NotImplementedError)
    end
  end

  describe '#chase_redirect' do
    let(:response) { nil }
    let(:url) { 'https://example.com/somewhere' }
    let(:http) { double }

    before(:each) do
      uri = URI.parse(url)
      opts = { use_ssl: true, ca_file: nil }
      expect(http).to receive(:head).with(url).and_return(response)
      allow(Net::HTTP).to receive(:start).with(uri.host, uri.port, opts)
        .and_yield(http)
    end

    context 'no redirect' do
      let(:response) { Net::HTTPResponse.new(1, 200, 'hi') }

      it 'returns the same URL' do
        expect(provider.send(:chase_redirect, url)).to eq(url)
      end
    end

    context 'a single level of redirect' do
      let(:suburl) { 'https://example.com/elsewhere' }
      let(:subresponse) { Net::HTTPResponse.new(1, 200, 'hi') }
      let(:response) do
        r = Net::HTTPRedirection.new(1, 302, 'hi')
        r['location'] = suburl
        r
      end

      before(:each) do
        expect(http).to receive(:head).with(suburl)
          .and_return(subresponse)
      end

      it 'follows the redirect' do
        expect(provider.send(:chase_redirect, url)).to eq(suburl)
      end
    end

    context 'multiple levels of redirects' do
      let(:subsuburl) { 'https://example.com/pt3' }
      let(:subsubresponse) { Net::HTTPResponse.new(1, 200, 'hi') }

      let(:suburl) { 'https://example.com/pt2' }
      let(:subresponse) do
        r = Net::HTTPRedirection.new(1, 302, 'hi')
        r['location'] = subsuburl
        r
      end

      let(:response) do
        r = Net::HTTPRedirection.new(1, 302, 'hi')
        r['location'] = suburl
        r
      end

      before(:each) do
        expect(http).to receive(:head).with(subsuburl)
          .and_return(subsubresponse)
        expect(http).to receive(:head).with(suburl)
          .and_return(subresponse)
      end

      it 'follows all the redirects' do
        expect(provider.send(:chase_redirect, url)).to eq(subsuburl)
      end
    end

    context 'too many levels of redirects' do
      let(:response) do
        r = Net::HTTPRedirection.new(1, 302, 'hi')
        r['location'] = 'https://example.com/pt0'
        r
      end

      before(:each) do
        (0..10).each do |i|
          uri = "https://example.com/pt#{i}"
          r = Net::HTTPRedirection.new(1, 302, 'hi')
          r['location'] = "https://example.com/pt#{i + 1}"
          allow(http).to receive(:head).with(uri)
            .and_return(r)
        end
      end

      it 'returns nil' do
        expect(provider.send(:chase_redirect, url)).to eq(nil)
      end
    end
  end
end
