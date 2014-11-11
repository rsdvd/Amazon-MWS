#!perl

use strict;
use warnings;
use utf8;
use Amazon::MWS::XML::Product;
use Amazon::MWS::XML::Feed;
use Test::More;

# testing requires a directory with the schema

if (-d 'schemas') {
    plan tests => 8;
}
else {
    plan skip_all => q{Missing "schemas" directory with the xsd from Amazon, skipping feeds tests};
}

my @products;
foreach my $product ({
                      sku => '1234',
                      ean => '1234123412343',
                      brand => 'blabla',
                      title => 'title',
                      price => '10.00',
                      description => 'my desc',
                      images => [ 'http://example.org/pippo.jpg' ],
                      category_code => '111111',
                      category => 'CE',
                      subcategory => 'PhoneAccessory',
                      manufacturer_part_number => '1234123412343',
                      condition => 'Refurbished',
                      condition_note => 'Looks like new',
                      inventory => -1,
                      search_terms => [qw/a b c d e f g/],
                      features => [qw/f1 f2 f3/, '',  qw/f4 f5 f6 f7/],
                      shipping_weight => 300,
                      package_weight => 290,
                     },
                     {
                      sku => '3333',
                      ean => '4444123412343',
                      brand => 'brand',
                      title => 'title2',
                      price => '12.00',
                      description => 'my desc 2',
                      images => [ 'http://example.org/pluto.jpg' ],
                      category_code => '111111',
                      category => 'CE',
                      subcategory => 'PhoneAccessory',
                      manufacturer_part_number => '4444123412343',
                      inventory => 2,
                      shipping_weight => 0,
                      package_weight => 0,
                     }) {
    push @products, Amazon::MWS::XML::Product->new(%$product);
}


my $feeder = Amazon::MWS::XML::Feed->new(
                                         products => \@products,
                                         schema_dir => 'schemas',
                                         merchant_id => '__MERCHANT_ID__',
                                        );

my $exp_product_feed = <<'XML';
<?xml version="1.0" encoding="UTF-8"?>
<AmazonEnvelope>
  <Header>
    <DocumentVersion>1.1</DocumentVersion>
    <MerchantIdentifier>__MERCHANT_ID__</MerchantIdentifier>
  </Header>
  <MessageType>Product</MessageType>
  <Message>
    <MessageID>1</MessageID>
    <OperationType>Update</OperationType>
    <Product>
      <SKU>1234</SKU>
      <StandardProductID>
        <Type>EAN</Type>
        <Value>1234123412343</Value>
      </StandardProductID>
      <Condition>
        <ConditionType>Refurbished</ConditionType>
        <ConditionNote>Looks like new</ConditionNote>
      </Condition>
      <DescriptionData>
        <Title>title</Title>
        <Brand>blabla</Brand>
        <Description>my desc</Description>
        <BulletPoint>f1</BulletPoint>
        <BulletPoint>f2</BulletPoint>
        <BulletPoint>f3</BulletPoint>
        <BulletPoint>f4</BulletPoint>
        <BulletPoint>f5</BulletPoint>
        <PackageWeight unitOfMeasure="GR">290</PackageWeight>
        <ShippingWeight unitOfMeasure="GR">300</ShippingWeight>
        <MfrPartNumber>1234123412343</MfrPartNumber>
        <SearchTerms>a</SearchTerms>
        <SearchTerms>b</SearchTerms>
        <SearchTerms>c</SearchTerms>
        <SearchTerms>d</SearchTerms>
        <SearchTerms>e</SearchTerms>
        <RecommendedBrowseNode>111111</RecommendedBrowseNode>
      </DescriptionData>
      <ProductData>
        <CE>
          <ProductType>
            <PhoneAccessory/>
          </ProductType>
        </CE>
      </ProductData>
    </Product>
  </Message>
  <Message>
    <MessageID>2</MessageID>
    <OperationType>Update</OperationType>
    <Product>
      <SKU>3333</SKU>
      <StandardProductID>
        <Type>EAN</Type>
        <Value>4444123412343</Value>
      </StandardProductID>
      <Condition>
        <ConditionType>New</ConditionType>
      </Condition>
      <DescriptionData>
        <Title>title2</Title>
        <Brand>brand</Brand>
        <Description>my desc 2</Description>
        <MfrPartNumber>4444123412343</MfrPartNumber>
        <RecommendedBrowseNode>111111</RecommendedBrowseNode>
      </DescriptionData>
      <ProductData>
        <CE>
          <ProductType>
            <PhoneAccessory/>
          </ProductType>
        </CE>
      </ProductData>
    </Product>
  </Message>
</AmazonEnvelope>
XML

my $exp_inventory_feed = <<'XML';
<?xml version="1.0" encoding="UTF-8"?>
<AmazonEnvelope>
  <Header>
    <DocumentVersion>1.1</DocumentVersion>
    <MerchantIdentifier>__MERCHANT_ID__</MerchantIdentifier>
  </Header>
  <MessageType>Inventory</MessageType>
  <Message>
    <MessageID>1</MessageID>
    <OperationType>Update</OperationType>
    <Inventory>
      <SKU>1234</SKU>
      <Quantity>0</Quantity>
      <FulfillmentLatency>2</FulfillmentLatency>
    </Inventory>
  </Message>
  <Message>
    <MessageID>2</MessageID>
    <OperationType>Update</OperationType>
    <Inventory>
      <SKU>3333</SKU>
      <Quantity>2</Quantity>
      <FulfillmentLatency>2</FulfillmentLatency>
    </Inventory>
  </Message>
</AmazonEnvelope>
XML

my $exp_price_feed = <<'XML';
<?xml version="1.0" encoding="UTF-8"?>
<AmazonEnvelope>
  <Header>
    <DocumentVersion>1.1</DocumentVersion>
    <MerchantIdentifier>__MERCHANT_ID__</MerchantIdentifier>
  </Header>
  <MessageType>Price</MessageType>
  <Message>
    <MessageID>1</MessageID>
    <OperationType>Update</OperationType>
    <Price>
      <SKU>1234</SKU>
      <StandardPrice currency="EUR">10.00</StandardPrice>
    </Price>
  </Message>
  <Message>
    <MessageID>2</MessageID>
    <OperationType>Update</OperationType>
    <Price>
      <SKU>3333</SKU>
      <StandardPrice currency="EUR">12.00</StandardPrice>
    </Price>
  </Message>
</AmazonEnvelope>
XML

my $exp_image_feed = <<'XML';
<?xml version="1.0" encoding="UTF-8"?>
<AmazonEnvelope>
  <Header>
    <DocumentVersion>1.1</DocumentVersion>
    <MerchantIdentifier>__MERCHANT_ID__</MerchantIdentifier>
  </Header>
  <MessageType>ProductImage</MessageType>
  <Message>
    <MessageID>1</MessageID>
    <OperationType>Update</OperationType>
    <ProductImage>
      <SKU>1234</SKU>
      <ImageType>Main</ImageType>
      <ImageLocation>http://example.org/pippo.jpg</ImageLocation>
    </ProductImage>
  </Message>
  <Message>
    <MessageID>2</MessageID>
    <OperationType>Update</OperationType>
    <ProductImage>
      <SKU>3333</SKU>
      <ImageType>Main</ImageType>
      <ImageLocation>http://example.org/pluto.jpg</ImageLocation>
    </ProductImage>
  </Message>
</AmazonEnvelope>
XML

my $exp_variants_feed;

is ($feeder->product_feed, $exp_product_feed, "product feed ok");
is ($feeder->inventory_feed, $exp_inventory_feed, "inventory feed ok");
is ($feeder->price_feed, $exp_price_feed, "price feed ok");
is ($feeder->image_feed, $exp_image_feed, "image feed ok");
is ($feeder->variants_feed, $exp_variants_feed, "variants feed ok (undef)");




my $test = Amazon::MWS::XML::Product->new(sku => '12345',
                                          ean => '4444123412343',
                                          condition => 'UsedAcceptable');

is $test->condition, 'UsedAcceptable';
is $test->condition_type_for_lowest_price_listing, 'Used';


eval { $test = Amazon::MWS::XML::Product->new(
                                              sku => '3333',
                                              ean => '4444123412343',
                                              brand => 'brand',
                                              title => 'title2',
                                              price => '12.00',
                                              description => 'my desc 2',
                                              images => [ 'http://example.org/pluto.jpg' ],
                                              category_code => '111111',
                                              category => 'CE',
                                              subcategory => 'PhoneAccessory',
                                              manufacturer_part_number => '4444123412343',
                                              inventory => 2,
                                              condition => 'blablabla',
                                              ); };

like $@, qr/condition/, "Found exception for garbage in condition";
