module SNMPManager
  class ConfigurationTokenizer
    attr_accessor :line_num
    
    def initialize(string)
      @string   = string
      @line_num = 1
    end

    def each
      while @string && !@string.empty?
        token = case @string
        when /\A[0-9]+/m                                then yield([:INTEGER, $&])
        when /\A[0-9]+(\.[0-9]+)?/m                     then yield([:FLOAT, $&])
        when /\A\$?[a-zA-Z][a-zA-Z0-9_]+(\.[0-9]+)?/m   then yield([:IDENTIFIER, $&])
        when /\A"([^"]*)"/m                             then yield([:STRING, $1])
        when /\A&/m                                     then yield([:AND, $&])
        when /\A\|/m                                    then yield([:OR, $&])
        when /\A==/m                                    then yield([:EQUAL, $&])
        when /\A!=/m                                    then yield([:DIFF, $&])
        when /\A<=/m                                    then yield([:LES_EQ, $&])
        when /\A>=/m                                    then yield([:GRT_EQ, $&])
        when /\A</m                                     then yield([:LES, $&])
        when /\A>/m                                     then yield([:GRT, $&])
        when /\A\+/m                                    then yield([:PLUS, $&])
        when /\A-/m                                     then yield([:MINUS, $&])
        when /\A\//m                                    then yield([:DIV, $&])
        when /\A\*/m                                    then yield([:MULT, $&])
        when /\A\s*#.*?\n/m                             then nil # ignore comments
        when /\A\n/m                                    then @line_num += 1 and yield([:NEWLINE, $&])
        when /\A[^\s]/m                                 then yield([$&, $&])
        when /\A[ ]+/m                                  then nil
        end
        
        @string = $'
      end
      
      yield([false, '$'])
    end
  end
end