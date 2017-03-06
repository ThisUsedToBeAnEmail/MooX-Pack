use strict;
use warnings;

use Test::More;

use t::Packme::Test;

my $original_string =  'Date      |Description                | Income|Expenditure'; 

my $test = t::Packme::Test->new(data => $original_string);

is($test->data, $original_string, "data is set");

use Data::Dumper;
warn Dumper $thing->unpack;

done_testing();
