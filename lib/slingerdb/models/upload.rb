module SlingerDB
  class Upload < RemoteModel

    set_resource_attributes({
                              :collection_name => 'uploads',
                              :per_page => 200
                            })

    def to_file
      request = Adapter::Request.new :get_file, self.download_uri.path
      tf = request.send
      SlingerDB.logger.info Utils.gunzip tf
    end

  end
end
