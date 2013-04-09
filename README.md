drift_tracking Cookbook
=======================


Requirements
------------

On workstation / report generation side
```ruby
gem install ruport
gem install ruport-util
```

On node side, where drift_tracking::detect_drift is run
```
# Included in recipe
chef_gem 'hashdiff'
```


Attributes
----------

```ruby
default['drift_tracking']['is_baseline'] = false
default['drift_tracking']['timestamp'] = Time.new.strftime("%Y_%m_%d-%H:%M:%S")
default['drift_tracking']['config'] = Mash.new
```

Usage
-----

#### drift_tracking::baseline

In the drift_tracking::baseline recipe assign the appropriate attributes to be tracked :

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

Modify to accomodate environment in solr search and output format. Currently leverages `ruport`
for generating presentation format.

<p>dt-m1</p>
<table>
        <tr>
                <th>Delta</th>
                <th>RPM Name</th>
                <th>Baseline Release</th>
                <th>Baseline Version</th>
                <th>Target Release</th>
                <th>Target Version</th>
        </tr>
        <tr>
                <td>~</td>
                <td>rpm.dbus-glib.release</td>
                <td>&nbsp;</td>
                <td>10.el5_5</td>
                <td>&nbsp;</td>
                <td>11.el5_9</td>
        </tr>
        <tr>
                <td>~</td>
                <td>rpm.perl.release</td>
                <td>&nbsp;</td>
                <td>38.el5_8</td>
                <td>&nbsp;</td>
                <td>40.el5_9</td>
        </tr>
        <tr>
                <td>~</td>
                <td>rpm.cups-libs.release</td>
                <td>&nbsp;</td>
                <td>30.el5</td>
                <td>&nbsp;</td>
                <td>30.el5_9.3</td>
        </tr>
        <tr>
                <td>~</td>
                <td>rpm.libxml2.release</td>
                <td>&nbsp;</td>
                <td>2.1.15.el5_8.6</td>
                <td>&nbsp;</td>
                <td>2.1.21.el5_9.2</td>
        </tr>
        <tr>
                <td>~</td>
                <td>rpm.openssl.release</td>
                <td>&nbsp;</td>
                <td>22.el5_8.4</td>
                <td>&nbsp;</td>
                <td>26.el5_9.1</td>
        </tr>
        <tr>
                <td>~</td>
                <td>rpm.kernel-headers.release</td>
                <td>&nbsp;</td>
                <td>348.1.1.el5</td>
                <td>&nbsp;</td>
                <td>348.3.1.el5</td>
        </tr>
        <tr>
                <td>~</td>
                <td>rpm.gnutls.release</td>
                <td>&nbsp;</td>
                <td>10.el5</td>
                <td>&nbsp;</td>
                <td>10.el5_9.1</td>
        </tr>
        <tr>
                <td>~</td>
                <td>rpm.sudo.release</td>
                <td>&nbsp;</td>
                <td>22.el5</td>
                <td>&nbsp;</td>
                <td>22.el5_9.1</td>
        </tr>
        <tr>
                <td>~</td>
                <td>rpm.rpm-libs.release</td>
                <td>&nbsp;</td>
                <td>31.el5</td>
                <td>&nbsp;</td>
                <td>32.el5_9</td>
        </tr>
        <tr>
                <td>~</td>
                <td>rpm.kernel.release</td>
                <td>&nbsp;</td>
                <td>348.1.1.el5</td>
                <td>&nbsp;</td>
                <td>348.3.1.el5</td>
        </tr>
        <tr>
                <td>~</td>
                <td>rpm.openssl-devel.release</td>
                <td>&nbsp;</td>
                <td>22.el5_8.4</td>
                <td>&nbsp;</td>
                <td>26.el5_9.1</td>
        </tr>
        <tr>
                <td>~</td>
                <td>rpm.libxml2-python.release</td>
                <td>&nbsp;</td>
                <td>2.1.15.el5_8.6</td>
                <td>&nbsp;</td>
                <td>2.1.21.el5_9.2</td>
        </tr>
        <tr>
                <td>~</td>
                <td>rpm.libxml2-devel.release</td>
                <td>&nbsp;</td>
                <td>2.1.15.el5_8.6</td>
                <td>&nbsp;</td>
                <td>2.1.21.el5_9.2</td>
        </tr>
        <tr>
                <td>~</td>
                <td>rpm.popt.release</td>
                <td>&nbsp;</td>
                <td>31.el5</td>
                <td>&nbsp;</td>
                <td>32.el5_9</td>
        </tr>
        <tr>
                <td>~</td>
                <td>rpm.java-1.6.0-openjdk.release</td>
                <td>&nbsp;</td>
                <td>1.33.1.11.6.el5_9</td>
                <td>&nbsp;</td>
                <td>1.36.1.11.9.el5_9</td>
        </tr>
        <tr>
                <td>~</td>
                <td>rpm.rpm-python.release</td>
                <td>&nbsp;</td>
                <td>31.el5</td>
                <td>&nbsp;</td>
                <td>32.el5_9</td>
        </tr>
        <tr>
                <td>~</td>
                <td>rpm.rpm-build.release</td>
                <td>&nbsp;</td>
                <td>31.el5</td>
                <td>&nbsp;</td>
                <td>32.el5_9</td>
        </tr>
        <tr>
                <td>~</td>
                <td>rpm.tzdata.version</td>
                <td>&nbsp;</td>
                <td>2012j</td>
                <td>&nbsp;</td>
                <td>2013b</td>
        </tr>
        <tr>
                <td>~</td>
                <td>rpm.tzdata-java.version</td>
                <td>&nbsp;</td>
                <td>2012j</td>
                <td>&nbsp;</td>
                <td>2013b</td>
        </tr>
        <tr>
                <td>~</td>
                <td>rpm.java-1.6.0-openjdk-devel.release</td>
                <td>&nbsp;</td>
                <td>1.33.1.11.6.el5_9</td>
                <td>&nbsp;</td>
                <td>1.36.1.11.9.el5_9</td>
        </tr>
        <tr>
                <td>~</td>
                <td>rpm.rpm.release</td>
                <td>&nbsp;</td>
                <td>31.el5</td>
                <td>&nbsp;</td>
                <td>32.el5_9</td>
        </tr>
</table>


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
