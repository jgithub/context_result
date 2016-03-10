ass ContextResult
  LOGGER = Catamaran.logger.vayor.app.utils.ContextResult

  attr_accessor :object
  attr_accessor :is_present

  # Always based on UTC Time
  attr_accessor :created_at

  def self.present_instance( attributes = nil )
    if attributes && attributes.respond_to(:keys)
      context_result = new(attributes)
    else
      context_result = new 
      context_result.object = attributes
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
    attributes && attributes.respond_to?(:each) && attributes.each do |name, value|
      send("#{name}=", value) if respond_to? name.to_sym 
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

    LOGGER.debug("ContextResult is #{retval ? 'OLDER' : 'NOT older'} than #{number_of_seconds} seconds: #{self}") if LOGGER.debug?
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

    LOGGER.debug("ContextResult is #{retval ? 'YOUNGER' : 'NOT younger'} than #{number_of_seconds} seconds: #{self}") if LOGGER.debug?
    return retval
  end

  def present?
    !!is_present
  end

  def self.present?( context_result ) 
    !!(context_result && context_result.present?)
  end

  def to_s
    retval = "#<#{self.class}:0x#{object_id.to_s(16)}>[is_present=#{is_present}"
    retval << ",object=#{object}" if object
    retval << ",created_at=#{(created_at && created_at.respond_to?(:iso8601)) ? created_at.iso8601 : created_at}" if created_at
    retval << "]"
    return retval
  end
end

