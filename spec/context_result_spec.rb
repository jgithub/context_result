require "spec_helper"
require "timecop"
require 'active_support/core_ext/time'
require "pry"

describe ContextResult do
  describe "Constructor" do 
    it "accepts and handles result and is_present attributes" do 
      context_result = ContextResult.new( result: 7, is_present: true )
      expect( context_result.result ).to eq(7)
      expect( context_result.is_present ).to eq(true)

      context_result = ContextResult.new( result: Date.new(2001,2,3), is_present: false )
      expect( context_result.result ).to eq(Date.new(2001,2,3))
      expect( context_result.is_present ).to eq(false)

      context_result = ContextResult.new( result: "my string" )
      expect( context_result.result ).to eq("my string")
      expect( context_result.is_present ).to be_falsy
    end

    it "also works with strings as the attributes" do 
      context_result = ContextResult.new( "result" => Date.new(2001,2,3), "is_present" => false )
      expect( context_result.result ).to eq(Date.new(2001,2,3))
      expect( context_result.is_present ).to eq(false)
    end

    it "accepts and handles a plain object as a parameter" do 
      context_result = ContextResult.new( 12 )
      expect( context_result.result ).to eq(12)
      expect( context_result.is_present ).to eq(true)
    end    

    it "leaves the created_at attribute unset(nil) by default" do 
      context_result = ContextResult.new
      expect( context_result.created_at ).to be_nil
    end

    it "works as expected with a nil result and being present" do 
      context_result = ContextResult.new( result: nil, is_present: true )
      expect( context_result.result ).to eq(nil)
      expect( context_result.is_present ).to eq(true)
    end
  end

  describe ".present_instance" do 
    it "creates a \"present\" ContextResult object" do
      context_result = ContextResult.present_instance
      expect( context_result.is_present ).to eq(true)
    end

    it "handles a single object parameter" do
      context_result = ContextResult.present_instance(17)
      expect( context_result.result ).to eq(17)
      expect( context_result.is_present ).to eq(true)
    end    
  end

  describe ".present?" do 
    it "is is a boolean that follows the value of is_present" do 
      context_result = ContextResult.new
      expect( context_result.is_present ).to eq(nil)
      expect( context_result.present? ).to eq(false)    
      context_result.is_present = true       
      expect( context_result.is_present ).to eq(true)
      expect( context_result.present? ).to eq(true)    
      context_result.is_present = false       
      expect( context_result.is_present ).to eq(false)
      expect( context_result.present? ).to eq(false)  
    end
  end

  describe "#mark_created_right_now" do
    it "populates the created_at value with the current UTC time" do 
      Timecop.freeze(Time.utc(2014, 11, 1, 15, 5, 0))
      context_result = ContextResult.new
      context_result.mark_created_right_now
      expect( context_result.created_at ).to eq(Time.utc(2014, 11, 1, 15, 5, 0))
    end
  end

  describe "#created_at=" do
    it "converts specified Time values as UTC" do 
      Timecop.freeze(Time.utc(2014, 11, 1, 15, 5, 0))
      context_result = ContextResult.new
      local_time = Time.now.in_time_zone('Pacific Time (US & Canada)')
      expect( local_time.utc? ).to eq(false)
      context_result.created_at = local_time
      expect( context_result.created_at ).to eq(Time.utc(2014, 11, 1, 15, 5, 0))
      expect( context_result.created_at.utc? ).to eq(true)
    end

    it "converts specified DateTime values as UTC" do 
      context_result = ContextResult.new
      local_date_time = DateTime.new(2001,2,3,4,5,6,'+7')
      expect( local_date_time.utc? ).to eq(false)
      context_result.created_at = local_date_time
      expect( context_result.created_at ).to eq(Time.utc(2001, 2, 2, 21, 5, 6))
      expect( context_result.created_at.utc? ).to eq(true)
    end    

    it "can be set to nil" do 
      context_result = ContextResult.new
      context_result.mark_created_right_now
      expect(context_result.created_at).not_to eq(nil)
      context_result.created_at = nil
      expect(context_result.created_at).to eq(nil)
    end

    it "handles iso8601 strings" do 
      context_result = ContextResult.new
      context_result.created_at = "2014-11-01T15:10:00Z"
      expect( context_result.created_at ).to eq(Time.utc(2014, 11, 1, 15, 10, 0))         
    end    
  end  

  describe "Older-than and Younger-than calculations" do 
    context "for a sampling of real-world conditions" do
      it "returns the expected values" do 
        Timecop.freeze(Time.utc(2014, 11, 1, 15, 5, 0, 0))

        context_result = ContextResult.new
        context_result.mark_created_right_now
        expect(context_result.older_than_number_of_seconds?( 200 )).to eq(false)
        expect(context_result.younger_than_number_of_seconds?( 200 )).to eq(true)
        Timecop.freeze( Time.now.utc + 300 )

        expect( Time.now.utc ).to eq(Time.utc(2014, 11, 1, 15, 10, 0))
        
        expect(context_result.older_than_number_of_seconds?( 200 )).to eq(true)
        expect(context_result.younger_than_number_of_seconds?( 200 )).to eq(false)
      end
    end
  end 

  describe "#as_json" do 
    it "returns the expected JSON format" do 
      context_result = ContextResult.present_and_created_instance(17)
      expect(context_result.as_json).to eq({"result"=>17, "is_present"=>true, "created_at"=>"2014-11-01T15:10:00Z"})
    end
  end

  describe "#to_json" do 
    it "returns the expected JSON string" do 
      context_result = ContextResult.present_and_created_instance(17)
      expect(context_result.to_json).to eq("{\"result\":17,\"is_present\":true,\"created_at\":\"2014-11-01T15:10:00Z\"}")
      context_result.result = 23.9999999999
      expect(context_result.to_json).to eq("{\"result\":23.9999999999,\"is_present\":true,\"created_at\":\"2014-11-01T15:10:00Z\"}")
      context_result.result = ['a', 'b', 1, 34]
      expect(context_result.to_json).to eq("{\"result\":[\"a\",\"b\",1,34],\"is_present\":true,\"created_at\":\"2014-11-01T15:10:00Z\"}")
    end
  end

  describe "Serialization/Deserialization" do 
    context "via Marshal" do
      it "can be serialized and deserialized" do
        Timecop.freeze(Time.utc(2014, 11, 1, 15, 5, 0, 0))
        context_result = ContextResult.present_and_created_instance(17)
        expect( context_result.result ).to eq(17)
        expect( context_result.is_present ).to eq(true)   
        expect( context_result.created_at ).to eq(Time.utc(2014, 11, 1, 15, 5, 0))    
        serialized = Marshal.dump( context_result )
        context_result = Marshal.load(serialized)
        expect( context_result ).to be_instance_of( ContextResult )
        expect( context_result.result ).to eq(17)
        expect( context_result.is_present ).to eq(true)   
        expect( context_result.created_at ).to eq(Time.utc(2014, 11, 1, 15, 5, 0))         
      end
    end

    context "via JSON" do
      it "can be serialized and deserialized" do
        Timecop.freeze(Time.utc(2014, 11, 1, 15, 5, 0, 0))
        context_result = ContextResult.present_and_created_instance(17)
        expect( context_result.result ).to eq(17)
        expect( context_result.is_present ).to eq(true)   
        expect( context_result.created_at ).to eq(Time.utc(2014, 11, 1, 15, 5, 0))    
        serialized = context_result.to_json
        context_result = ContextResult.new( JSON.parse(serialized) )
        expect( context_result ).to be_instance_of( ContextResult )
        expect( context_result.result ).to eq(17)
        expect( context_result.is_present ).to eq(true)   
        expect( context_result.created_at ).to eq(Time.utc(2014, 11, 1, 15, 5, 0))         
      end
    end    
  end 
end
