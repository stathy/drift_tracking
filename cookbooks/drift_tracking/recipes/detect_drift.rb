#
# Cookbook Name:: drift_tracking
# Recipe:: detect_drift
#
# Author:: Stathy Touloumis <stathy@opscode.com
#
# License:: Apache License, Version 2.0
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
## See the License for the specific language governing permissions and
# limitations under the License.
#

require 'json'

chef_gem 'hashdiff'
require 'hashdiff'

nodes = search(:node, %Q(chef_environment:#{node.chef_environment} AND drift_tracking:* AND drift_tracking_is_baseline:true NOT name:#{node.name}) )
if nodes.size > 1
  raise %Q(Cannot have more than one baseline server defined "#{nodes.to_s}" )

elsif nodes.size < 1
  raise %Q(At least "1" baseline server must be defined !!!!" )

end
baseline_node = nodes.last
date = node.set['drift_tracking']['timestamp'] = Time.new.strftime("%Y_%m_%d-%H:%M:%S")

baseline_node['drift_tracking']['config'].each_key do |k|
  node.set['drift_tracking']['config'][ k ] = node[ k ]
end

Chef::Log.info( %Q(Baseline comparison to "#{baseline_node.name}" on "#{date}") )

a_config = JSON.parse( baseline_node['drift_tracking']['config'].to_json )
b_config = JSON.parse( node['drift_tracking']['config'].to_json )
if a_config == b_config then
  delta = nil

else
  delta = HashDiff.diff(a_config, b_config)

end

node.set['drift_tracking']['delta'] = delta
