module SlingerDB
  module Utils
    class << self
      def gunzip(io)
        gz = Zlib::GzipReader.new(io)
        gz.read
      end

      def create_tempfile(base = 'tempfile', extension = '', directory = '/tmp')
        Tempfile.new [base, extension], directory
      end
    end
  end
end