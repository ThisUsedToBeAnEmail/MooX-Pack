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

=pod
has [qw/pack_string pack_templates raw_data/] => (
    is => 'rw',
    lazy => 1,
    builder => 1,
);

sub _build_pack_string {
    my $spec = $_[0]->_data_spec;
    my $string = '';
    for (@{ $spec }) {
        my $key = (keys %{ $_ })[0];
        $string = sprintf('%s%s', $string, $_->{$key}->{character});
    }
    return $string;
}

sub _build_pack_templates {
    my $spec = $_[0]->_data_spec;
    my @keys = ();
    for (@{$spec}){
        my $key = (keys %{ $_ })[0];
        if ( defined $_->{$key}{catch} ) {
            if ( defined $_->{$key}{alias} ) {
                $key = $_->{$key}{alias};
            }
            push @keys, $key;
        }
    }   
    return \@keys;
}

sub _build_raw_data {
    my $data = $_[0]->data;

    if (-f $data) {
       $data = $_[0]->_open_fh($data);
    }

    return $data;
}

sub _open_fh {
    open ( my $fh, '<', $_[1] ) or croak "could not open file: $_[1]";
    my $data = do { local $/; <$fh> };
    close $fh;
    return $data;
}

sub unpack {
    my @unpacking = ();
    my $pack_string = $_[0]->pack_string;
    for($_[0]->raw_data =~ /([^\n]+)\n?/g){
        my @unpack = unpack($pack_string, $_);
        my %hashed;
        @hashed{@{$_[0]->pack_templates}} = @unpack;
        push @unpacking, \%hashed;  
    }

    return \@unpacking;
}

sub pack {
    my @packing = ();
    my $pack_string = $_[0]->pack_string;
    for($_[0]->raw_data =~ /([^\n]+)\n?/g){
        my $pack = pack($pack_string, $_);
        push @packing, $pack;  
    }

    return join "\n", @packing;  
}

=cut

1;
