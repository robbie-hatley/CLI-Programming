

   #!/usr/bin/env perl
   use v5.36;
   sub parity ($x) {
      return 'error' if $x !~ m/^[a-h][1-8]$/;
      ((ord(substr($x,0,1))-97)+(ord(substr($x,1,1))-49))%2
   }
   my @coords = @ARGV ? eval($ARGV[0]) : ('d3', 'g5', 'e6');
   say 'Coord   Parity  Color   Result  ';
   for my $coord (@coords) {
      my $parity = parity($coord);
      my $color  = $parity ? 'white' : 'black';
      my $result = $parity ? 'true'  : 'false';
      printf("%-8s%-8s%-8s%-8s\n", $coord, $parity, $color, $result);
   }


