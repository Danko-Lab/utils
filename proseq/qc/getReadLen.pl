#!/usr/bin/perl
#	Program outputs the column specificed from a TSV file (0 = first column ...)

# Perl trim function to remove whitespace from the start and end of the string
sub trim($)
{
	my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}

my $i= 3; ## Get the 2nd line, then every 4th line.
while(<STDIN>) {
   #@SPL = split(/[\s\t]/);
   if(($i % 4) == 0) { print length(trim($_))."\n"; }
   $i++;
}
