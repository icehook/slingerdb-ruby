$:.push File.join(File.dirname(__FILE__), '../lib')
require 'slingerdb'
require 'pp'

SlingerDB.config = {:api_key => 'SbYZCrQntvUaCcsKq2Sx'}
include SlingerDB

path = './cdrs'

downloads = Download.all({}, {:per_page => 1})