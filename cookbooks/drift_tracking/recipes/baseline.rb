#
# Cookbook Name:: drift_tracking
# Recipe:: baseline
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

# We do this so that the process of identifying baseline is manual induced

node.set['drift_tracking']['is_baseline'] = true
date = node.set['drift_tracking']['timestamp'] = Time.new.strftime("%Y_%m_%d-%H:%M:%S")
node.set['drift_tracking']['config']['rpm'] = node['rpm']

ruby_block "remove_baseline" do
  block do
    Chef::Log.info( %Q(Baseline capture complete "#{date}", removing recipe[change_tracking::baseline]") )
    node.run_list.remove("recipe[drift_tracking::baseline]") if node.run_list.include?("recipe[drift_tracking::baseline]")
  end

  action :nothing
end.run_action(:run)
