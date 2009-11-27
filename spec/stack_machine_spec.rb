require File.dirname(__FILE__) + "/spec_helper"

describe StackMachine do
  before :each do
    @memory  = {}
    @machine = StackMachine.new(@memory)
  end

  describe "AND operation" do
    it "should result in false with true and false" do
      @machine.push(true)
      @machine.push(false)
      @machine.calc(:and).should be(false)
    end
    
    it "should result in false with false and true" do
      @machine.push(false)
      @machine.push(true)
      @machine.calc(:and).should be(false)
    end
    
    it "should result in false with false and false" do
      @machine.push(false)
      @machine.push(false)
      @machine.calc(:and).should be(false)
    end
    
    it "should result in true with true and true" do
      @machine.push(true)
      @machine.push(true)
      @machine.calc(:and).should be(true)
    end
  end
  
  describe "OR operation" do
    it "should result in true with true or false" do
      @machine.push(true)
      @machine.push(false)
      @machine.calc(:or).should be(true)
    end
    
    it "should result in true with false or true" do
      @machine.push(false)
      @machine.push(true)
      @machine.calc(:or).should be(true)
    end
    
    it "should result in false with false or false" do
      @machine.push(false)
      @machine.push(false)
      @machine.calc(:or).should be(false)
    end
    
    it "should result in true with true or true" do
      @machine.push(true)
      @machine.push(true)
      @machine.calc(:or).should be(true)
    end
  end
  
  describe "LT operation" do
    it "should result in true with 1 < 2" do
      @machine.push(1)
      @machine.push(2)
      @machine.calc(:lt).should be(true)
    end
    
    it "should result in false with 1 < 1" do
      @machine.push(1)
      @machine.push(1)
      @machine.calc(:lt).should be(false)
    end
    
    it "should result in false with 1 < 0" do
      @machine.push(1)
      @machine.push(0)
      @machine.calc(:lt).should be(false)
    end
  end

  describe "GT operation" do
    it "should result in false with 1 > 2" do
      @machine.push(1)
      @machine.push(2)
      @machine.calc(:gt).should be(false)
    end
    
    it "should result in false with 1 > 1" do
      @machine.push(1)
      @machine.push(1)
      @machine.calc(:gt).should be(false)
    end
    
    it "should result in true with 1 > 0" do
      @machine.push(1)
      @machine.push(0)
      @machine.calc(:gt).should be(true)
    end
  end
  
  describe "LTE operation" do
    it "should result in true with 1 <= 2" do
      @machine.push(1)
      @machine.push(2)
      @machine.calc(:lte).should be(true)
    end
    
    it "should result in true with 1 <= 1" do
      @machine.push(1)
      @machine.push(1)
      @machine.calc(:lte).should be(true)
    end
    
    it "should result in false with 1 <= 0" do
      @machine.push(1)
      @machine.push(0)
      @machine.calc(:lte).should be(false)
    end
  end

  describe "GTE operation" do
    it "should result in false with 1 >= 2" do
      @machine.push(1)
      @machine.push(2)
      @machine.calc(:gte).should be(false)
    end
    
    it "should result in true with 1 >= 1" do
      @machine.push(1)
      @machine.push(1)
      @machine.calc(:gte).should be(true)
    end
    
    it "should result in true with 1 >= 0" do
      @machine.push(1)
      @machine.push(0)
      @machine.calc(:gte).should be(true)
    end
  end
  
  describe "EQ operation" do
    it "should result in true with 1 == 1" do
      @machine.push(1)
      @machine.push(1)
      @machine.calc(:eq).should be(true)
    end
    
    it "should result in false with 1 == 2" do
      @machine.push(1)
      @machine.push(2)
      @machine.calc(:eq).should be(false)
    end
  end
  
  describe "NEQ operation" do
    it "should result in false with 1 != 1" do
      @machine.push(1)
      @machine.push(1)
      @machine.calc(:neq).should be(false)
    end
    
    it "should result in true with 1 != 2" do
      @machine.push(1)
      @machine.push(2)
      @machine.calc(:neq).should be(true)
    end
  end
  
  describe "MUL operation" do
    it "should result in 4 with 2 * 2" do
      @machine.push(2)
      @machine.push(2)
      @machine.calc(:mul).should be(4)
    end
  end
  
  describe "DIV operation" do
    it "should result in 2 with 4 / 2" do
      @machine.push(4)
      @machine.push(2)
      @machine.calc(:div).should be(2)
    end
  end
  
  describe "ADD operation" do
    it "should result in 4 with 2 + 2" do
      @machine.push(2)
      @machine.push(2)
      @machine.calc(:add).should be(4)
    end
  end
  
  describe "SUB operation" do
    it "should result in 2 with 4 - 2" do
      @machine.push(4)
      @machine.push(2)
      @machine.calc(:sub).should be(2)
    end
  end
  
  describe "Program running" do
    it "should produce proper result" do
      @memory.merge!(:a => 5, :b => 10, :c => 100)
      @machine.run([
        [:push, :a],
        [:calc, :load],
        [:push, :b],
        [:calc, :load],
        [:calc, :add],
        [:push, :c],
        [:calc, :load],
        [:calc, :mul]
      ]).should == 1500
    end
  end
end