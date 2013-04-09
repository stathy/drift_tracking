# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# CreatedBy:: Stathy Touloumis <stathy@opscode.com>
#
#

require 'chef/environment'
require 'chef/knife'
require 'chef'

require 'digest'

Chef::Log.level = :info

Vagrant::Config.run do |config|

    config.vm.box = "centos_58_11-4"

    {
        :baseline => {
            :ip       => '192.168.65.205',
            :memory   => 256,
            :run_list => %w( recipe[ohai] recipe[drift_tracking::baseline] )
        },
        :m1 => {
            :ip       => '192.168.65.206',
            :memory   => 256,
            :run_list => %w( recipe[ohai] recipe[drift_tracking::detect_drift] )
        }
        :m2 => {
            :ip       => '192.168.65.207',
            :memory   => 256,
            :run_list => %w( recipe[ohai] recipe[drift_tracking::detect_drift] )
        }

    }.each do |name,cfg|

        config.vm.define name do |vm_cfg|
            vm_cfg.vm.host_name = "dt-#{name}"
            vm_cfg.vm.network :hostonly, cfg[:ip] if cfg[:ip]
            vm_cfg.vm.box = cfg[:box] if cfg[:box]

            vm_cfg.vm.customize ["modifyvm", :id, "--name", vm_cfg.vm.host_name]
            vm_cfg.vm.customize ["modifyvm", :id, "--memory", cfg[:memory]]
            vm_cfg.vm.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
          
            if cfg[:forwards]
              cfg[:forwards].each do |from,to|
                vm_config.vm.forward_port from, to
              end 
            end
    
            vm_cfg.vm.provision :chef_client do |chef|
                chef.chef_server_url = "https://chef.localdomain/organizations/opscode"
                chef.validation_key_path = "#{ENV['HOME']}/.chef/chef_localdomain-opscode-validator.pem"
                chef.validation_client_name = "opscode-validator"
                chef.node_name = vm_cfg.vm.host_name
                chef.provisioning_path = "/etc/chef"
                chef.log_level = :info
                chef.json = cfg[:attr] if cfg[:attr].is_a?(Hash)
    
                if cfg[:run_list].nil?
                    cfg['role'] ||= []
                    cfg['role'].each { |r| chef.add_role(r) }
                    cfg['recipe'] ||= []                
                    cfg['recipe'].each { |r| chef.add_recipe(r) }
                else
                    chef.run_list = cfg[:run_list]
                end
    
            end
    
        end
    
    end

end


__END__

