#!/usr/bin/perl

use Getopt::Long;

$peak = 0;
$avg = 0;
$all = 0;
GetOptions ("l" => \$all,
            "p" => \$peak,
            "a" => \$avg);

@order = qw(
    1.1024.ss
    1.1024.l0.lpfs
    1.1024.o1.d1.s1.rcp
    1.1024.o10.d1.s1.rcp
    1.1024.o1.d10.s1.rcp
    1.1024.o1.d1.s10.rcp
    2.1024.ss
    2.1024.l1.lpfs
    2.1024.s.l1.lpfs
    2.1024.rs.l1.lpfs
    2.1024.o1.d1.s1.rcp
    2.1024.o10.d1.s1.rcp
    2.1024.o1.d10.s1.rcp
    2.1024.o1.d1.s10.rcp
    3.1024.ss
    3.1024.l1.lpfs
    3.1024.s.l1.lpfs
    3.1024.rs.l1.lpfs
    3.1024.l2.lpfs
    3.1024.s.l2.lpfs
    3.1024.rs.l2.lpfs
    3.1024.o1.d1.s1.rcp
    3.1024.o10.d1.s1.rcp
    3.1024.o1.d10.s1.rcp
    3.1024.o1.d1.s10.rcp
    4.1024.ss
    4.1024.l1.lpfs
    4.1024.s.l1.lpfs
    4.1024.rs.l1.lpfs
    4.1024.l2.lpfs
    4.1024.s.l2.lpfs
    4.1024.rs.l2.lpfs
    4.1024.l3.lpfs
    4.1024.s.l3.lpfs
    4.1024.rs.l3.lpfs
    4.1024.o1.d1.s1.rcp
    4.1024.o10.d1.s1.rcp
    4.1024.o1.d10.s1.rcp
    4.1024.o1.d1.s10.rcp
    1.1024.w0.ss
    1.1024.w0.l0.lpfs
    1.1024.w0.o1.d1.s1.rcp
    1.1024.w0.o10.d1.s1.rcp
    1.1024.w0.o1.d10.s1.rcp
    1.1024.w0.o1.d1.s10.rcp
    2.1024.w0.ss
    2.1024.w0.l1.lpfs
    2.1024.w0.s.l1.lpfs
    2.1024.w0.rs.l1.lpfs
    2.1024.w0.o1.d1.s1.rcp
    2.1024.w0.o10.d1.s1.rcp
    2.1024.w0.o1.d10.s1.rcp
    2.1024.w0.o1.d1.s10.rcp
    3.1024.w0.ss
    3.1024.w0.l1.lpfs
    3.1024.w0.s.l1.lpfs
    3.1024.w0.rs.l1.lpfs
    3.1024.w0.l2.lpfs
    3.1024.w0.s.l2.lpfs
    3.1024.w0.rs.l2.lpfs
    3.1024.w0.o1.d1.s1.rcp
    3.1024.w0.o10.d1.s1.rcp
    3.1024.w0.o1.d10.s1.rcp
    3.1024.w0.o1.d1.s10.rcp
    4.1024.w0.ss
    4.1024.w0.l1.lpfs
    4.1024.w0.s.l1.lpfs
    4.1024.w0.rs.l1.lpfs
    4.1024.w0.l2.lpfs
    4.1024.w0.s.l2.lpfs
    4.1024.w0.rs.l2.lpfs
    4.1024.w0.l3.lpfs
    4.1024.w0.s.l3.lpfs
    4.1024.w0.rs.l3.lpfs
    4.1024.w0.o1.d1.s1.rcp
    4.1024.w0.o10.d1.s1.rcp
    4.1024.w0.o1.d10.s1.rcp
    4.1024.w0.o1.d1.s10.rcp
);

while (<>) {
    chomp;
    ($cfg, $len) = split /\s+/;
    $cfg =~ s/(?:leaves\.|\.time)//;
    if ( $peak ) {
        $cfgs{$cfg} = ($len, $cfgs{$cfg})[$len < $cfgs{$cfg}];
    } elsif ( $avg ) {
        $cfgs{$cfg} += $len;
        $acc{$cfg}++;
    } else {
        $cfgs{$cfg} = $len;
    }
    $cfg =~ s/(.*\.simd)\.(.*)/$1/;
    $tmp = $2;
    push @tests, $cfg   if ( ! grep ( /^$cfg$/, @tests ) );
    push @all, $tmp     if ( ! grep ( /^$tmp$/, @all ) );
}
@all = sort @all;
$list = ( $all ) ? \@all : \@order;

print "Config   ".(join "   ", @$list)."\n";
foreach $test ( @tests ) {
    print "$test    ";
    foreach $col ( @$list ) {
        $cfg = "$test\.$col";
        if ( ! exists $cfgs{$cfg} ) {
            print "0	";
        } elsif ( $avg ) {
            $val = ( $acc{$cfg} ) ? $cfgs{$cfg} / $acc{$cfg} : 0;
            print "$val ";
        } else {
            print "$cfgs{$cfg}  ";
        }
    }
    print "\n";
}
