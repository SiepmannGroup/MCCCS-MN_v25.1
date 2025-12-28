import numpy as np
from scipy.optimize import leastsq
import shlex
import sys
import optparse

#My modules. 
#import Functions
import rcGWEOSFunctions as rcg

# This program will use a least squares fit to chose the a_ii parameter for a given set of parameters

# Return the pressure
def getPressure_findinga(params,rho,m,l):
#   print "get pressure with ", params[0], rho, m, l
   a = params[0]
   P_pred = rcg.P_crGW_EOS_OZ(a,rho,m,l)
   return P_pred

# compute the error
def ErrorSq(params,P_target,rho,m,l):
#    print "trying ", params[0]
    error = P_target-getPressure_findinga(params,rho,m,l)
    print "trying ", params[0], " with error ", error
    errorSq = error**2
    return errorSq    

#start the parser
parser = optparse.OptionParser()
#
parser.add_option('--rhom', help='DPD bead density. Default=%default', dest='rhom', type='float', default=5.0)
parser.add_option('--L', help='Bondlength. Defualt=%default', dest='L', type='float', default=0.45)
parser.add_option('--Pt', help='Target Pressure in DPD units. Default=%default', dest='Ptarget', type='float', default=25.115348)
parser.add_option('--m', help='number of beads in chain. Default=%default', dest='m', type='float', default=2)
parser.add_option('--aiiguess', help='guess for aii. Default=%default', dest='aiiguess', type='float', default=10)
# parse the input
(opts, args) = parser.parse_args()

# redirect values
rho = opts.rhom*opts.m
l=opts.L
m=opts.m
initguessa = opts.aiiguess
P_target = opts.Ptarget

print rho
# find the optimal a_ii for the desired pressure
p_opt, pcov = leastsq(ErrorSq,initguessa,args=(P_target,rho,m,l))
#

# return the a_ii value. Just prints to the screen for easy commandline parsing
print p_opt[0]

