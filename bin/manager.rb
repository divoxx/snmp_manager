config_path, interval, *hosts = ARGV

if config_path.nil? || interval.nil? || hosts.empty?
  puts <<-BANNER
Usage: #{$0} <config_file> <interval> <host>+

Arguments:
  * config_file : path to configuration file
  * interval    : the number of seconds between verifications
  * hosts       : space separated list of hosts to be checking
  
Example:
  #{$0} samples/some_config.cfg 100 192.168.0.1 192.168.0.2 
  BANNER
  exit
end

require 'lib/snmp_manager'
include SNMPManager

trap(:SIGINT) do 
  puts "\b\bYou pressed CTRL-C, exiting... Bye!"
  exit(0)
end

parser  = ConfigurationParser.new
manager = parser.parse(File.read(config_path))

hosts.each { |h| manager.schedule(h) }

manager.run(Integer(interval))