module SNMPManager
  class SNMPCachedQuery
    def initialize(ip, community = 'private')
      @ip        = ip
      @community = community
      @cache     = {}
    end
    
    def reload!
      keys   = @cache.keys.sort
      values = query(keys)
      keys.each_with_index { |key, i| @cache[key] = values[i] }
    end
    
    def [](object_ref)
      @cache[object_ref] ||= query(object_ref).first
    end
    
  protected
    def query(keys)
      manager = SNMP::Manager.new(:Host => @ip, :Community => @community)
      manager.get_value(Array(keys))
    ensure
      manager.close
    end
  end
end