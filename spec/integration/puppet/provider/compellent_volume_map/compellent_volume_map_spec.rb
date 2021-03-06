#! /usr/bin/env ruby

require 'spec_helper'
require 'yaml'

describe Puppet::Type.type(:compellent_volume_map).provider(:compellent_volume_map) do

  device_conf =  YAML.load_file(my_fixture('device_conf.yml'))
  before :each do
    Facter.stubs(:value).with(:url).returns(device_conf['url'])
    described_class.stubs(:suitable?).returns true
    Puppet::Type.type(:compellent_volume_map).stubs(:defaultprovider).returns described_class
  end

  map_volume_yml =  YAML.load_file(my_fixture('map_volume.yml'))
  map_node1      =  map_volume_yml['MapVolume1']

  let :map_volume do
    Puppet::Type.type(:compellent_volume_map).new(
    :name          	=> map_node1['name'],
    :ensure        	=> map_node1['ensure'],
    :boot		    => map_node1['boot'],
    :servername 	=> map_node1['servername'],
    :serverfolder	=> map_node1['serverfolder'],
    :lun		    => map_node1['lun'],
    :volumefolder	=> map_node1['volumefolder'],
    :localport	    => map_node1['localport'],
    :force		    => map_node1['force'],
    :readonly	    => map_node1['readonly'],
    :singlepath   	=> map_node1['singlepath']
    )
  end

  unmap_volume_yml =  YAML.load_file(my_fixture('unmap_volume.yml'))
  unmap_node1 = unmap_volume_yml['UnmapVolume1']

  let :unmap_volume do
    Puppet::Type.type(:compellent_volume_map).new(
    :name                       => unmap_node1['name'],
    :ensure                     => unmap_node1['ensure'],
    :serverfolder               => unmap_node1['serverfolder'],
    :servername                 => unmap_node1['servername'],
    :volumefolder               => unmap_node1['volumefolder']
    )
  end


  let :provider do
    described_class.new( )
  end

   describe "when not exists?" do
    it "should return true if volume is not mapped with server" do
      map_volume.provider.should_not be_exists
    end
  end

  describe "when mapping a volume" do
    it "should be able to map volume with server" do
      map_volume.provider.create
    end
  end


  describe "when exists?" do
    it "should return true if volume mapped with server" do
      unmap_volume.provider.should be_exists
    end
  end

  describe "when un-mapping a volume" do
    it "should be able to un-map volume with server" do
      unmap_volume.provider.destroy
    end
  end


end
