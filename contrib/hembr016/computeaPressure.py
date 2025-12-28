import numpy as np
from scipy.optimize import leastsq
import shlex
import sys
import optparse

#My modules. 
import rcGWEOSFunctions as rcg

# for any given set of parameters this program will return the Pressure from the rcGW-EOS

# function to compute the pressure with a supplied value for a_ii
def getPressure_findinga(params,rho,m,l):
   a = params[0]
   P_pred = rcg.P_crGW_EOS_OZ(a,rho,m,l)
   return P_pred

# begin the command line parser
parser = optparse.OptionParser()
#
parser.add_option('--rho', help='DPD bead density. Default=%default', dest='rho', type='float', default=5.0)
parser.add_option('--L', help='Bondlength. Defualt=%default', dest='L', type='float', default=0.45)
parser.add_option('--m', help='number of beads in chain. Default=%default', dest='m', type='float', default=2)
parser.add_option('--aii', help='guess for aii. Default=%default', dest='aii', type='float', default=10)
# Parse the commandline input
(opts, args) = parser.parse_args()
#

# set the variables
rho = opts.rho
l=opts.L
m=opts.m
aii = opts.aii
print rcg.P_crGW_EOS_OZ(aii,rho,m,l)
