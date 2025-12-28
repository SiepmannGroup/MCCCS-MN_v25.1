import numpy as np
from scipy.integrate import simps
from scipy.optimize import newton
from scipy.optimize import leastsq,brentq
from scipy.special import erf
import DPD_OZ as doz

# this file conatains all of the support functions needed for the chain-DPD project.
# it essentially computes all of the Pressure values using the EOS. Cavity correlation calculations
# are taken care of in the external module DPD_OZ

# ----------------------
    #computes the monomver B2 exactly
def monoB2(aii):
    firstterm = -1.0/3.0
    secondterm = (np.exp(-aii/2.0)-2.0)/aii
    thirdterm = (1.0+aii)*(np.sqrt(np.pi/2.0))*erf(np.sqrt(aii/2.0))/(aii**(1.5))
    fullvalue = -2.0*np.pi*(firstterm+secondterm+thirdterm)
    return fullvalue

    # power function for getting correct l->0 limit
def pfun(l):
    return 1.0/(1+l)**3.0



def getChainB2(N,l,aii):
    A = 1.97233820401 
    delta = 1.26290426658
    gamma = 1.01216631979
    C = 0.932720674548 
    nfact=A*(l**delta)*(((1.0-C)*N**2+C*N-1)**gamma)+1
    return nfact*monoB2(aii*N**(2*pfun(l)))


def fswitch_B2(rho): 
    f_B2 =  1/(1 + rho**3)
    return f_B2
# ----------------------

def fswitch_a(rho):
    c1 =  0.079; c2 = 2.0; c3 =  0.77       
    return c1*rho**c2/(1 + c3*rho**c2)



# compute the pressure of a monomer fluid. This function is deprecated and can be replaced with one of the later functions
def getmonoP(rho,aii):
    return rho+fswitch_B2(rho)*monoB2(aii)+fswitch_a(rho)*aii*rho**2

def getGWP(rho,aii):
    return rho+aii*0.101*rho**2

# utility function for dtermining the difference between target pressure and EOS for rGW-EOS
def pressDifference(aii,rho,targetP):
    return targetP-getmonoP(rho,aii)


# computes the pressure for rcGW-EOS when the prefactor is supplied. the prefactor is defined as prefactor = rho^2 * d/d\rho(r*) [y(r*)]
def P_crGW_EOS(a,rho,prefactor,m,L):
    alpha = 41.0830061128 
    beta = 1.96693516628
    # before you lose your mind over this next line of code recall that the prefactor = rho^2 * d/d\rho(r*) [y(r*)] From the jan 26 email from sumanth 
    P = rho/m+(rho/m)**2*getChainB2(m,L,a)*fswitch_B2(rho/m)+fswitch_a(rho)*(a*rho**2-alpha*((m-1)/(m+beta))*prefactor)
    return P

# computes the pressure for the rcGW-EOS when no prefactor is supplied. 
def P_crGW_EOS_OZ(ain,rhoin,mn,Lin):
    a=float(ain)
    rho=float(rhoin)
    m=float(mn)
    L=float(Lin)
    if (m == 1.0):
       dyldrho=0.0
    else:  
       dyldrho = doz.genPrefactor(a,rho,0.001,L)

    P = P_crGW_EOS(a,rho,(rho**2)*dyldrho,m,L)
    return P


# ---------------------------------------------------------------
# utility function to compute the quadratic dependence on number of beads in a chain
def mfrac(m):
    beta = 1.96693516628 
    return (m-1)/(m+beta)


# utility function to compute the quadratic dependence on number of beads in a chain
def mfactor(Psim,a,rho,prefactor,m,L):
    alpha = 41.0830061128 
    beta = 1.96693516628 
    numerator = -1*(Psim-rho/m-(rho/m)**2*getChainB2(m,L,a)*fswitch_B2(rho/m))+fswitch_a(rho)*a*rho**2
    denominator = fswitch_a(rho)*alpha*prefactor # note that the rho^2 factor is built into the prefactor as provided by sumanth. I may want to replace this on down the road at somepoint to avoid confusion
    return numerator/denominator

##### I really don't like how the rho^2 is built into the prefactor
##### it makes things confusing. Possibly change in future update



# compute the athermal interaction paramter using the bead density of the pure fluid
def athermalhb(a,rho,m,L):   #rho here is the bead density
    if (m == 1.0):
       dyldrho = 0.0
    else:
       dyldrho = doz.genPrefactor(a,rho,0.001,L)
    mpart = mfrac(m)
    alpha = 41.0830061128
    secondterm=fswitch_a(rho)*(1.0-(alpha/a)*mpart*dyldrho)*(m**2)
    firstterm=fswitch_B2(rho/m)*getChainB2(m,L,a)/a
    fullh=firstterm+secondterm
    return fullh

#compute the athermal interaction parameter using the molecule density of th pure fluid. Will be converted to bead density
def athermalhm(ain,rhomin,mn,lin):
    a=float(ain)
    rhom=float(rhomin)
    m=float(mn)
    l=float(lin)
    rhob = rhom*m
    return athermalhb(a,rhob,m,l)

# called by aij program to compute the aij factor. It sends all of the right variables to the right places and returns aij
def aijterm(a11in,rhom1in,m1in,l1in,a22in,rhom2in,m2in,l2in):
    # input protection. force conversion to floating point or math goes wonky
    a11 = float(a11in)
    rhom1 = float(rhom1in)
    m1 = float(m1in)
    l1 = float(l1in)
    a22 = float(a22in)
    rhom2 = float(rhom2in)
    m2 = float(m2in)
    l2 = float(l2in)
    h1 =  athermalhm(a11,rhom1,m1,l1)  # save on computational time
    h2 =  athermalhm(a22,rhom2,m2,l2)
    numerator = h1*a11*(rhom1**2)+h2*a22*(rhom2**2)
    denominator=2*rhom1*rhom2*(h1*h2)**(0.5)
    aij = numerator/denominator
    return aij

#compute the excess chemical potential for a given set of parameters
# here we compute the chemical potential for a monomer
def monomerMuex(aij,rho0):
    a = 0.00323
    b = 0.00439
    c = 50.9
    d = 0.790
    return (1.0-np.exp(-aij*(a*rho0+b)))*(c*rho0/(1.0+d*rho0))

# here we compute the chemical potential for a chain using the developed approximation
def muex(aij,mi,li,rho0):
    singleBeadMuex=monomerMuex(aij,rho0)
    if mi == 1.0:
       return singleBeadMuex
    else :
       # comptue the lower limit
       lowlim = monomerMuex(mi*aij,rho0)
       upperlim = mi*singleBeadMuex
       # now compute values for the switching functions
       lowerswitch = 1.0/(1.0+2.8239*li**3.0)
       upperswitch = 1.4851*(li**2.0)/(1.0+0.46562*(li**2.0))
       return lowlim*lowerswitch+upperlim*upperswitch

#compute the flory-huggins chi value for a given set of parameters
def fhchi(rho0i, rho0j, aii, ajj, aij,li,lj,mi,mj,rhoref, RT):
    # note that due to current approximations, some of these values are irrelevant, but this will need to be corrected at somepoint
    return (0.5/(RT*rhoref))*(rho0i*(muex(aij,mi,li,mj*rho0j)-muex(aii,mi,li,mi*rho0i))+rho0j*(muex(aij,mj,lj,mi*rho0i)-muex(ajj,mj,lj,mj*rho0j)))

# compute the aij value for a given chi parameter
def getaijThermal(targetchi, RT, rho0i, rho0j, aii, ajj, li,lj,mi,mj, rhoref, highguess):
    # we will iteratviely try different values of aij using Brent's algorithm. This will require us to defie a new fucntion
    aijsolution = brentq(rootedchi,0.0,highguess,rtol=0.00001, args=(targetchi, RT, rho0i, rho0j, aii, ajj, li,lj,mi,mj, rhoref, highguess))
    return aijsolution

def rootedchi(aij, targetchi, RT, rho0i, rho0j, aii, ajj, li,lj,mi,mj, rhoref, highguess):
    return targetchi-fhchi(rho0i, rho0j, aii, ajj, aij, li,lj,mi,mj, rhoref, RT)

def testmuex(aij,mi,li,rho0):
    singleBeadMuex=monomerMuex(aij,rho0)
    lnyr=doz.getlnyr(aij,rho0,li)
    return mi*singleBeadMuex+(1.0-mi)*lnyr

def separatetestmuex(aij,mi,rho0,li):
    singleBeadMuex=monomerMuex(aij,rho0)
    lnyr=doz.getlnyr(aij,rho0,li)
    return mi*singleBeadMuex,(1.0-mi)*lnyr

