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
solr_query = <<EOF.gsub(/\s+/,' ').strip
  chef_environment:_default
  AND drift_tracking_is_baseline:false
  AND drift_tracking:*
  AND drift_tracking_config:*
  AND drift_tracking_delta:*
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
