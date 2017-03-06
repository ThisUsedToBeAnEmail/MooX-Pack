package MooX::Pack::Base;

use Moo::Role;
use Carp;

has data => (
    is => 'ro',
    lazy => 1,
);

has [qw/line_spec all_spec/] => (
    is => 'ro',
    builder => 1,
);

has [qw/pack_templates/] => (
    is => 'rw',
    builder => 1,
);

sub _build_pack_templates {
    my $all  = $_[0]->all_spec;
    my $line = $_[0]->line_spec;
    my %ordered_line = map { $line->{$_}->{index} => $line->{$_}->{spec} } keys %{ $line };
    my @templates;
    for ( 0 .. ( scalar (keys %ordered_line) - 1 )) {
        push @templates, $ordered_line{$_};
    }

    for my $every (keys %{ $all }) {
        my $index = delete $all->{$every}->{index};
        for my $index (@{ $index }) {
            for ( @templates ) {
                splice @{ $_ }, $index, 0, { %{ $all->{$every} } };
            }
        }
    }

    return \@templates;
}

1;
