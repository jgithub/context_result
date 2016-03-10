require 'active_support/json'

class ContextResult
  attr_accessor :result
  attr_accessor :is_present

  # Always based on UTC Time
  attr_accessor :created_at

  def self.present_instance( attributes = nil )
    if attributes && attributes.respond_to?(:keys) && attributes.respond_to?(:each)
      context_result = new(attributes)
    else
      context_result = new 
      context_result.result = attributes
    end
    context_result.is_present = true
    context_result
  end

  def self.present_and_created_instance( attributes = nil )
    context_result = present_instance( attributes )
    context_result.mark_created_right_now
    context_result
  end

  def initialize( attributes = nil )
    if attributes
      if attributes.respond_to?(:keys) && attributes.respond_to?(:each)
        attributes.each do |name, value|
          send("#{name}=", value) if respond_to?( name )
        end
      else
        self.is_present = true

        # attributes is an object
        self.result = attributes
      end
    end      
  end

  def attributes=( attributes = {} )
    attributes && attributes.each do |name, value|
      send("#{name}=", value) if respond_to? "#{name}="
    end
  end

  def mark_created_right_now
    self.created_at = Time.now.utc
  end

  def older_than_number_of_seconds?( number_of_seconds )
    if self.created_at
      if created_at < Time.now.utc - number_of_seconds
        retval = true
      else
        retval = false
      end
    else
      retval = nil 
    end 

    return retval
  end

  def younger_than_number_of_seconds?( number_of_seconds )
    if self.created_at
      if created_at > Time.now.utc - number_of_seconds
        retval = true
      else
        retval = false
      end
    else
      retval = nil 
    end 

    return retval
  end

  def as_json
    retval = {}
    retval["result"] = result.as_json if (result || is_present)
    retval["is_present"] = is_present if is_present
    retval["created_at"] = (created_at ? created_at.iso8601 : nil) if created_at
    return retval
  end

  def to_json
    as_json.to_json
  end

  def created_at=( value )
    if value 
      if value.instance_of?(String)
        value = ( Time.parse(value) rescue nil )
      elsif value.respond_to?( :to_time )
        value = value.to_time
      end

      if value.respond_to?( :utc )
        @created_at = value.utc
      else
        raise NotImplementedError.new
      end
    else
      @created_at = nil 
    end
  end

  def present?
    !!is_present
  end

  def self.present?( context_result ) 
    !!(context_result && context_result.present?)
  end

  def to_s
    retval = "#<#{self.class}:0x#{result_id.to_s(16)}>[is_present=#{is_present}"
    retval << ",result=#{result}" if result
    retval << ",created_at=#{(created_at && created_at.respond_to?(:iso8601)) ? created_at.iso8601 : created_at}" if created_at
    retval << "]"
    return retval
  end
end

