module SlingerDB
  class Download < RemoteModel

    set_resource_attributes({
                              :collection_name => 'downloads',
                              :per_page => 356
                            })

    def download(path = Dir.pwd)
      response = Request.get self.download_uri
      doc = Nokogiri::HTML(response.body)
      links = doc.css('a')
      href = links[0]['href']

      f = File.open(File.join(path, self.name), 'w')

      streamer = lambda do |chunk, remaining_bytes, total_bytes|
        f.write chunk
      end

      Excon.get href, :response_block => streamer, :read_timeout => 120

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