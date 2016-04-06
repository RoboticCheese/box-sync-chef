# Encoding: UTF-8

include_recipe 'box-sync'

box_sync_app 'default' do
  action :remove
end
