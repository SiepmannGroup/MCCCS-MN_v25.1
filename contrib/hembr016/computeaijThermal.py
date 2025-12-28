import numpy as np
from scipy.optimize import leastsq
import shlex
import sys
import optparse

#My modules. 

import rcGWEOSFunctions as rcg

#this program will compute the aij parameter for an athermal chain mixture


def getPressure_findinga(params,rho,m,l):
#   print "get pressure with ", params[0], rho, m, l
   a = params[0]
   P_pred = rcg.P_crGW_EOS_OZ(a,rho,m,l)
   return P_pred

def ErrorSq(params,P_target,rho,m,l):
#    print "trying ", params[0]
    error = P_target-getPressure_findinga(params,rho,m,l)
    print "trying ", params[0], " with error ", error
    errorSq = error**2
    return errorSq    

parser = optparse.OptionParser()
#
parser.add_option('--rhom2', help='DPD molecule density. Default=%default', dest='rhom2', type='float', default=5.0)
parser.add_option('--L2', help='Bondlength. Defualt=%default', dest='L2', type='float', default=0.45)
parser.add_option('--m2', help='number of beads in chain. Default=%default', dest='m2', type='float', default=2)
parser.add_option('--a22', help='guess for aii. Default=%default', dest='a22', type='float', default=10)
parser.add_option('--rhom1', help='DPD molecule density. Default=%default', dest='rhom1', type='float', default=5.0)
parser.add_option('--L1', help='Bondlength. Defualt=%default', dest='L1', type='float', default=0.45)
parser.add_option('--m1', help='number of beads in chain. Default=%default', dest='m1', type='float', default=2.0)
parser.add_option('--a11', help='guess for aii. Default=%default', dest='a11', type='float', default=10.0)
parser.add_option('--chi', help='the target chi value for aij', dest='chi', type='float',default=10.0)
#
(opts, args) = parser.parse_args()
#



rhom2	=	opts.rhom2
l2	=	opts.L2
m2	=	opts.m2
a22	=	opts.a22
rhom1	=	opts.rhom1
l1	=	opts.L1
m1	=	opts.m1
a11	=	opts.a11
aijathermal =  rcg.aijterm(a11,rhom1,m1,l1,a22,rhom2,m2,l2)
targetChi = opts.chi
rhoref=5.0
highguess = 250.0
RT=1.0 #0.0083144621
#print aijathermal

#now we compute each muex
aij =  rcg.getaijThermal(targetChi, RT, rhom1, rhom2, a11, a22,  l1, l2, m1, m2, rhoref, highguess)
print aij
