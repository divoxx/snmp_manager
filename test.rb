require 'lib/snmp_manager'
include SNMPManager

parser  = ConfigurationParser.new
manager = parser.parse(File.read('config_test.cfg'))

manager.schedule('localhost')
manager.run(5)
