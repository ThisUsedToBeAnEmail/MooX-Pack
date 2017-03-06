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
            
            sub _build_line_spec {
                my ($class, @meta) = @_;
                return $class->maybe::next::method(@meta);
            }

            sub _build_all_spec {
                my ($class, @meta) = @_;
                return $class->maybe::next::method(@meta);
            }
            
        1;
        }';
    }

    $has->( 'target' => ( is => 'ro', lazy => 1, default => sub { return $target; } ) );

    my $apply_modifiers = sub {
       $with->('MooX::Pack::Base');
    };

    my $spec = {};
    my $index = 0;
    my $line = sub {
        my ( $name, %attributes ) = @_;
        if (!$spec->{$name}) { 
            $spec->{$name}->{spec} = [];
            $spec->{$name}->{index} = $index++;
        }
        push @{ $spec->{$name}->{spec} }, \%attributes;
        $around->(
            "_build_line_spec" => sub {
                my ( $orig, $self ) = ( shift, shift );
                return $self->$orig(@_), $spec;
            }
        );
    };

    { no strict 'refs'; *{"${target}::line"} = $line; }

    my $aspec = {};
    my $option = sub {
        my ( $name, %attributes ) = @_;
        if (!$aspec->{$name}) { 
            $aspec->{$name} = [ ];
        }
        push @{ $aspec->{$name} }, \%attributes;
        $around->(
            "_build_all_spec" => sub {
                my ( $orig, $self ) = ( shift, shift );
                return $self->$orig(@_), $aspec;
            }
        );
    };

    { no strict 'refs'; *{"${target}::all"} = $option; }

    $apply_modifiers->();

    return; 
}

1;

__END__

