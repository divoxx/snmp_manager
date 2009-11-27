$:.unshift File.dirname(__FILE__) + "/../vendor/ruby_snmp/lib"
$:.unshift File.dirname(__FILE__)

require 'snmp'

module SNMPManager
  def self.base_path
    @base_path ||= File.expand_path(File.dirname(__FILE__) + "/..")
  end
end

require 'snmp_manager/snmp_cached_query'
require 'snmp_manager/stack_machine'
require 'snmp_manager/manager'
require 'snmp_manager/configuration_tokenizer'
require 'snmp_manager/configuration_parser'