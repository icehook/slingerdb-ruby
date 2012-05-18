require 'spec_helper'

describe Utils do
  it "can gunzip a file" do
    path = File.join(File.dirname(__FILE__), 'support', 'samples', 'test.txt.gz')
    f = File.open path
    s = Utils.gunzip f
    s.should == "foo\nbar"
  end

  it "can create a tempfile" do
    tf = Utils.create_tempfile 'test_', '.txt', '/tmp'
    tf.should be_a_kind_of File
    File.dirname(tf).should == '/tmp'
  end
end
