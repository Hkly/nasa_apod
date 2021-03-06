require 'spec_helper'

module NasaApod

  describe Client do
    describe '#initialize' do
      let(:client) { Client.new }

      it 'api key defaults to DEMO_KEY' do
        expect(client.api_key).to eq("DEMO_KEY")
      end

      it 'list_concepts defaults to false' do
        expect(client.list_concepts).to eq(false)
      end

      it 'date defaults to a string of today' do
        expect(client.date).to eq(Date.today.to_s)
      end
    end

    describe '#search' do
      let(:client) { Client.new }

      it 'returns results' do
        results = client.search(:date => Date.today.prev_day)
        expect(results.class).to eq(NasaApod::SearchResults)
      end

      it 'changes picture when date changes' do
        results = client.search(:date => Date.today.prev_day)
        yesterdays_title = results.title
        results = client.search(:date => Date.today)
        todays_title = results.title
        expect(yesterdays_title).to_not eq(todays_title)
      end
    end

    describe '#random_post' do
      let(:client) { Client.new }

      it 'returns a random post within apod range' do
        results = client.random_post 
        expect(results.class).to eq(NasaApod::SearchResults)
        expect(Date.parse(client.date)).to be_between(Date.parse("1995-06-16"),Date.today)
      end
    end

  end

  describe SearchResults do
    describe '#initialize' do
      let(:result) { SearchResults.new(attributes) }
      let(:attributes) {{"url" =>  "test_url", 
                        "concepts" =>  ["test_concept1","test_concept2"], 
                        "media_type" =>  "JPG", 
                        "title" =>  "Test title", 
                        "explanation" => "Test explanation"}}

      it 'assigns all attributes properly' do
        attributes.keys.each do |attr|
          expect(result.send(attr)).to eq(attributes[attr])
        end
      end
    end
  end

  describe Error do
    describe '#initialize' do
      let(:result) { Error.new(error_reponse) }
      let(:error_reponse) {HTTParty.get("https://api.nasa.gov/planetary/apod")}

      it 'knows what went wrong' do
        expect(error_reponse.code).to eq(403)
      end
    end
  end



end