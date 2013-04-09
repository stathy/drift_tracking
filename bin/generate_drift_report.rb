#!/usr/bin/env ruby
#

require 'ruport'

require 'json'
require 'time'

require 'chef/environment'
require 'chef/knife'
require 'chef/node/attribute'
require 'chef/node'
require 'chef'

Chef::Config.from_file( %Q(#{ENV['HOME']}/.chef/knife.rb) )

table = Table("Node Name", "Delta", "RPM Name", "Baseline Release", "Baseline Version", "Target Release", "Target Version")

cur_dir = File.dirname(__FILE__)

## Capture the baseline
solr_query = <<EOF.gsub(/\s+/,' ').strip
  chef_environment:_default
  AND drift_tracking_is_baseline:true
  AND drift_tracking:*
  AND drift_tracking_config:*
EOF
q = Chef::Search::Query.new
nodes = q.search(:node, solr_query)
baseline_node = nodes[0].last

if nodes[0].size > 1
  raise %Q(Cannot have more than one baseline server defined "#{nodes.to_s}" )

elsif nodes[0].size < 1
  raise %Q(At least "1" baseline server must be defined !!!!" )

end

baseline_node.drift_tracking.config.each_value do |cat|
  cat.each_pair do |name, rpm|
    table << [ baseline_node.name, '*', name, rpm['release'], rpm['version'], "", "" ].flatten
  end
end

solr_query = <<EOF.gsub(/\s+/,' ').strip
  chef_environment:_default
  AND drift_tracking_is_baseline:false
  AND drift_tracking:*
  AND drift_tracking_config:*
  AND drift_tracking_delta:*
  AND drift_tracking_delta_*:*
EOF
q = Chef::Search::Query.new
nodes = q.search(:node, solr_query)

unless nodes[0].empty? then
  nodes[0].each do |n|
    n.drift_tracking.delta.each do |r|
      if r[0] == '-' then
        table << [ n.name, r[0], r[1], r[2].release, r[2].version, "", "" ].flatten

      elsif r[0] == '+' then
        table << [ n.name, r[0], r[1], "", "", r[2].release, r[2].version ].flatten
        
      else
        table << [ n.name, r[0], r[1], "", r[2], "", r[3], "" ].flatten

      end
    end
  end

end

grouping = Grouping(table, :by => "Node Name")
puts grouping.to_html

#,
#  :type         => "application/pdf",
#  :disposition  => "inline",
#  :filename     => "drift_report.pdf" 
