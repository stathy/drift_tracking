#
# Cookbook Name:: drift_tracking
# Attributes:: default
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

default['drift_tracking']['is_baseline'] = false
default['drift_tracking']['timestamp'] = Time.new.strftime("%Y_%m_%d-%H:%M:%S")
default['drift_tracking']['config'] = Mash.new