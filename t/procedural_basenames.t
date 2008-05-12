#!/usr/bin/env perl

use utf8;
use 5.008001;

use strict;
use warnings;

use Readonly;

use version; our $VERSION = qv('v1.0.0');

use Test::More;

use PPIx::Shorthand qw< get_ppi_class >;

Readonly my $EMPTY_STRING => q<>;

Readonly my @UNIQUE_BASENAME_COMPONENTS => (
    [ qw< Element > ],
        [ qw< Node > ],
        [ qw< Document > ],
            [ qw< Document Fragment > ],
        [ qw< Statement > ],
            [ qw< Statement Package > ],
            [ qw< Statement Include > ],
            [ qw< Statement Sub > ],
                [ qw< Statement Scheduled > ],
            [ qw< Statement Compound > ],
            [ qw< Statement Break > ],


            [ qw< Statement Expression > ],
                [ qw< Statement Variable > ],
            [ qw< Statement Null > ],
            [ qw< Statement UnmatchedBrace > ],


            [ qw< Structure Block > ],
            [ qw< Structure Subscript > ],
            [ qw< Structure Constructor > ],
            [ qw< Structure Condition > ],
            [ qw< Structure List > ],
            [ qw< Structure ForLoop > ],

        [ qw< Token > ],
        [ qw< Token Whitespace > ],
        [ qw< Token Comment > ],
        [ qw< Token Pod > ],
        [ qw< Token Number > ],
            [ qw< Token Number Binary > ],
            [ qw< Token Number Octal > ],
            [ qw< Token Number Hex > ],
            [ qw< Token Number Float > ],
                [ qw< Token Number Exp > ],
            [ qw< Token Number Version > ],
        [ qw< Token Word > ],
        [ qw< Token DashedWord > ],
        [ qw< Token Symbol > ],
            [ qw< Token Magic > ],
        [ qw< Token ArrayIndex > ],
        [ qw< Token Operator > ],
        [ qw< Token Quote > ],
            [ qw< Token Quote Single > ],
            [ qw< Token Quote Double > ],
            [ qw< Token Quote Literal > ],
            [ qw< Token Quote Interpolate > ],
        [ qw< Token QuoteLike > ],
            [ qw< Token QuoteLike Backtick > ],
            [ qw< Token QuoteLike Command > ],

            [ qw< Token QuoteLike Words > ],
            [ qw< Token QuoteLike Readline > ],

            [ qw< Token Regexp Match > ],
            [ qw< Token Regexp Substitute > ],
            [ qw< Token Regexp Transliterate > ],
        [ qw< Token HereDoc > ],
        [ qw< Token Cast > ],

        [ qw< Token Label > ],
        [ qw< Token Separator > ],


        [ qw< Token Prototype > ],
        [ qw< Token Attribute > ],

);

Readonly my @NON_UNIQUE_BASENAME_CLASSES => qw<
   Data
   End
   Regexp
   Structure
   Unknown
>;

Readonly my @TRANSFORMS => (
    sub { return $_[0]         },
    sub { return lc $_[0]      },
    sub { return lcfirst $_[0] },
    sub { return uc $_[0]      },
    sub { return ucfirst $_[0] },
    sub {
        my ($name) = @_;
        return $name if $name =~ m< \b word >xmsi;
        $name =~ s< ( [^sy] ) \z ><${1}s>xms;
        $name =~ s< y \z ><ies>xms;
        return $name;
    },
);


plan tests =>
    @TRANSFORMS * (@UNIQUE_BASENAME_COMPONENTS + @NON_UNIQUE_BASENAME_CLASSES);


foreach my $name_components (@UNIQUE_BASENAME_COMPONENTS) {
    my $class = join q<::>, 'PPI', @{$name_components};
    my $basename = $name_components->[-1];

    foreach my $transform (@TRANSFORMS) {
        my $transformed = $transform->($basename);

        is(
            get_ppi_class($transformed),
            $class,
            "$transformed should map to $class",
        );
    } # end foreach
} # end foreach

foreach my $basename (@NON_UNIQUE_BASENAME_CLASSES) {
    my $class = join q<::>, 'PPI', 'Token', $basename;

    foreach my $transform (@TRANSFORMS) {
        my $transformed = $transform->($basename);

        is(
            get_ppi_class($transformed),
            $class,
            "$transformed should map to $class",
        );
    } # end foreach
} # end foreach


# setup vim: set filetype=perl tabstop=4 softtabstop=4 expandtab :
# setup vim: set shiftwidth=4 shiftround textwidth=78 nowrap autoindent :
# setup vim: set foldmethod=indent foldlevel=0 :
