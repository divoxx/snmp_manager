require 'thread'
require 'logger'

module SNMPManager
  class Manager
    def initialize
      @variables       = {}
      @rules           = {}
      @cached_memories = {}
      @logger          = Logger.new(SNMPManager.base_path + "/manager.log")
    end
    
    def define_variable(name, program)
      @variables[name] = program
    end
    
    def define_rule(notification_str, program)
      @rules[program] = notification_str
    end
    
    def schedule(host)
      @cached_memories[host] = SNMPCachedQuery.new(host)
    end
    
    def run(interval)
      loop do
        @cached_memories.each do |host, memory|
          @logger.info "#{host}: querying host"
          
          memory.reload!
          results = {}
        
          @variables.each do |name, program|
            results[name] = StackMachine.run(program, memory)
          end

          @logger.info "#{host}: #{results.inspect}"          
                
          succeed = true
          @rules.each do |program, notification_str|
            if StackMachine.run(program, results)
              succeed = false
              message = "#{host}: #{notification_str}"
              @logger.warn(message) and puts message
            end
          end
          
          @logger.info "#{host}: host #{succeed ? 'ok' : 'has warnings'}"
        end        
        
        sleep interval
      end
    end
  end
end
