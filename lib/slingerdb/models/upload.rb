module SlingerDB
  class Upload < RemoteModel

    set_resource_attributes({
                              :collection_name => 'uploads',
                              :per_page => 10
                            })

    def to_file
      request = SlingerDB::Request.new :get_file, self.download_uri.path
      tf = request.send
      SlingerDB.logger.info Utils.gunzip tf
    end

  end
end
