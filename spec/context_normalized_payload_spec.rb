require "spec_helper"
require "timecop"
require 'active_support/core_ext/time'
require "pry"

describe ContextNormalizedPayload do
  describe "Constructor" do 
    context "when passing in a hash that has a \"data\" attribute" do
      it "sets the data attribute appropriately" do 
        context_normalized_payload = ContextNormalizedPayload.new( {data: "this is my data"} )
        expect(context_normalized_payload.data).to eq("this is my data")
        context_normalized_payload = ContextNormalizedPayload.new( { "data" => "this is also my data"} )
        expect(context_normalized_payload.data).to eq("this is also my data")
      end
    end

    context "when passing anything else" do
      it "sets the data attribute is inferred" do 
        context_normalized_payload = ContextNormalizedPayload.new( "this is my data" )
        expect(context_normalized_payload.data).to eq("this is my data")
        context_normalized_payload = ContextNormalizedPayload.new( 10 )
        expect(context_normalized_payload.data).to eq(10)
        context_normalized_payload = ContextNormalizedPayload.new( { something_other_than_data: true } )
        expect(context_normalized_payload.data).to eq({ something_other_than_data: true })
      end
    end    
  end
end

