$:.unshift File.dirname(__FILE__) + "/../vendor/ruby_snmp/lib"
$:.unshift File.dirname(__FILE__)

require 'snmp'

require 'snmp_manager/snmp_cached_query'
require 'snmp_manager/stack_machine'