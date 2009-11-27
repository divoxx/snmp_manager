class SNMPManager::ConfigurationParser
prechigh
  right OR AND
  right LT GT LTE GTE EQ NEQ
  right MUL DIV
  right ADD SUB
preclow

rule

  entries         : entries entry
                  | { @object = Manager.new } 
                  ;
                  
  entry           : rule
                  | variable
                  | NEWLINE
                  ;
                  
  variable        : IDENTIFIER ':' math_expr NEWLINE { @object.define_variable(val[0], val[2]) }
                  ;
  
  rule            : logic_expr ':' STRING NEWLINE { @object.define_rule(val[2], val[0]) }
                  ;
                  
  math_expr       : math_expr math_expr DIV   { return val[0] + val[1] + [[:calc, :div]]  }
                  | math_expr math_expr MUL   { return val[0] + val[1] + [[:calc, :mul]]  }
                  | math_expr math_expr ADD   { return val[0] + val[1] + [[:calc, :add]]  }
                  | math_expr math_expr SUB   { return val[0] + val[1] + [[:calc, :sub]]  }
                  | INTEGER                   { return [[:push, Integer(val[0])]]         }
                  | FLOAT                     { return [[:push, Float(val[0])]]           }
                  | IDENTIFIER                { return [[:push, val[0]], [:calc, :load]]  }
                  ;
                  
  logic_expr      : logic_expr logic_expr AND { return val[0] + val[1] + [[:calc, :and]] }
                  | logic_expr logic_expr OR  { return val[0] + val[1] + [[:calc, :or]]  }
                  | math_expr math_expr LT    { return val[0] + val[1] + [[:calc, :lt]]  }
                  | math_expr math_expr GT    { return val[0] + val[1] + [[:calc, :gt]]  }
                  | math_expr math_expr LTE   { return val[0] + val[1] + [[:calc, :lte]] }
                  | math_expr math_expr GTE   { return val[0] + val[1] + [[:calc, :gte]] }
                  | math_expr math_expr EQ    { return val[0] + val[1] + [[:calc, :eq]]  }
                  | math_expr math_expr NEQ   { return val[0] + val[1] + [[:calc, :neq]] }
                  ;

---- inner ----  
  def initialize(tokenizer_klass = ConfigurationTokenizer)
    @tokenizer_klass = tokenizer_klass
  end
  
  def parse(string)
    @tokenizer = @tokenizer_klass.new(string)
    yyparse(@tokenizer, :each)
    return @object
  ensure
    @tokenizer = nil
  end
  
  def on_error(err_token, err_val, values)
    puts @tokenizer.line_num
    super
  end
  
  def next_token
    @tokenizer.next_token
  end