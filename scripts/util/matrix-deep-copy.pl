# Return a ref to a deep copy of a referred-to rectangular 2-d matrix:
sub matrix_deep_copy($mref){
   # Make a deep copy of @$mref (simple copy is NOT deep copy!!!):
   my $matrix_copy;
   # Copy the elements of each row rather than refs to rows!!!
   for my $oldrow (@$mref){
      my $newrow;
      for my $element (@$oldrow){
         push @$newrow, $element;
      }
      push @$matrix_copy, $newrow;
   }
   return $matrix_copy;
}
