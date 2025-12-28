import numpy as np
#import matplotlib.pyplot as plt
import sys
from scipy.fftpack import dst, idst #discrete sine and inverse sine transforms
import optparse 
import warnings
#from numba import autojit

#------------------------
pi = np.pi 
DIM=3 
nr = 16834
dr = 0.001
dk = np.pi/nr/dr  #As Patrick Warren describes. 
sys.setrecursionlimit(30)
#Normalization factor for the fourier transforms 
FAC_FT = 1.0 
FAC_INV_FT = 1.0/(2.0 * pi)**DIM 

#Normalization factor for fourier sine transfrom in 3D
FAC_FST = 4*pi
FAC_INV_FST = 4*pi

FAC_DFT = 1./2.#DON"T UNDERSTAND ORIGIN OF THIS EXACTLY. IT'S BECAUSE OF SINE TRANSFORM WHICH IS ONLY FOR ODD FUNCTIONS I THINK
#TRANSFORM 
FAC_INV_DFT = 1./2.#DON"T UNDERSTAND ORIGIN OF THIS EXACTLY. 

FAC_FBT = FAC_FT * FAC_FST * FAC_DFT
FAC_INV_FBT = FAC_INV_FT * FAC_INV_FST *FAC_INV_DFT
def Create_r_k(dr=0.02, nr=1024):
    r = np.arange(nr)*dr + dr 

    k = np.arange(nr)*dk + dk
    
    return r, k 
def DPDPotential(r, A):
    nr = len(r)
    U_DPD = np.zeros(nr)
    for ir in range(nr):
        if r[ir] < 1.0:
            U_DPD[ir] = 0.5*A*(1-r[ir])**2
            #else, zeros anyway

    return U_DPD
def cr_initguess(Ur):
    #cr = np.zeros(len(U_DPD))
    cr = np.exp(-Ur) - 1.0
    return cr
def FourierBesselTransform(f, r, k):
    #Eqn. 2 of Patrick Warren's documentation
    nr = len(r)
    dr = r[2]-r[1]
    fk = FAC_FBT * dst(f * r)/k * dr 
    return fk

def InvFourierBesselTransform(fk, r, k):

    #Eqn. 4 of Patrick Warren's documentation, using the inverse
    #discrete sine transform for the inv fourier bessel transform
    nr = len(r)
    fac = np.sqrt(nr * 2.0)
    
    f =  FAC_INV_FBT * idst(fk * k)/r * dk 
        
    return f
def Calculate_ek(ck, rho):
    #Eqn 8 in Patrick Warren's documentation
    ek = ck/(1-rho*ck) - ck
    return ek
def HNC_Closure(er, Ur):
    #Eqn. 9 in Patrick Warren's documentation
    cr = np.exp(-Ur + er) - er - 1.0    
        
    return cr
def Calculate_hr(er, cr):
    hr = er + cr
    return hr
def Calculate_gr(hr):
    gr = hr + 1
    return gr 


def ListToTabbedStr(List):
    tab = "\t"
    N = len(List)
    strval = str(List[0]) + tab
    for i in range(1,N-1):
        strval = strval + str(List[i]) + tab 
    
    strval = strval + str(List[N-1]) + "\n" 
    return strval

def OZSolver(r, k, Ur, rho, maxiter=1000, w_old=0.50, tol=1e-10, cr_guess=None): 
    kill=0.0
    if rho < 0.5:
        sys.exit("Fatal Error: density can't be negative")
    nr = len(r)
    w_new = 1.0 - w_old
    if cr_guess == None:
        cr = cr_initguess(Ur)
    else:
        cr = cr_guess 
 
    residual_old = 1e10
    warnings.filterwarnings('error')
    iter = 0
    while iter < maxiter:    
        try:
            ck = FourierBesselTransform(cr,r,k)
            #print "ck = ", ck
            ek = Calculate_ek(ck,rho)
            #print "ek = ", ek
            er = InvFourierBesselTransform(ek, r, k)
            #print "er = ", er
    
            cr_new = HNC_Closure(er, Ur)
            #print "cr_new = ", cr_new
        
            residual_new = np.linalg.norm(cr-cr_new)
            
            if residual_new < tol:
    #            print "Converged!! Exiting loop"
                iter = 2 * maxiter  #to break the loop
            elif residual_new == np.inf:
                print "Crashed!! Exiting loop"
		#print "residual infinite" 
		#sys.exit("Failure, can't compute prefactor")
                iter = 2 * maxiter  #to break the loop
                sys.exit("Error, can't comptue prefactor for some reason")
            else: 
    #            print "iteration  = ", iter, "residual = ", residual_new        
                cr = cr_new*w_new + cr*w_old #mixing old + new
    
            iter = iter + 1
            residual_old = residual_new
        except Warning:
            if kill==0.0:
                print "Runtime Error: lowering density for new guess", iter
                print "old density: ", rho, " , new density: ", rho-rho*0.1 
                temphr, new_cr_guess, temper = OZSolver(r,k,Ur,(rho-rho*0.1), maxiter,w_old,tol)
                cr = new_cr_guess
        
        
    hr = Calculate_hr(er, cr)
#    if cr_guess == None:
#       print cr 
    if residual_new != np.inf:
        return hr, cr, er
    else:
        return np.zeros(nr), np.zeros(nr), np.zeros(nr)

# -----------

def CreateOutput(r, hr, cr, er, OutFile):
    '''
    For diagnostics on a particular OZ solve run - write out total, direct and indirect correlations. 
    '''
    nr = len(r)
    OutFileH = open(OutFile, 'w')
    OutFileH.write('#r  h(r)  c(r)  e(r) \n')
    for i in range(nr):
        List = [r[i], hr[i], cr[i], er[i]]
        StrVal = ListToTabbedStr(List)
        OutFileH.write(StrVal)


    
    
#-----------------------------------------
#computes the prefactor used in the EOS
def genPrefactor(a,rho,drho,L,tweak=0.70):
    if a<0.0 : # catch so the try except in OZSolver does not get into infinite loop when doing aii guessing. May result in poor determination of P. Be careful 
      return 0.0
    # first we generagte r and kr
    r, k = Create_r_k(0.001,16834)
    #generate DPD potential
    Ur = DPDPotential(r,a)
    hr_plus, cr_plus, er_plus = OZSolver(r,k, Ur, rho + drho, maxiter=1000, w_old=tweak, tol=1e-10)
    hr_minus, cr_minus, er_minus = OZSolver(r,k, Ur, rho - drho, maxiter=1000, w_old=tweak, tol=1e-10)
    dhdrho = (hr_plus - hr_minus)/(2*drho)
    hr, cr, er = OZSolver(r,k, Ur, rho, maxiter=1000, w_old=tweak, tol=1e-10)
    grp = hr_plus+1.0
    grm = hr_minus+1.0
    dgdrho = (grp-grm)/(2*drho)
    gr = hr+1.0 
    # now figure out which index gives the correct answer
    gL = np.interp(L,r,gr)
    if L<1.0:
        yL = gL*np.exp(0.5*a*(1-L)**2)
    else:
        yL=gL
    logyr_deriv = np.interp(L,r,dgdrho)/np.interp(L,r,gr)
    prefactor = logyr_deriv
    return prefactor

def getlnyr(a,rho,L,tweak=0.70):
    if a<0.0:
         return 0.0
    r, k = Create_r_k(0.001,16834)
    Ur = DPDPotential(r,a)
    hr, cr, er = OZSolver(r,k, Ur, rho, maxiter=1000, w_old=tweak, tol=1e-10)
    gr = hr+1.0
    gL=np.interp(L,r,gr)
    if L<1.0:
        yL = gL*np.exp(0.5*a*(1-L)**2)
    else:
        yL=gL
    return np.log(yL)
   

def getGR(a,rho,L,tweak=0.70,crold=None):
    if a<0.0 : # catch so the try except in OZSolver does not get into infinite loop when doing aii guessing. May result in poor determination of P. Be careful 
      return 0.0
    # first we generagte r and kr
    r, k = Create_r_k(0.001,16834)
    #generate DPD potential
    Ur = DPDPotential(r,a)
    hr, cr, er = OZSolver(r,k, Ur, rho, maxiter=1000, w_old=tweak, tol=1e-10,cr_guess=crold)
    gr = hr+1.0 
    # now figure out which index gives the correct answer
    gL = np.interp(L,r,gr)
    return gL,cr


