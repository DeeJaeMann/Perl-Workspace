#!/usr/bin/perl

###
# Example of how to use RegEx to add commas for US Numbers greater than 999
#
###

use strict;
my $strNumber = 0;

# Prompt user for input of a number larger than 999
printf "Please enter a number greater than 999 to add commas to.\n";
printf "The larger the number, the better: ";

# Get input from user
$strNumber = <STDIN>;
# Remove the ending newline
chomp $strNumber;

# Verify that the input is only digits
# The first check is for the entire line signified by
# RegEx:
#  m// - Match - Perl
#  ^ - Beginning of the line
#  $ - End of the line
#  \d{4,} - Match at least 4 digit characters
if($strNumber =~ m/^\d{4,}$/) {
    #printf "Input is at least 4 digits"
    #
    # This search/replace pattern utilizes postitive and negative lookarounds
    #  to locate the matches but not consume them.  This makes it so we don't
    #  have to loop back through the string to insert the commas
    #RegEx:
    # s/// - Search/Replace - Perl
    # ?<= - Positive Lookbehind (Can we match this pattern behind our current position)
    # \d  - Match 1 digit
    # ?=  - Positive Lookahead (Can we match this pattern ahead of our current position)
    # ()  - Group
    # (?: - Do NOT assign group to variable (Groups assign to variables by default. 
    #        This would have been assigned to $1)
    # \d{3} - Match exactly 3 digits
    # ()+ - Match this group 1 or more times
    # ?!  - Negative Lookhead (Check to see if the pattern ahead does not match)
    # /,/ - Place a ',' at the position matched
    # /g  - global modifier
    $strNumber =~ s/(?<=\d)(?=(?:\d{3})+(?!\d))/,/g;
    printf "$strNumber"
} 
else 
{
    printf "Please enter at least 4 digits!"
}
