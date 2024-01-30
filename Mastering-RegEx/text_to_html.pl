#!/usr/bin/env perl

# Example from Mastering Regular Expressions
# Converts plain text to HTML
# NOTE: This is not a general tool, this is just
# for a simple demonstration
# This uses multiple lines of input for processing

use strict;

undef $/;   # Enter 'file-slurp' mode
my $text = <>;  # Slurp up the first file given on the command line (use text_to_html.txt)

# 'cooking the text for HTML'

# Search/Replace patterns

$text =~ s/&/&amp;/g;    # Make the basic HTML
$text =~ s/</&lt;/g;     #   characters &, <, and >
$text =~ s/>/&gt;/g;     #   HTML safe

# Mark paragraphs by separating them with the <p> HTML tag
# Using the 'multiline' modifier

# NOTE: This doesn't actually wrap the multiline text in <p> tags (notice there is no </p>), it inserts them on blank lines
# TODO: Figure that part out later


$text =~ s/^\s*$/<p>/mg;

# Turning an email address into a link
# This utilizes re-use of the match group to create the replacement string
# This is supported in most languages that support Regular Expressions
#   refer to the language nuances on how to access them
# This example will only recognize .com|.edu|.info (for simplicity)
# Perl also allows us to choose our RegEx delimiters.  the {} are used in place of the // from earlier

# $text =~ s{\b(\w[-.\w]*\@[-a-z0-9]+(\.[-a-z0-9]+)*\.(com|edu|info))\b}{<a href="mailto:$1">$1<\/a>}gi;

# The above example has been transformed below with the 'x' modifier added to allow more readability and
#  comments.  This ignores the additional whitespace

# Adding the hostname pattern to a variable so that it is easier to modify all occurances later
# this uses the qr operator - turns the pattern into a regex object which can be used later

my $HostnameRegex = qr/[-a-z0-9]+(\.[-a-z0-9]+)*\.(com|edu|info)/i;

$text =~ s{
    \b
    # Capture the address to $1
    (
        \w[-.\w]*                                   # Username
        \@
        $HostnameRegex                              # Hostname
    )
    \b
}{<a href="mailto:$1">$1</a>}gix;

# Turning an HTTP URL into a link
# No \b is used at the end of the path portion so that a URL may end with punctuation (as they sometimes do)

$text =~ s{
    \b
    # Capture the URL to $1
    (
        http:// $HostnameRegex \b                               # Hostname
        (
            / [-a-z0-9_:\@&?=+,.!/~*'%\$]*                      # Optional Path
            (?<![.,?!])                                         # Negative lookahead (Not allowed to end with [.,?!])
        )?
    )
}{<a href="$1">$1</a>}gix;


print $text;    # Display the converted text
print "\n";