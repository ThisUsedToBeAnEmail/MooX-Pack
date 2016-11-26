package MooX::Pack;

use strict;
use warnings;
use Carp qw/croak/;

our $VERSION = '0.16';

sub import {
    my ( $self, @import ) = @_;
    
    my $target = caller;
    
    for my $needed_method (qw/with around has/) {
        next if $target->can($needed_method);
        croak "Can't find method <$needed_method> in <$target>";
    }

    my $with = $target->can('with');
    my $around = $target->can('around');
    my $has = $target->can('has');

    my @target_isa;

    { no strict 'refs'; @target_isa = @{"${target}::ISA"} };

    if (@target_isa) {   
        eval '{
        package ' . $target . ';
            
            sub _data_spec {
                my ($class, @meta) = @_;
                return $class->maybe::next::method(@meta);
            }
            
        1;
        }';
    }

    $has->( 'package' => ( is => 'ro', lazy => 1, default => sub { return $target; } ) );

    my $apply_modifiers = sub {
       $with->('MooX::Pack::Base');
    };

    my @element = ( );
    my $option = sub {
        my ( $name, %attributes ) = @_;
        my $element_data = { };
        $element_data->{$name} = \%attributes;
        push @element, $element_data;
        $around->(
            '_data_spec' => sub {
                my ( $orig, $self ) = ( shift, shift );
                return $self->$orig(@_), \@element;
            }
        );
        return;
    };

    { no strict 'refs'; *{"${target}::data_field"} = $option; }

    $apply_modifiers->();

    return; 
}

1;

__END__

