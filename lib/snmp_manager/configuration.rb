module SNMPManager
  class Configuration
    def initialize
      @variables = {}
      @rules     = []
    end
    
    def define_variable(varname, &block)
      @variables[varname] = block
    end
    
    def define_rule(string, &block)
      @rules << [block, string]
    end
  end
end