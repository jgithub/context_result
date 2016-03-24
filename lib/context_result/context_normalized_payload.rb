class ContextNormalizedPayload
  attr_accessor :data
  attr_accessor :corresponds_to  
  attr_accessor :meta

  def initialize( payload = nil )
    if payload
      if payload.respond_to?( :each ) && 
         payload.respond_to?( :keys ) && 
         ( payload.has_key?("data") || payload.has_key?(:data) )  # it's a hash
        payload.each do |name, value|
          send("#{name}=", value) if respond_to?(name)
        end 
      else
        self.data = payload
      end
    end   
  end  

  def as_json
    retval = {
      "data" => data
    }
    if meta
      retval["meta"] = meta 
    end
    if corresponds_to
      retval["corresponds_to"] = corresponds_to 
    end

    return retval
  end
end
