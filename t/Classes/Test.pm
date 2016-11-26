package t::Classes::Test;

use Moo;
use MooX::Pack;

data_field data => (
    character => 'A10',
    catch => 1,
    alias => 'date_something',
);

data_field filler_1 => (
    character => 'x',
);

data_field description => (
    character => 'A27',
    catch => 1,
);

data_field filler_2 => (
    character => 'x',
);

data_field income => (
    character => 'A7',
    catch => 1,
);

1;

