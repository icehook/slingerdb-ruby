module SlingerDB
  module Utils
    include Hirb::Console

    def gunzip(io)
      gz = Zlib::GzipReader.new(io)
      gz.read
    end

    def create_tempfile(base = 'tempfile', extension = '', directory = '/tmp')
      Tempfile.new [base, extension], directory
    end

    def to_table(o)
      table o
    end

    def encryptor
      Encryptor
    end

  end
end