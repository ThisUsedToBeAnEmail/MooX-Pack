use strict;
use warnings;

use Test::More;

use t::Packme::Test2;

my $original_string =  [
    'Date      |Description                |Income ', 
    'Dates     |Descriptions               |Incomes', 
];

my $test = t::Packme::Test2->new(data => join "\n", @{ $original_string });

is($test->data, (join "\n", @{ $original_string }), "data is set");

use Data::Dumper;
warn Dumper $test->line_spec;
warn Dumper $test->all_spec;

done_testing();
