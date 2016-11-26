use strict;
use warnings;

use Test::More;

use t::Classes::Test;

my $thing = t::Classes::Test->new(data => 'Date      |Description                | Income|Expenditure');

use Data::Dumper;
warn Dumper $thing->unpack;

done_testing();
