#!/usr/bin/perl

foreach $file ( @ARGV ) {
    open LEAVES, "$file"  or die "Unable to open $file: $!\n";
    $function = '';
    while (<LEAVES>) {
        if ( /#Function (\w+)/ ) {
            $function = $1;
            open LEAF, ">leaves/$file\_$function"   or die "Unable to open leaves/$file\_$function: $!\n";
        }
        print LEAF $_   if ( $function );
        if ( /#EndFunction/ ) {
            $function = '';
            close LEAF;
        }
    }
    close LEAVES;
}

