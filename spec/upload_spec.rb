require 'spec_helper'

describe Upload do
  it "can be instantiated" do
    Upload.new.should be_an_instance_of(Upload)
  end
end
