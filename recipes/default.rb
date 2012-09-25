#
# Cookbook Name:: alal
# Recipe:: default
#
# Copyright 2011, Blank Pad Development
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "git"
include_recipe "collectd::server"

git "/opt/collectd-graphite-writer" do
  repository "git://github.com/indygreg/collectd-carbon.git"
  reference "939e9f8eb6d782a1cecf76d9b1b2a8b2b2632ba2"
  action :sync
#  notifies :run, "execute[build debian package]"
end

collectd_python_plugin "carbon_writer" do
    options  :line_receiver_host      => "127.0.0.1",
        :line_receiver_port               => 2003,
        :differentiate_counters_over_time => true,
        :lowercase_metric_names           => true,
        :types_d_b                        => "/usr/share/collectd/types.db",
        :metric_prefix                    => "collectd"
end

link "#{node[:collectd][:plugin_dir]}/carbon_writer.py" do
    to "/opt/collectd-graphite-writer/carbon_writer.py"
end
