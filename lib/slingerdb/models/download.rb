module SlingerDB
  class Download < RemoteModel

    set_resource_attributes({
                              :collection_name => 'downloads',
                              :per_page => 356
                            })

    def download
      f = File.open(self.name, 'w')

      streamer = lambda do |chunk, remaining_bytes, total_bytes|
        f.write chunk
      end

      Excon.get "#{self.download_uri}?auth_token=#{SlingerDB.config.api_key}", :response_block => streamer

      f.close
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