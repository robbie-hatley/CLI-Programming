#!/usr/bin/env -S perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks (\x{0A}).
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

use v5.32;
use strict;
use warnings;
use utf8;
use warnings FATAL => "utf8";

my $x;
my $y;
for ( $x = 0.300 ; $x <= 0.400 ; $x += 0.001 )
{
   $y = $x ** $x;
   say("x = $x    y = $y");
}

=pod

I've been having more fun with the problematic equation y=x^x. I could not accept that it's defined only for positive real numbers x. I *had* to press the issue. And what I found was, it's defined for all real number x, but only if you allow y to be complex for x<0. The math goes like this (warning: you'll need to be fluent in algebra, trigonometry, and complex numbers to understand this):

To see what the values of y=x^x are for x being any real number, we first need to convert the equation to the Eulerian "polar" form:

y = x^x
y = e^ln(x^x)
y = e^((x)ln(x))
y = e^((x)ln(|x|e^(iϕ)))
y = e^((x)(ln|x| + iϕ))
y = e^((x)ln|x|) + xiϕ)
y = e^((x)ln|x|) e^(xiϕ)
y = e^(ln(|x|^x)) e^(xiϕ)
y = |x|^x e^(xiϕ)                      POLAR FORM
y = |x|^x cos(xϕ) + |x|^x sin(xϕ)i     RECTANGULAR FORM

Now, if x is a positive real number, |x| = x and ϕ = 0 so this just boils down to:
y = (x^x)(e^0)
y = (x^x)(1)
y = x^x
which is where we started.

However, if x is a NEGATIVE real number, ϕ = π which will cause y to take on complex values:
y = |x|^x e^(xiπ)                    POLAR FORM
y = |x|^x cos(πx) + |x|^x sin(πx)i   RECTANGULAR FORM

Therefore, the function y=x^x R->C is defined for all real numbers x.
For x=0, y=1. (lim[x->0+](y) = 1.)
For x>0, y = x^x = e^(x ln x).
For x<0, y = |x|^x cos(πx) + |x|^x sin(πx)i

Hence, if we create a z axis perpendicular to the x and y axes, pointing out of the plane of the computer screen toward the viewer, and use that z axis to plot the imaginary part of y=x^x, then the left half of the graph is a helix of period 2 around the negative x axis, diminishing in amplitude as the graph goes leftward.

At each integer value of x (-1, -2, -3...), the helix punctures the x/y plane, and at those points, y has a pure-real value. (Eg: (-2)^(-2) = 0.25)

At each half-integer value of x (-0.5, -1.5, -2.5...), the helix punctures the x/z plane, and at those points, y has a pure-imaginary value. (Eg: (-0.5)^(-0.5) = sqrt(0.5)i = about 0.707i)

At all other points, y has a single well-defined non-real non-imaginary complex value.

=cut

