#!/usr/bin/python
import sys
import numpy as np
import os.path

print "Py: Start Python script"
print "Py:    Input MinZ: %s" %(sys.argv[1])
print "Py:          MaxZ: %s" %(sys.argv[2])
MinZ=int(sys.argv[1])
MaxZ=int(sys.argv[2])

Max_flux=0.00

for i in range(MinZ, MaxZ+1, 1):
  string = "Ext_layer" + str(i).zfill(3) + ".txt"
# print "Py: Load RT data from: %s" %(string)
  RT = np.loadtxt( string ,skiprows=0)
# print "Py: Input RT data format: (i=, j=) %s" %( str(RT.shape) )
  Maxlocal=RT.max()
  print "Py:   local Max flux : %5.3E at %s in %d layer" %(Maxlocal, str( np.unravel_index(RT.argmax(), RT.shape) ), i )
# print "Py:      \"Note that the Coordinate is shifted!\""
  if Maxlocal > Max_flux :
    Max_flux = Maxlocal
    coord    = str( np.unravel_index(RT.argmax(), RT.shape) )
    layer    = i
# print "Py:   Glocal Max flux: %5.3E at %s in %s layer" %( Max_flux, coord, layer )

print "Py:   Glocal Max flux: %5.3E at %s in %s layer" %( Max_flux, coord, layer )
print "Py: End Python script"
