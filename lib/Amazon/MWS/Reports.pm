package Amazon::MWS::Reports;

use Amazon::MWS::Routines qw(:all);

define_api_method RequestReport =>
    parameters => {
        ReportType => {
            type     => 'string',
            required => 1,
        },
        StartDate => { type => 'datetime' },
        EndDate   => { type => 'datetime' },
    },
    respond => sub {
        my $root = shift;
        convert_ReportRequestInfo($root);
        return $root;
    };

define_api_method GetReportRequestList =>
    parameters => {
        ReportRequestIdList        => { type => 'IdList' },
        ReportTypeList             => { type => 'TypeList' },
        ReportProcessingStatusList => { type => 'StatusList' },
        MaxCount                   => { type => 'nonNegativeInteger' },
        RequestedFromDate          => { type => 'datetime' },
        RequestedToDate            => { type => 'datetime' },
    },
    respond => sub {
        my $root = shift;
        convert($root, HasNext => 'boolean');
        convert_ReportRequestInfo($root);
        return $root;
    };

define_api_method GetReportRequestListByNextToken =>
    parameters => {
        NextToken => { 
            required => 1,
            type      => 'string',
        },
    },
    respond => sub {
        my $root = shift;
        convert($root, HasNext => 'boolean');
        convert_ReportRequestInfo($root);
        return $root;
    };

define_api_method GetReportRequestCount =>
    parameters => {
        ReportTypeList             => { type => 'TypeList' },
        ReportProcessingStatusList => { type => 'StatusList' },
        RequestedFromDate          => { type => 'datetime' },
        RequestedToDate            => { type => 'datetime' },
    },
    respond => sub { $_[0]->{Count} };

define_api_method CancelReportRequests =>
    parameters => {
        ReportRequestIdList        => { type => 'IdList' },
        ReportTypeList             => { type => 'TypeList' },
        ReportProcessingStatusList => { type => 'StatusList' },
        RequestedFromDate          => { type => 'datetime' },
        RequestedToDate            => { type => 'datetime' },
    },
    respond => sub {
        my $root = shift;
        convert_ReportRequestInfo($root);
        return $root;
    };

define_api_method GetReportList =>
    parameters => {
        MaxCount            => { type => 'nonNegativeInteger' },
        ReportTypeList      => { type => 'TypeList' },
        Acknowledged        => { type => 'boolean' },
        AvailableFromDate   => { type => 'datetime' },
        AvailableToDate     => { type => 'datetime' },
        ReportRequestIdList => { type => 'IdList' },
    },
    respond => sub {
        my $root = shift;
        convert($root, HasNext => 'boolean');
        convert_ReportInfo($root);
        return $root;
    };

define_api_method GetReportListByNextToken =>
    parameters => {
        NextToken => {
            type     => 'string',
            required => 1,
        },
    },
    respond => sub {
        my $root = shift;
        convert($root, HasNext => 'boolean');
        convert_ReportInfo($root);
        return $root;
    };

define_api_method GetReportCount =>
    parameters => {
        ReportTypeList      => { type => 'TypeList' },
        Acknowledged        => { type => 'boolean' },
        AvailableFromDate   => { type => 'datetime' },
        AvailableToDate     => { type => 'datetime' },
    },
    respond => sub { $_[0]->{Count} };

define_api_method GetReport =>
    raw_body   => 1,
    parameters => {
        ReportId => { 
            type     => 'nonNegativeInteger',
            required => 1,
        }
    };

define_api_method ManageReportSchedule =>
    parameters => {
        ReportType    => { type => 'string' },
        Schedule      => { type => 'string' },
        ScheduledDate => { type => 'datetime' },
    },
    respond => sub {
        my $root = shift;
        convert_ReportSchedule($root, ScheduledDate => 'datetime');
        return $root;
    };

define_api_method GetReportScheduleList =>
    parameters => {
        ReportTypeList => { type => 'ReportType' },
    },
    respond => sub {
        my $root = shift;
        convert($root, HasNext => 'boolean');
        convert_ReportSchedule($root);
        return $root;
    };

define_api_method GetReportScheduleListByNextToken =>
    parameters => {
        NextToken => {
            type     => 'string',
            required => 1,
        },
    },
    respond => sub {
        my $root = shift;
        convert($root, HasNext => 'boolean');
        convert_ReportSchedule($root);
        return $root;
    };

define_api_method GetReportScheduleCount =>
    parameters => {
        ReportTypeList => { type => 'ReportType' },
    },
    respond => sub { $_[0]->{Count} };

define_api_method UpdateReportAcknowledgements =>
    parameters => {
        ReportIdList => { 
            type     => 'IdList',
            required => 1,
        },
        Acknowledged => { type => 'boolean' },
    },
    respond => sub {
        my $root = shift;
        convert_ReportInfo($root);
        return $root;
    };

1;