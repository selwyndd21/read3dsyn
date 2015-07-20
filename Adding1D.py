#!/usr/bin/python
import sys
import numpy as np
import os.path

print "Py: Start Python script"
print "Py: Python Input: %s" %( sys.argv[1] )
print "Py: Output: %s & %s." %( sys.argv[2], sys.argv[3] )
RawData = np.loadtxt( sys.argv[1] ,skiprows=1)

if RawData.ndim == 1:
  print "Py: Input array dimension: %d" % RawData.ndim
  AllReg_PerGrp = np.array( [np.sum(RawData)] )
  AllGrp_PerReg = RawData.copy()
elif RawData.ndim == 2:
  print 'Py: Input Data format: {} (regions numbers, group numbers)'.format(RawData.shape)
  AllReg_PerGrp = np.sum(RawData, axis=0) # Find flux spectrum
  AllGrp_PerReg = np.sum(RawData, axis=1) # Find flux distribution
else:
  print 'Py: Input Data format: {} (regions numbers, group numbers)'.format(RawData.shape)
  print "Py: ERROR!, input array dimension > 2"
  sys.exit(1)


np.savetxt( sys.argv[2], AllGrp_PerReg, fmt='%5.3E' )
np.savetxt( sys.argv[3], AllReg_PerGrp, fmt='%5.3E' )
print "Py: End Python script"
