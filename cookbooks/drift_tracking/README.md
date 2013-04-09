drift_tracking Cookbook
=======================


Requirements
------------
TODO: List your cookbook requirements. Be sure to include any requirements this cookbook has on platforms, libraries, other cookbooks, packages, operating systems, etc.

e.g.
#### packages
- `toaster` - drift_tracking needs toaster to brown your bagel.

Attributes
----------
default['drift_tracking']['is_baseline'] = false
default['drift_tracking']['timestamp'] = Time.new.strftime("%Y_%m_%d-%H:%M:%S")
default['drift_tracking']['config'] = Mash.new

Usage
-----

#### drift_tracking::baseline

\In the drift_tracking::baseline recipe assign the appropriate attributes to be tracked :

```ruby
node.set['drift_tracking']['config']['rpm'] = node['rpm']
```

Include `drift_tracking::baseline` on the node which will act as 'baseline' or 'standard' config :

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[drift_tracking::baseline]"
  ]
}
```

It will remove itself after running. This behavior can be changed by removing the resource
ruby_block[remove_baseline]

#### drift_tracking::detect_drift

Just include `drift_tracking::baseline` on the node which will act as 'baseline' or 'standard' config :

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[drift_tracking::drift_tracking]"
  ]
}
```

No changes will need to be made. It will write out a new attribute called 'delta' which will contain
a delta of the baseline and the current node config.

```ruby
node['drift_tracking']['delta']
```

#### bin/generate_drift_report.rb



Contributing
------------
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Stathy Touloumis <stathy@opscode.com>
