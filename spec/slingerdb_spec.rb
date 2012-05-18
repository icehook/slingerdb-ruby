require 'spec_helper'

describe SlingerDB do
  it "can log" do
    tf = Tempfile.new('output.txt')
    SlingerDB.logger = Logger.new(tf)
    SlingerDB.logger.info 'foobar'
    tf.close
    File.read(tf.path).should =~ /foobar/
  end

  it "set options" do
    options = {:api_key => 'test', :log_level => 'info'}
    SlingerDB.options = options
    SlingerDB.options[:api_key].should == options[:api_key]
    SlingerDB.options[:log_level].should == SlingerDB.defaults[:log_level]
    SlingerDB.options[:encryption_algroithm].should == SlingerDB.defaults[:encryption_algroithm]
  end

  it "set options from config" do
    config_path = File.join(File.dirname(__FILE__), 'support', 'samples', 'config.yml')
    config = YAML.load_file config_path
    SlingerDB.config = config_path
    SlingerDB.options[:api_key].should == config['api_key']
    SlingerDB.options[:log_level].should == SlingerDB.defaults[:log_level]
    SlingerDB.options[:encryption_algroithm].should == config['encryption_algroithm']
  end
end
