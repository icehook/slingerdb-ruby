# slingerdb-ruby

## Quick install -

###### Require date and slingerdb
````ruby
    require 'date'
    require 'slingerdb'
````

###### Set up your slinger config with your api key
````ruby
    SlingerDB.config = {:api_key => "#{your_api_key}"}
    include SlingerDB
````

###### Invoke the download method. This will download everything to your current working dir (Dir.pwd)
````ruby
    Download.all
````


## Sample API response
````ruby
    #<SlingerDB::Download id=40763, user_id=670, device_id=246, name="Cookie Demo_2011_10_19.csv.gz", status="complete", prefix="device_246/2011/10/19/", cdr_count=1, share_key="bn1wczaemg5uei04ewds7so0zo7vurit4ea1ytl4", download_uri="https://slinger.icehook.com/downloads/40763/download", created_at="2013-02-20T21:50:37Z", updated_at="2013-02-20T21:50:45Z">
````

## "Download" class methods

###### Download all files to local dir
````ruby
    Download.all
````

###### Check the status of the download to make sure it's complete
````ruby
    downloads = Download.all
    downloads.each do |download|
        if download.complete?
           download.download
        end
    end
````

###### Define download path
````ruby
    path = '/PathToFolder'
    downloads = Download.all
    downloads.each do |download|
        if download.complete?
            download.download(path)
        end
    end
````


### Devices
###### Get all devices
````ruby
    Device.all
````
###### Get a specific device
````ruby
    Device.find(<device_id>)
````

### Call Detail Records
###### Create a CDR Download
````ruby
    Download.create!(<device_id>, Date.new(2012, 05, 16), Date.new(2012, 05, 16))
    # or
    Device.find(222).create_downloads(Date.new(2012, 05, 16), Date.new(2012, 05, 16))
````

### Downloads
###### Get all downloads
````ruby
    Download.all
````
###### Delete  download
````ruby
    downloads = Download.all
    x = downloads.first
    x.destroy!
````
