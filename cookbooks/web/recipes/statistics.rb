#
# Cookbook:: web
# Recipe:: statistics
#
# Copyright:: 2011, OpenStreetMap Foundation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "web::base"

ruby = "ruby#{node[:passenger][:ruby_version]}"
rails_directory = "#{node[:web][:base_directory]}/rails"

template "/usr/local/bin/statistics" do
  source "statistics.erb"
  owner "root"
  group "root"
  mode "755"
  variables :ruby => ruby, :directory => rails_directory
end

cron_d "statistics" do
  minute "0"
  hour "0"
  user "rails"
  command "/usr/local/bin/statistics"
end
