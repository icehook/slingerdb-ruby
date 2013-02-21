#slingerdb-ruby

##Quick install -

######Require date and slingerdb
    require 'date'
    require 'slingerdb'

######Set up your slinger config with your api key
    SlingerDB.config = {:api_key => "#{your_api_key}"}
    include SlingerDB

######Invoke the download method. This will download everything to your current working dir (Dir.pwd)
    Download.all

###Devices

####Get all devices
````ruby
    Device.all
````

###Call Detail Records

####Create a CDR Download
````ruby
    Download.create!(<device_id>, Date.new(2012, 05, 16), Date.new(2012, 05, 16))
````

###Downloads

####Get all downlaods
````ruby
    Download.all
````

==============

##Sample API request

<pre><code>id=40763, user_id=670, device_id=246, name="Cookie Demo_2011_10_19.csv.gz", status="complete", prefix="device_246/2011/10/19/", cdr_count=1, share_key="bn1wczaemg5uei04ewds7so0zo7vurit4ea1ytl4", download_uri="https://slinger.icehook.com/downloads/40763/download", created_at="2013-02-20T21:50:37Z", updated_at="2013-02-20T21:50:45Z"</pre></code>

##"Download" class methods

######Download all files to local dir
    Download.all
    
######Check the status of the download to make sure it's complete
    downloads = Download.all
    downloads.each do |download|
        if download.complete?
           download.download
        end

######Define download path
    path = '/PathToFolder'
    downloads = Download.all
    downloads.each do |download|
        if download.complete?
            download.download(path)
        end
