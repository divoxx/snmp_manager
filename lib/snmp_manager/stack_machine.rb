require 'set'

module SNMPManager
  class StackMachine
    # Creates a new Stack Machine
    def initialize
      @stack = []
    end
    
    # Perform an operation on the stack, a operation takes a N number of arguments on
    # the top of the stack and reduce it to a single argument.
    #
    # Example operations are: and, or, add, mul, etc.
    # All supported operations are defined as method in this class with the name "op_<operation>",
    # for example "op_add".
    def calc(operator)
      op_method = method("op_#{operator}")
      arguments = @stack.pop(op_method.arity)
      op_method.call(*arguments)
      @stack.last
    end
    
    # Add a new object to the top of the stack.
    def push(object)
      @stack.push(object)
    end
    
    # Get the object on the top of the stack, accepts a number as argument to get N objects.
    def pop(*args)
      @stack.pop(*args)
    end
  
  protected
    # Loads a object from the memory
    def op_load(ident)
      @stack.push(@memory[ident])
    end
    
    # Gets a object and transform it in true or false.
    def op_booleanize(a)
      @stack.push(!!a)
    end
    
    # Logic AND operation.
    def op_and(a, b)
      @stack.push(a && b)
      calc(:booleanize)
    end
    
    # Logic OR operation.
    def op_or(a, b)
      @stack.push(a || b)
      calc(:booleanize)
    end
    
    # Less than (<) operation.
    def op_lt(a, b)
      @stack.push(a.to_i < b.to_i)
    end
    
    # Greater than (>) operation.
    def op_gt(a, b)
      @stack.push(a.to_i > b.to_i)
    end
    
    # Less than or equal (<=) operation.
    def op_lte(a, b)
      @stack.push(a.to_i <= b.to_i)
    end
    
    # Greater than or equal (>=) operation.
    def op_gte(a, b)
      @stack.push(a.to_i >= b.to_i)
    end
    
    # Equal operation (==)
    def op_eq(a, b)
      @stack.push(a == b)
    end
    
    # Not equal operation (!=)
    def op_neq(a, b)
      @stack.push(a != b)
    end
    
    # Multiplication operation (*)
    def op_mul(a, b)
      @stack.push(a.to_i * b.to_i)
    end
    
    # Division operation (/)
    def op_div(a, b)
      @stack.push(a.to_i / b.to_i)
    end
    
    # Add operation (+)
    def op_add(a, b)
      @stack.push(a.to_i + b.to_i)
    end
    
    # Subtraction operation (-)
    def op_sub(a, b)
      @stack.push(a.to_i - b.to_i)
    end
  end
end