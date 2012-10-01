#=============================================================================
#
# Numeric Keypad for Perl/Tk
#
#-----------------------------------------------------------------------------

# TODO:  add -math mode to give / * - + Enter keys
# TODO:  allow keys to be changes, i.e. make . (dot) be a delete

package Tk::NumKeypad;
use vars qw/$VERSION/;
$VERSION = '1.3';

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
    $this->ConfigSpecs(
        -entry    => ['PASSIVE'],
        -text     => '-entry',
        'DEFAULT' => ['DESCENDANTS']
    );

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
    return $this;
}

sub _padpress {
    my ($this, $n) = @_;
    my $e = $this->cget('-entry');
    return if !$e;
    if ($e->isa("Tk::Entry")) {
        # Entry widget
        return $e->delete(0, 'end')
            if $n eq 'C';
        $e->delete('sel.first', 'sel.last')
            if $e->selectionPresent;
    }
    else {
        # Text widget
        return $e->delete('1.0', 'end') if $n eq 'C';
        $e->delete('sel.first', 'sel.last')
            if $e->tagRanges('sel');
    }
    $e->insert('insert', $n);
}

__END__

=head1 NAME

Tk::NumKeypad - A Numeric Keypad widget

=head1 SYNOPSIS

    my $e = $mw->Entry(...)->pack;   # Some entry or text widget
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

Identifies the associated Tk::Entry or Tk::Text widget to be populated or cleared
by this keypad.

=item B<-text>

Alias for -entry.  Use of -text is preferred if the widget really is a Tk::Text.

=back

=head1 METHODS

None.

=head1 ADVERTISED SUBWIDGETS

The individual buttons are advertised as "KP" + the button label.
They are KP0, KP1, ... KP9, KP. and KPC .

=head1 AUTHOR

Steve Roscio  C<< <roscio@cpan.org> >>

Copyright (c) 2010, Steve Roscio C<< <roscio@cpan.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=head1 DISCLAIMER OF WARRANTY

Because this software is licensed free of charge, there is no warranty
for the software, to the extent permitted by applicable law.  Except when
otherwise stated in writing the copyright holders and/or other parties
provide the software "as is" without warranty of any kind, either
expressed or implied, including, but not limited to, the implied
warranties of merchantability and fitness for a particular purpose.  The
entire risk as to the quality and performance of the software is with
you.  Should the software prove defective, you assume the cost of all
necessary servicing, repair, or correction.

In no event unless required by applicable law or agreed to in writing
will any copyright holder, or any other party who may modify and/or
redistribute the software as permitted by the above licence, be
liable to you for damages, including any general, special, incidental,
or consequential damages arising out of the use or inability to use
the software (including but not limited to loss of data or data being
rendered inaccurate or losses sustained by you or third parties or a
failure of the software to operate with any other software), even if
such holder or other party has been advised of the possibility of
such damages.

=head1 KEYWORDS

NumKeypad

=cut
