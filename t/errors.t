#!perl

use strict;
use warnings;
use Amazon::MWS::XML::Response::FeedSubmissionResult;
use Data::Dumper;
use Test::More;

if (-d 'schemas') {
    plan tests => 16;
}
else {
    plan skip_all => q{Missing "schemas" directory with the xsd from Amazon, skipping feeds tests};
}


my $xml = <<'XML';
<AmazonEnvelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="amzn-envelope.xsd">
        <Header>
                <DocumentVersion>1.02</DocumentVersion>
                <MerchantIdentifier>_MERCHANT_ID_</MerchantIdentifier>
        </Header>
        <MessageType>ProcessingReport</MessageType>
        <Message>
                <MessageID>1</MessageID>
                <ProcessingReport>
                        <DocumentTransactionID>123412341234</DocumentTransactionID>
                        <StatusCode>Complete</StatusCode>
                        <ProcessingSummary>
                                <MessagesProcessed>7</MessagesProcessed>
                                <MessagesSuccessful>1</MessagesSuccessful>
                                <MessagesWithError>6</MessagesWithError>
                                <MessagesWithWarning>0</MessagesWithWarning>
                        </ProcessingSummary>
                        <Result>
                                <MessageID>1</MessageID>
                                <ResultCode>Error</ResultCode>
                                <ResultMessageCode>6024</ResultMessageCode>
                                <ResultDescription>Seller is not authorized to list products by this brand name in this product line or category. For more details, see http://sellercentral.amazon.de/gp/errorcode/6024</ResultDescription>
                                <AdditionalInfo>
                                        <SKU>16414</SKU>
                                </AdditionalInfo>
                        </Result>
                        <Result>
                                <MessageID>2</MessageID>
                                <ResultCode>Error</ResultCode>
                                <ResultMessageCode>6024</ResultMessageCode>
                                <ResultDescription>Seller is not authorized to list products by this brand name in this product line or category. For more details, see http://sellercentral.amazon.de/gp/errorcode/6024</ResultDescription>
                                <AdditionalInfo>
                                        <SKU>12110</SKU>
                                </AdditionalInfo>
                        </Result>
                        <Result>
                                <MessageID>3</MessageID>
                                <ResultCode>Error</ResultCode>
                                <ResultMessageCode>6024</ResultMessageCode>
                                <ResultDescription>Seller is not authorized to list products by this brand name in this product line or category. For more details, see http://sellercentral.amazon.de/gp/errorcode/6024</ResultDescription>
                                <AdditionalInfo>
                                        <SKU>12112</SKU>
                                </AdditionalInfo>
                        </Result>
                        <Result>
                                <MessageID>4</MessageID>
                                <ResultCode>Error</ResultCode>
                                <ResultMessageCode>6024</ResultMessageCode>
                                <ResultDescription>Seller is not authorized to list products by this brand name in this product line or category. For more details, see http://sellercentral.amazon.de/gp/errorcode/6024</ResultDescription>
                                <AdditionalInfo>
                                        <SKU>14742</SKU>
                                </AdditionalInfo>
                        </Result>
                        <Result>
                                <MessageID>6</MessageID>
                                <ResultCode>Error</ResultCode>
                                <ResultMessageCode>6024</ResultMessageCode>
                                <ResultDescription>Seller is not authorized to list products by this brand name in this product line or category. For more details, see http://sellercentral.amazon.de/gp/errorcode/6024</ResultDescription>
                                <AdditionalInfo>
                                        <SKU>12194</SKU>
                                </AdditionalInfo>
                        </Result>
                        <Result>
                                <MessageID>7</MessageID>
                                <ResultCode>Error</ResultCode>
                                <ResultMessageCode>6024</ResultMessageCode>
                                <ResultDescription>Seller is not authorized to list products by this brand name in this product line or category. For more details, see http://sellercentral.amazon.de/gp/errorcode/6024</ResultDescription>
                                <AdditionalInfo>
                                        <SKU>16415</SKU>
                                </AdditionalInfo>
                        </Result>
                </ProcessingReport>
        </Message>
</AmazonEnvelope> 
XML

my $result = Amazon::MWS::XML::Response::FeedSubmissionResult->new(xml => $xml,
                                                                   schema_dir => 'schemas',
                                                                  );

ok($result);
ok(!$result->is_success);
ok($result->errors) and diag $result->errors;
ok(!$result->warnings, "No warnings");

ok(!$result->skus_warnings, "No warnings structure")
  or diag Dumper($result->skus_warnings);
ok($result->skus_errors, "Error structure found");

is_deeply([ $result->skus_with_warnings ], []);
is_deeply([ $result->failed_skus ], [qw/16414 12110 12112 14742 12194 16415/]);

$xml = <<'XML';
<?xml version="1.0" encoding="UTF-8"?>
<AmazonEnvelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="amzn-envelope.xsd">
	<Header>
		<DocumentVersion>1.02</DocumentVersion>
		<MerchantIdentifier>_MERCHANT_ID_</MerchantIdentifier>
	</Header>
	<MessageType>ProcessingReport</MessageType>
	<Message>
		<MessageID>1</MessageID>
		<ProcessingReport>
			<DocumentTransactionID>12341234</DocumentTransactionID>
			<StatusCode>Complete</StatusCode>
			<ProcessingSummary>
				<MessagesProcessed>1</MessagesProcessed>
				<MessagesSuccessful>1</MessagesSuccessful>
				<MessagesWithError>0</MessagesWithError>
				<MessagesWithWarning>1</MessagesWithWarning>
			</ProcessingSummary>
			<Result>
				<MessageID>1</MessageID>
				<ResultCode>Warning</ResultCode>
				<ResultMessageCode>5000</ResultMessageCode>
				<ResultDescription>The update for Sku &apos;16446&apos; was skipped because it is identical to the update in feed &apos;xxxxx&apos;.</ResultDescription>
				<AdditionalInfo>
					<SKU>16446</SKU>
				</AdditionalInfo>
			</Result>
		</ProcessingReport>
	</Message>
</AmazonEnvelope>
XML

$result = Amazon::MWS::XML::Response::FeedSubmissionResult->new(xml => $xml,
                                                                   schema_dir => 'schemas',
                                                                  );
ok($result);
ok($result->is_success, "Is success even with warnings");
ok(!$result->errors, "No errors");
ok($result->warnings, "Has warnings") and diag $result->warnings;
ok($result->skus_warnings); #  and diag Dumper($result->skus_warnings);
ok(!$result->skus_errors); #  and diag Dumper($result->skus_warnings);
is_deeply([ $result->failed_skus ], []);
is_deeply([ $result->skus_with_warnings ], [ qw/16446/ ]);
