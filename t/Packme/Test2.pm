package t::Packme::Test2;

use Moo;
use MooX::Pack;

all seperator => (
    character => 'x',
    index => [ 1, 3 ],
);

line one => (
    key => 'data',
    character => 'A10',
    catch => 1,
    alias => 'date_something',
);

line one => (
    name => 'description',
    character => 'A27',
    catch => 1,
);

line one => (
    name => 'income',
    character => 'A7',
    catch => 1,
);

line two => (
    name => 'expenses',
    character => 'A7',
    catch => 1,
    index => 4,
);

line two => (
    key => 'data',
    character => 'A10',
    catch => 1,
    alias => 'date_something',
    index => 0,
);

line two => (
    name => 'notes',
    character => 'A27',
    catch => 1,
    index => 2,
);

1;

