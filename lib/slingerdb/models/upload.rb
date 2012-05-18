module SlingerDB
  class Upload < Model

    set_resource_path 'uploads.json'
    set_resource_name 'uploads'

    has_attribute :id, Integer
    has_attribute :status, String
    has_attribute :filename, String
    has_attribute :cdr_count, Integer
    has_attribute :checksum, String
    has_attribute :failed_count, Integer
    has_attribute :download_uri, URI
    has_attribute :first_record_at, DateTime
    has_attribute :last_record_at, DateTime
    has_attribute :created_at, DateTime
    has_attribute :reports, Array

    def to_file
      request = Adapter::Request.new :get_file, self.download_uri.path
      request.send
    end

  end
end
