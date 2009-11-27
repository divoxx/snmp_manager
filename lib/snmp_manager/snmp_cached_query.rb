module SNMPManager
  class SNMPCachedQuery
    def initialize(ip, community = 'private')
      @ip        = ip
      @community = community
      @cache     = {}
      @old_cache = {}
    end
    
    def reload!
      @old_cache = @cache.dup
      keys       = @cache.keys.sort
      values     = query(keys)
      keys.each_with_index { |key, i| @cache[key] = values[i] }
    end
    
    def [](object_ref)
      if object_ref =~ /^\$(.*)$/
        @old_cache[$1] || 0
      else
        @cache[object_ref] ||= query(object_ref).first
      end
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