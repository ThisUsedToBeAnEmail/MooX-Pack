use strict;
use warnings;

use Test::More;

use t::Classes::Test;

my $thing = t::Classes::Test->new(data => 't/data/fake.cdr');

use Data::Dumper;
warn Dumper $thing->unpack;

warn Dumper $thing->raw_data;

done_testing();
