require 'webmock/rspec'

module MockHttpResponse
  class Geocoding
    def success(query)
      %W[
        <?xml version='1.0' encoding='UTF-8'?>
        <result>
        <version>1.2</version>
        <address>#{query}</address>
        <coordinate>
        <lat>33.333333</lat>
        <lng>133.333333</lng>
        <lat_dms>33,33,33.333</lat_dms>
        <lng_dms>133,33,3.333</lng_dms>
        </coordinate>
        <open_location_code>location_code</open_location_code>
        <url>https://www.geocoding.jp/?q=#{query}</url>
        <needs_to_verify>no</needs_to_verify>
        <google_maps>#{query}</google_maps>
        </result>
      ].join("\n")
    end

    def error
      %W[
        <?xml version='1.0' encoding='UTF-8'?>
        <result>
        <error>Error Message</error>
        </result>
      ].join("\n")
    end
  end

  class YahooGeocoder
    def success(query)
      %W[
        <?xml version='1.0' encoding='UTF-8'?>
        <YDF firstResultPosition='1' totalResultsAvailable='1' totalResultsReturned='1' xmlns='http://olp.yahooapis.jp/ydf/1.0'>
        <ResultInfo>
        <Count>1</Count>
        <Total>1</Total>
        <Start>1</Start>
        <Status>200</Status>
        <Latency>0.02</Latency>
        </ResultInfo>
        <Feature>
        <Name>#{query}</Name>
        <Geometry>
        <Type>point</Type>
        <Coordinates>133.33333333,33.33333333</Coordinates>
        <BoundingBox>133.33333333,33.33333333\ 133.33333333,33.333333333</BoundingBox>
        </Geometry>
        <Property>
        <Uid>aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa</Uid>
        <CassetteId>aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa</CassetteId>
        <Yomi>#{query}</Yomi>
        <Country>
        <Code>#{query}</Code>
        <Name>#{query}</Name>
        </Country>
        <Address>#{query}</Address>
        <AddressElement>
        <Name>#{query}</Name>
        <Level>prefecture</Level>
        </AddressElement>
        <Level>oaza</Level>
        <GovernmentCode>13101</GovernmentCode>
        <AddressMatchingLevel>3</AddressMatchingLevel>
        <Approximation>0.6</Approximation>
        <AddressType>町・大字</AddressType>
        </Property></Feature>
        </YDF>
      ].join("\n")
    end

    def error
      %W[
        <?xml version='1.0' encoding='UTF-8'?>
        <Error>
        <Message>Error Message</Message>
        <Code>000</Code>
        </Error>
      ].join("\n")
    end

    def zero_result
      %W[
        <?xml version='1.0' encoding='UTF-8'?>
        <YDF firstResultPosition='1' totalResultsAvailable='0' totalResultsReturned='0' xmlns='http://olp.yahooapis.jp/ydf/1.0'>
        </YDF>
      ].join("\n")
    end
  end
end
