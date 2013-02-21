##slingerdb-ruby

Quick install -

######require date and slingerdb
    require 'date'
    require 'slingerdb'

######set up your slinger config with your api key
    SlingerDB.config = {:api_key => "#{your_api_key}"}
    include SlingerDB

######invoke the download method
    Download.all
==============

