require "spec_helper"
require "timecop"
require 'active_support/core_ext/time'
require "pry"

describe ContextNormalized do
  it "handles a one to many from raw to normalized" do 
    context_normalized = ContextNormalized.new( raw: "Your vacation requires a confirmed flight and a rental car.")
    context_normalized.add( data: "confirmed rental car required", corresponds_to: :ground_transport)
    context_normalized.add( data: "confirmed flight required", corresponds_to: :air_transport)
    expect(context_normalized.length).to eq(2)
    expect(context_normalized.to_json).to eq("[{\"data\":\"confirmed rental car required\",\"corresponds_to\":\"ground_transport\"},{\"data\":\"confirmed flight required\",\"corresponds_to\":\"air_transport\"}]")
  end
end
