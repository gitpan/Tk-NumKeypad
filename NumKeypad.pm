#=============================================================================
#
# Numeric Keypad for Perl/Tk
#
#-----------------------------------------------------------------------------

package Tk::NumKeypad;
use vars qw/$VERSION/;
$VERSION = '1.0';

use Tk::widgets qw/Button/;
use base qw/Tk::Frame/;
use strict;
use warnings;

Construct Tk::Widget 'NumKeypad';

sub ClassInit {
    my ($class, $mw) = @_;
    $class->SUPER::ClassInit($mw);
}

sub Populate {
    my ($this, $args) = @_;
    $this->SUPER::Populate($args);

    # Keypad
    my $i = 0;
    foreach my $n (qw{7 8 9 4 5 6 1 2 3 . 0 C}) {
        my $btn = $this->Button(
            -text    => $n,
            -command => sub {$this->_padpress($n);},
            )->grid(
            -row    => int($i / 3),
            -column => $i % 3,
            -sticky => 'nsew'
            );
        $this->Advertise("KP$n" => $btn);
        ++$i;
    }
    $this->ConfigSpecs(
        -entry    => ['PASSIVE'],
        'DEFAULT' => ['DESCENDANTS']
    );
    return $this;
}

sub _padpress {
    my ($this, $n) = @_;
    my $e = $this->cget('-entry');
    return if !$e;
    if ($e->selectionPresent) {
        $e->delete('sel.first', 'sel.last');
    }
    if ($n eq 'C') {
        return $e->delete(0, 'end');
    }
    $e->insert(
        'insert', $n
        );
}

__END__

=head1 NAME

Tk::NumKeypad - A Numeric Keypad widget

=head1 SYNOPSIS

    my $e = $mw->Entry(...)->pack;   # Some entry widget
    my $nkp = $mw->NumKeypad(-entry => $e)->pack;  # Numeric keypad

=head1 DESCRIPTION

A numeric keypad, including a clear button and a decimal point button.
This is useful for touchscreen or kiosk applications where access to a 
keyboard won't be available.

The keypad is arranged as follows:

    7 8 9
    4 5 6
    1 2 3
    . 0 C

The widget is designed to supply values to an Entry widget.
Specify the Entry widget with the -entry option.

The following options/value pairs are supported:

=over 4

=item B<-entry>

Identifies the associated Tk::Entry widget to be populated or cleared
by this keypad.

=back

=head1 METHODS

None.

=head1 ADVERTISED SUBWIDGETS

The individual buttons are advertised as "KP" + the button label.
They are KP0, KP1, ... KP9, KP. and KPC .

=head1 AUTHOR

Steve (at) HauntedMines (dot) org

Copyright (C) 2010. Steve Roscio.  All rights reserved.

This program is free software, you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 KEYWORDS

NumKeypad

=cut
