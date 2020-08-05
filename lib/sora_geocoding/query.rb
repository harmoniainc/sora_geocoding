module SoraGeocoding
  class Query < Base
    attr_accessor :query, :opts, :url, :req

    def initialize(query, options = {})
      self.query = query
      self.opts = configure(options)
      self.url = SoraGeocoding::Url.new(query)
      self.req = SoraGeocoding::Request.new
    end

    def to_s
      query
    end

    def configure(func_opts)
      SoraGeocoding.configure(func_opts)
    end

    def execute
      data = req.fetch_data(url.get)
      SoraGeocoding.log(:error, "The data could not be retrieved from #{url.site}") if data.nil?

      {
        site: url.site,
        data: data.to_s
      }
    rescue StandardError
      if url.site == 'yahoo'
        initialize_geocoding
        retry
      end
      SoraGeocoding.log(:warn, 'The information could not be retrieved. Please change your address.')
    end

    private
      def initialize_geocoding
        opts[:site] = 'geocoding'
        initialize(query, opts)
      end
  end
end
