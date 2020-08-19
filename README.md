# SoraGeocoding
[![MIT License](https://img.shields.io/apm/l/atomic-design-ui.svg?)](https://github.com/tterb/atomic-design-ui/blob/master/LICENSEs)　[![Gem Version](https://badge.fury.io/rb/sora_geocoding.svg)](https://badge.fury.io/rb/sora_geocoding) 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sora_geocoding'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sora_geocoding

## Usage

### Search

##### No options
```
SoraGeocoding.search('Tokyo')
=> {:site=>"geocoding", :data=>"<?xml version='1.0' encoding='UTF-8'?>\n<result>\n<version>1.2</version>\n<address>Tokyo</address>\n<coordinate>\n<lat>35.676192</lat>\n<lng>139.650311</lng>\n<lat_dms>35,40,34.291</lat_dms>\n<lng_dms>139,39,1.118</lng_dms>\n</coordinate>\n<open_location_code>8Q7XMMG2+F4</open_location_code>\n<url>https://www.geocoding.jp/?q=Tokyo</url>\n<needs_to_verify>no</needs_to_verify>\n<google_maps>東京都</google_maps>\n</result>\n"}
```

##### Optional
- set options
  - site: 'yahoo'
  - yahoo_app_id: 'xxxxxxxx'
    - Get the ClientId: https://developer.yahoo.co.jp/start/

```
SoraGeocoding.search('東京都', {site: 'yahoo', yahoo_appid: 'xxxxxxxx'})
=> {:site=>"yahoo", :data=>"<?xml version='1.0' encoding='UTF-8'?>\n<YDF firstResultPosition='1' totalResultsAvailable='1793198' totalResultsReturned='1' xmlns='http://olp.yahooapis.jp/ydf/1.0'><ResultInfo><Count>1</Count><Total>1793198</Total><Start>1</Start><Status>200</Status><Description/><Copyright/><Latency>0.036</Latency></ResultInfo><Feature><Id>13112</Id><Gid/><Name>東京都世田谷区</Name><Geometry><Type>point</Type><Coordinates>139.65324950,35.64657460</Coordinates><BoundingBox>139.58242700,35.59004000 139.68655700,35.68297400</BoundingBox></Geometry><Category/><Description/><Style/><Property><Uid>9b7486bd58ee135ffec334df2975f4f37690b3cf</Uid><CassetteId>b22fee69b0dcaf2c2fe2d6a27906dafc</CassetteId><Yomi>トウキョウトセタガヤク</Yomi><Country><Code>JP</Code><Name>日本</Name></Country><Address>東京都世田谷区</Address><AddressElement><Name>東京都</Name><Kana>とうきょうと</Kana><Level>prefecture</Level></AddressElement><AddressElement><Name>世田谷区</Name><Kana>せたがやく</Kana><Level>city</Level></AddressElement><GovernmentCode>13112</GovernmentCode><AddressMatchingLevel>2</AddressMatchingLevel><Approximation>0.429</Approximation><AddressType>特別区</AddressType><OpenForBusiness/><Detail><NameHiragana>とうきょうとせたがやく</NameHiragana><OldAddressFlag>false</OldAddressFlag></Detail></Property></Feature></YDF>\n<!-- xxxcache nohit 0.038, 0.001, 0.001 -->"}
```

### Coordinates

##### No options
```
SoraGeocoding.coordinates('Tokyo')
=> {:site=>"geocoding", :coordinates=>{:lat=>"35.676192", :lon=>"139.650311"}}
```

##### Optional
- set options
  - site: 'yahoo'
  - yahoo_app_id: 'xxxxxxxxx'
    - Get the ClientId: https://developer.yahoo.co.jp/start/

```
SoraGeocoding.coordinates('東京都', {site: 'yahoo', yahoo_appid: 'xxxxxxxxx'})
=> {:site=>"yahoo", :coordinates=>{:lat=>"35.64657460", :lon=>"139.65324950"}}
```

### Geohash
- Specify the latitude and longitude
```
SoraGeocoding.geohash("35.676192", "139.650311")
=> "xn76cydkbh5h"
```

### Some Options
| option       | Description                              | Default        |
|:------------:|:-----------------------------------------|:---------------|
| timeout      | timeout (secs)                           | 3              |
| http_headers | HTTP headers                             | {}             |
| use_https    | use HTTPS for requests?                  | false          |
| http_proxy   | HTTP proxy server (user:pass@host:port)  | nil            |
| https_proxy  | HTTPS proxy server (user:pass@host:port) | nil            |
| basic_auth   | user and password for basic auth ({:user => "user", :password => "password"}) | {} |
| site         | Specify 'geocoding' or 'yahoo'           | nil            |
| yahoo_appid  | API key for Yahoo Geocoder API           | nil            |
| logger_level | log level, if kernel logger is used      | ::Logger::WARN |
| always_raise | Always handle errors. ex) :all, SocketError, Timeout::Error | [] |

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

If you want to modify the source code while checking the tests, run the `bundle exec guard` in another console.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sorainc/sora_geocoding. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SoraGeocoding project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/sorainc/sora_geocoding/blob/master/CODE_OF_CONDUCT.md).

## Reference
- https://github.com/alexreisner/geocoder
- https://github.com/masuidrive/pr_geohash
