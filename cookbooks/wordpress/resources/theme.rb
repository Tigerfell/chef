#
# Cookbook:: wordpress
# Resource:: wordpress_theme
#
# Copyright:: 2015, OpenStreetMap Foundation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default_action :create

property :theme, :kind_of => String, :name_attribute => true
property :site, :kind_of => String, :required => true
property :source, :kind_of => String
property :version, :kind_of => String
property :repository, :kind_of => String
property :revision, :kind_of => String
property :reload_apache, :kind_of => [TrueClass, FalseClass], :default => true

action :create do
  if new_resource.source
    remote_directory theme_directory do
      cookbook "wordpress"
      source new_resource.source
      owner node[:wordpress][:user]
      group node[:wordpress][:group]
      mode 0o755
      files_owner node[:wordpress][:user]
      files_group node[:wordpress][:group]
      files_mode 0o644
    end
  else
    theme_repository = new_resource.repository || default_repository

    if theme_repository.end_with?(".git")
      git theme_directory do
        action :sync
        repository theme_repository
        revision new_resource.revision
        user node[:wordpress][:user]
        group node[:wordpress][:group]
      end
    else
      subversion theme_directory do
        action :sync
        repository theme_repository
        user node[:wordpress][:user]
        group node[:wordpress][:group]
        ignore_failure theme_repository.start_with?("https://themes.svn.wordpress.org/")
      end
    end
  end
end

action :delete do
  directory theme_directory do
    action :delete
    recursive true
  end
end

action_class do
  def site_directory
    node[:wordpress][:sites][new_resource.site][:directory]
  end

  def theme_directory
    "#{site_directory}/wp-content/themes/#{new_resource.theme}"
  end

  def default_repository
    "https://themes.svn.wordpress.org/#{new_resource.theme}/#{new_resource.version}"
  end
end

def after_created
  notifies :reload, "service[apache2]" if reload_apache
end
