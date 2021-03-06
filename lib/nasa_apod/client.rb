module NasaApod
 
  DEFAULT_URL = 'https://api.nasa.gov/planetary/apod'
  
  class Client
    attr_reader :api_key, :date, :list_concepts

    def date=(date)
      @date = parse_date(date)
    end

    def list_concepts=(list_concepts)
      if list_concepts.nil? || list_concepts.blank?
        @list_concepts = false
      else
        @list_concepts = list_concepts
      end
    end
    
    def initialize(options={})
      @api_key = options[:api_key] || "DEMO_KEY"
      self.date = options[:date]
      self.list_concepts = options[:list_concepts]
    end

    # Returns APOD info for specified day.
    #
    # @see https://api.nasa.gov/api.html#apod
    # @rate_limited Yes https://api.nasa.gov/api.html#authentication
    # @image_permissions http://apod.nasa.gov/apod/lib/about_apod.html#srapply
    # @authentication optional NASA api key https://api.nasa.gov/index.html#apply-for-an-api-key
    # @option options [String] :api_key Optional. Uses DEMO_KEY as default.
    # @option options [String] :date Optional. Returns the APOD results for the given date. Date should be formatted as YYYY-MM-DD. Defaults as today.
    # @option options [Boolean] :concept_tags Optional. Returns an array of concept tags if available. Defaults to False.
    # @return [NasaApod::SearchResults] Return APOD post for a specified date.
    def search(options={})
      self.date = options[:date] || date
      @list_concepts = options[:list_concepts] || list_concepts
      response = HTTParty.get("https://api.nasa.gov/planetary/apod?api_key=#{api_key}&date=#{date}&concept_tags=#{list_concepts}")
      handle_response(response)
    end

    def random_post(options={})
      date = rand(Date.parse("1995-06-16")..Date.today)
      search(:date => date)
    end

    alias_method :wormhole, :random_post

    private

    def handle_response(response)
      if response["error"].nil?
        NasaApod::SearchResults.new(response)
      else
        NasaApod::Error.new(response)
      end
    end

    def write_attrs(attributes)
      @concepts = attributes["concepts"]
      @url = attributes["url"]
      @media_type = attributes["media_type"]
      @explanation = attributes["explanation"] 
      @title = attributes["title"]
    end

    def parse_date(date)
      if date.is_a?(Time)
        date.strftime("%Y-%m-%d")
      elsif date.is_a?(Date)
        date.to_s
      elsif date.is_a?(String)
        date
      else
        Date.today.to_s
      end
    end
  end
  
end
