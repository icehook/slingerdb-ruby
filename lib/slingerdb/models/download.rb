module SlingerDB
  class Download < RemoteModel

    set_resource_attributes({
                              :collection_name => 'downloads',
                              :per_page => 356
                            })

    def download
      File.open(self.name, 'wb') { |fp| fp.write(Request.get(self.download_uri).body) } if self.complete?
    end

    def complete?
      self.status == 'complete'
    end

    def self.create!(device_id, start_date, end_date)
      response = Request.post '/call_detail_records/download_or_destroy.json',
                              {
                                'download' => {'device_id' => device_id},
                                'start-date-month' => start_date.month,
                                'start-date-day' => start_date.day,
                                'start-date-year' => start_date.year,
                                'end-date-month' => end_date.month,
                                'end-date-day' => end_date.day,
                                'end-date-year' => end_date.year,
                                'new_search_boolean_operator' => '',
                                'create_downloads_button' => 'Create Downloads'
                              }

      if response.status == 302
        Download.all
      else
        raise SlingerDBException.new
      end
    end

  end
end