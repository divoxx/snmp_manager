class SNMPManager::ConfigurationParser
prechigh
  right OR AND
  right LT GT LTE GTE EQ NEQ
  right MUL DIV
  right ADD SUB
preclow

rule

  entries         : entries entry
                  | { @object = Configuration.new } 
                  ;
                  
  entry           : rule
                  | variable
                  | NEWLINE
                  ;
                  
  variable        : IDENTIFIER ':' math_expr NEWLINE { @object.define_variable(val[0], &val[2]) }
                  ;
  
  rule            : logic_expr ':' STRING NEWLINE { @object.define_rule(val[2], &val[0]) }
                  ;
                  
  math_expr       : math_expr math_expr DIV   { return lambda { |d| val[0].call(d) / val[1].call(d) }}
                  | math_expr math_expr MUL   { return lambda { |d| val[0].call(d) * val[1].call(d) }}
                  | math_expr math_expr ADD   { return lambda { |d| val[0].call(d) + val[1].call(d) }}
                  | math_expr math_expr SUB   { return lambda { |d| val[0].call(d) - val[1].call(d) }}
                  | INTEGER                   { return lambda { |d| Integer(val[0]) }}
                  | FLOAT                     { return lambda { |d| Float(val[0]) }}
                  | IDENTIFIER                { return lambda { |d| d[val[0]] }}
                  ;
                  
  logic_expr      : logic_expr logic_expr AND { return lambda { |d| val[0].call(d) && val[1].call(d) }}
                  | logic_expr logic_expr OR  { return lambda { |d| val[0].call(d) || val[1].call(d) }}
                  | math_expr math_expr LT    { return lambda { |d| val[0].call(d) < val[1].call(d) }}
                  | math_expr math_expr GT    { return lambda { |d| val[0].call(d) > val[1].call(d) }}
                  | math_expr math_expr LTE   { return lambda { |d| val[0].call(d) <= val[1].call(d) }}
                  | math_expr math_expr GTE   { return lambda { |d| val[0].call(d) >= val[1].call(d) }}
                  | math_expr math_expr EQ    { return lambda { |d| val[0].call(d) == val[1].call(d) }}
                  | math_expr math_expr NEQ   { return lambda { |d| val[0].call(d) != val[1].call(d) }}
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