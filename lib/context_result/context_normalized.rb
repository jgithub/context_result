require 'context_result/context_normalized_payload'

class ContextNormalized
  attr_accessor :raw 

  def initialize( attributes = nil )
    attributes && attributes.each do |name, value|
      send("#{name}=", value) if respond_to? name.to_sym 
    end 

    @context_normalized_payload = []
  end  

  # Return normalized JSON array
  def as_json
    retval = []
    @context_normalized_payload.each do |context_normalized_payload|
      retval << context_normalized_payload.as_json
    end

    return retval
  end

  def to_json
    as_json.to_json
  end

  def any?
    length > 0 ? true : false
  end

  def first
    @context_normalized_payload.first
  end

  def add( payload )
    if payload.nil? || payload.kind_of?( ContextNormalizedPayload )
      @context_normalized_payload << payload
    else
      @context_normalized_payload << ContextNormalizedPayload.new( payload )
    end
  end

  def each( &block )
    @context_normalized_payload.each_with_index do |context_normalized_payload|
      yield( context_normalized_payload )
    end
  end

  def length
    @context_normalized_payload.length
  end
end
