#!/usr/bin/python
import sys
import numpy as np
import os.path

print "Py: Start Python script"
print "Py:    Input RT: %s" %(sys.argv[1])
print "Py:          RZ: %s" %(sys.argv[2])
print "Py:          R : %s" %(sys.argv[3])

RT = np.loadtxt( sys.argv[1] ,skiprows=0)
print "Py: Input RT data format: (i=, j=) %s" %( str(RT.shape) )
#max_RT = np.max(RT)
#print "Py: max of RT is %5.3E" %(max_RT)

RZ = np.loadtxt( sys.argv[2] ,skiprows=0)
print "Py: Input RZ data format: (i=, j=) %s" %( str(RZ.shape) )

R  = np.loadtxt( sys.argv[3] ,skiprows=0)
print "Py: Input R  data format: (i=, j=) %s" %( str(R.shape) )


f_pwr = 3.849E+12
print "Py: All flux are normalized to power density: %5.3E" %(f_pwr)
f_RT = f_pwr / 9.20000E+16 * 2.36770E+04 # source and volume in region 7
f_RZ = f_pwr / 1.40210E+20 * 3.36380E+07 # source and volume in region 21-45
f_R  = f_pwr / 3.68000E+17 * 8.82887E+04 # source and volume in region 6
print "Py: normalize factor for RT: %5.3f, RZ: %5.3f, R: %5.3f" %(f_RT, f_RZ, f_R)

Rtitle= np.arange(0,112)
np.savetxt("Rindex.txt", Rtitle, fmt="%03d")

for z in range(0, 512, 1): # 0, 512, 1
  data = np.zeros(RT.shape) 
  for theta in range(0, 90, 1): # 0, 90, 1
    for r in range(0, 111, 1): # 0, 111, 1
      data[r][theta] = RT[r][theta] * f_RT * RZ[r][z] * f_RZ / R[r] / f_R
  string =  "ORI_Layer" + str(z+1).zfill(3) + ".txt"
  layer = "Layer" + str(z+1).zfill(3) + " (R-Theta)"
  np.savetxt( string, data, fmt='%5.3E', header=layer, comments='')

print "Py: End Python script"
