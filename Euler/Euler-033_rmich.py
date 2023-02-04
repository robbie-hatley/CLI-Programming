#! /usr/bin/python2
import time
s = time.time()
sols = []
for d in range(11,100):
    for n in range(10,d):
        if n%10 and d%10:
            if n%10 == d/10:
                a = n/10
                if 1.0*n/d == (a)/(1.0*(d%10)):
                    sols.append([n,d])
            elif d%10 == n/10:
                a = d/10
                if 1.0*n/d == (1.0*(n%10))/a:
                    sols.append([n,d])
    
print sols
def mult(a,b):
    return [a[0]*b[0], a[1]*b[1]]

a = reduce(mult, sols)

print 1.0*a[1]/a[0]
print (time.time() -s)
 