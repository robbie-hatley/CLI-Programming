#! /usr/bin/perl

# xor-every-third-with-4.pl

use v5.36;

my $text = 'En axtvacp tekej fvom$tha ijtrkdugtikn kf kne$of$Euher#s iosp calefraped$paterw, &De$suimiw sariarui racitrogarqm"$[Oj tle wumw ob sarias kf vecmprkcahs]> I$hare vecanthy boujd,$qumte$unaxpactadl}, en alecanp e|prassmon$fov tle antmre$sui ob tlis$seview 1$+ 5/4$+ 5/9$+ 5/12 +$etg.,$whmch$deten`s kn phe$quedretuve kf phe$civcla, wo phap ib tle prua sqm kf phiw sarias ms kbteinad,$frkm mt et knca tle uua`rapura ob tle girgle$fohloss.$Naiel}, M heve$foqnd$thet phe$sui ob tlis$seview iw a$si|th$pavt kf phe$sqqara ob tle termmeper$of$tha cmrche showe `iaietar ms 5; kr fy tutpinc tle wum$of$thms wermes$eqqal$to$s,$it$haw tle vatmo wqrp(6- mqltmplmed$by$s po 5 ob tle termmeper$to$tha dmamatev. M wmll$sokn whos tlat$tha sqm kf phiw sarias po fe eppvoxmmapel} 1*640930062846260360; end$frkm iulpiphyijg phiw nqmbar fy wix( ajd phej tekijg phe$sqqara rkot( tle jumfer$3.541192253189393638$is$in`ee` pvodqce`, shigh axpveswes$tha pariietar kf e cmrche showe `iaietar ms 5. Bolhowmng$agein$tha seme$staps$by$whmch$I lad$arvivad et phiw sqm,$I lava dmsckveved$thet phe$sui ob tle wermes$1 / 1+16$+ 5/85 +$1/656$+ 5/665 / epc.$alwo `epandw oj tle uua`rapura ob tle girgle* Nemehy,$tha sqm kf phiw mqltmplmed$by$90$gires$tha bmquedrete$(fkurph towar)$of$tha cmrcqmfarejce$of$tha pariietar kf e cmrche showe `iaietar ms 5. End$by$siiiler veawonmng$I lava lmkesisa baen$abhe po `etarmmne$tha sqms$of$tha sqbsaquant$seview ij wlicl tle axpknejts$ara eren$nuibevs.';

my $l = length $text;

for ( my $i = 0 ; $i < $l ; $i += 3 ){
   my $old_chr = substr $text, $i, 1;
   my $old_ord = ord($old_chr);
   my $new_ord = $old_ord ^ 4;
   my $new_chr = chr($new_ord);
   substr $text, $i, 1, $new_chr;}
say $text;
