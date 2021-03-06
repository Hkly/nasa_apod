# NasaApod

A Ruby gem for consuming the NASA Astronomy Picture of the Day API. 

## Installation

Add this line to your application's Gemfile:

    gem 'nasa_apod'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nasa_apod

## Usage

Search by date:
```
client = NasaApod::Client.new(api_key: "DEMO_KEY") #DEMO_KEY usage is limited.
result = client.search(date: "2015-06-18") #You can also pass in a Ruby Date object. 
result
```

Random post:
```
result = client.wormhole #can optionally pass in list_concepts: true for concept tags.
result
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/nasa_apod/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
