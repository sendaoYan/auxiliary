#!/usr/bin/perl -w
use strict;

die "please input result file!" if( ! defined $ARGV[1] );

open(my $failureFH, "<$ARGV[1]") or die "$! $ARGV[1]";
my @failTestcases = <$failureFH>;
close($failureFH);

open(my $fh, "<$ARGV[0]") or die "$! $ARGV[0]";
foreach my $line ( <$fh> )
{
    chomp($line);
    if( $line =~ /(\w+): .* :: (.*) \(/ )
    {
        my $result = $1;
        my $testcase = $2;
        if( "$result" eq "PASS" || "$result" eq "XFAIL" )
        {
            print "$testcase: Pass\n";
        }
        elsif( "$result" eq "SKIP" || "$result" eq "UNSUPPORTED" )
        {
            print "$testcase: Skip\n";
        }
        else
        {
            if( grep /^\Q$testcase\E$/, @failTestcases )
            {
                print("$testcase: Skip\n")
            }
            else
            {
                print("$testcase: Fail\n")
            }
        }
    }
}
close($fh);
