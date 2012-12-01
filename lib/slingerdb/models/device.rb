module SlingerDB
  class Device < RemoteModel

    set_resource_attributes({
                              :collection_name => 'devices'
                            })

    def create_downloads(start_date, end_date)
      Download.create! self.id, start_date, end_date
    end

  end
end