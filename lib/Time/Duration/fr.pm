package Time::Duration::fr;
use encoding 'utf-8';
use strict;
use warnings;

our $VERSION = '0.01';

use base qw< Exporter >;

our @EXPORT = qw<
    later  later_exact  earlier  earlier_exact
    ago  ago_exact  from_now  from_now_exact
    duration  duration_exact  concise
>;
our @EXPORT_OK = ( "interval", @EXPORT );

use constant DEBUG => 0;
use Time::Duration ();


my %en2fr = (
    second => ["seconde", "secondes"],
    minute => ["minute" , "minutes" ],
    hour   => ["heure"  , "heures"  ],
    day    => ["jour"   , "jours"   ],
    year   => ["année"  , "années"  ],
);

my %short   = map { $_=> substr($_, 0, 1) } map { @$_ } values %en2fr;
my $comp_re = join "|", map { $_->[0] } values %en2fr;


sub concise ($) {
    my $string = $_[0];

    #print "in : $string\n";
    $string =~ tr/,//d;
    $string =~ s/\bet\b//;
    $string =~ s/\b($comp_re)s?\b/$short{$1}/g;
    $string =~ s/\s*(\d+)\s*/$1/g;

    # restore prefixed intervals
    $string =~ s/dans/dans /;
    $string =~ s/il y a/il y a /; 

    return $string;
}

sub later {
    interval(      $_[0], $_[1], "%s plus tôt", "%s plus tard", "maintenant");
}

sub later_exact {
    interval_exact($_[0], $_[1], "%s plus tôt", "%s plus tard", "maintenant");
}

sub earlier {
    interval(      $_[0], $_[1], "%s plus tard", "%s plus tôt", "maintenant");
}

sub earlier_exact {
    interval_exact($_[0], $_[1], "%s plus tard", "%s plus tôt", "maintenant");
}

sub ago {
    interval(      $_[0], $_[1], 'dans %s', 'il y a %s', "maintenant");
}

sub ago_exact {
    interval_exact($_[0], $_[1], 'dans %s', 'il y a %s', "maintenant");
}

sub from_now {
    interval(      $_[0], $_[1], 'il y a %s', 'dans %s', "maintenant");
}

sub from_now_exact {
    interval_exact($_[0], $_[1], 'il y a %s', 'dans %s', "maintenant");
}


sub duration_exact {
    my $span = $_[0];   # interval in seconds
    my $precision = int($_[1] || 0) || 2;  # precision (default: 2)
    return '0 seconde' unless $span;
    _render('%s',
        Time::Duration::_separate(abs $span));
}

sub duration {
    my $span = $_[0];   # interval in seconds
    my $precision = int($_[1] || 0) || 2;  # precision (default: 2)
    return '0 seconde' unless $span;
    _render('%s',
        Time::Duration::_approximate($precision,
            Time::Duration::_separate(abs $span)));
}


sub interval_exact {
    my $span = $_[0];                       # interval, in seconds
                                            # precision is ignored
    my $direction = ($span <= -1) ? $_[2]   # what a neg number gets
                  : ($span >=  1) ? $_[3]   # what a pos number gets
                  : return          $_[4];  # what zero gets
    _render($direction,
        Time::Duration::_separate($span));
}

sub interval {
    my $span = $_[0];                       # interval, in seconds
    my $precision = int($_[1] || 0) || 2;   # precision (default: 2)
    my $direction = ($span <= -1) ? $_[2]   # what a neg number gets
                  : ($span >=  1) ? $_[3]   # what a pos number gets
                  : return          $_[4];  # what zero gets
    _render($direction,
        Time::Duration::_approximate($precision,
            Time::Duration::_separate($span)));
}


sub _render {
    # Make it into French
    my $direction = shift @_;
    my @wheel = map {
        ( $_->[1] == 0 ) ? ()  # zero wheels
            : $_->[1] . " " . $en2fr{ $_->[0] }[ $_->[1] == 1 ? 0 : 1 ]
        } @_;

    return "maintenant" unless @wheel; # sanity

    my $result;
    if (@wheel == 1) {
        $result = $wheel[0];
    }
    elsif (@wheel == 2) {
        $result = "$wheel[0] et $wheel[1]";
    }
    else {
        $wheel[-1] = "et $wheel[-1]";
        $result = join q{, }, @wheel;
    }

    return sprintf($direction, $result);
}


1;

__END__

=head1 NAME

Time::Duration::fr - describe time duration in French


=head1 VERSION

Version 0.01


=head1 SYNOPSIS

    use Time::Duration::fr;

    my $duration = duration(time() - $start_time);


=head1 DESCRIPTION

C<Time::Duration::fr> is a localized version of C<Time::Duration>.


=head1 SEE ALSO

L<Time::Duration>, L<Time::Duration::Locale>


=head1 AUTHOR

SE<eacute>bastien Aperghis-Tramoni C<< <sebastien at aperghis.net> >>


=head1 BUGS

Please report any bugs or feature requests to
C<bug-time-duration-fr at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/Public/Dist/Display.html?Dist=Time-Duration-fr>.
I will be notified, and then you'll automatically be notified of
progress on your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Time::Duration::fr

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/Public/Dist/Display.html?Dist=Time-Duration-fr>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Time-Duration-fr>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Time-Duration-fr>

=item * Search CPAN

L<http://search.cpan.org/dist/Time-Duration-fr>

=back


=head1 COPYRIGHT & LICENSE

Copyright 2010 SE<eacute>bastien Aperghis-Tramoni, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
