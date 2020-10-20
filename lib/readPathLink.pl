#!/usr/bin/perl
use strict;
use warnings;

if (scalar(@ARGV) < 2) { exit 0; }
my $pos = pop(@ARGV);
my $buffer = join(" ", @ARGV);
if ($buffer =~ /^\s*$/) { exit 0; }

my ($from, $length) = &getTarget($buffer, $pos);
my $head   = substr($buffer, 0, $from);
my $target = substr($buffer, $from, $length);
my $tail   = "";
if ($from + $length < length($buffer)) {
    $tail = substr($buffer, $from + $length);
}
#print STDERR "[1] \"$head\"\n";
#print STDERR "[2] \"$target\"\n";
#print STDERR "[3] \"$tail\"\n";

$_ = `readlink -e $target`;
if ($_ eq "") {
    $_ = `which $target 2>/dev/null | tail -n 1`;
}
if ($_ eq "") { exit 1; }
s/[\r\n]//g;

print $head . $_ . $tail;

sub getTarget {
    my ($buffer, $pos) = @_;
    $buffer .= " ";
    my @space = ();
    push(@space, -1);
    my $p = index($buffer, " ");
    while ($p >= 0) {
        push(@space, $p);
        $p = index($buffer, " ", $p+1);
    }

    my $i=0;
    for (; $i<$#space; $i++) {
        if ($pos <= $space[$i]) {
            last;
        }
    }
    while ($space[$i]-1 == $space[$i-1]) {
        $i--;
    }
    return ($space[$i-1]+1, $space[$i]-$space[$i-1]-1);
}

