#!/usr/bin/python
import sys
import numpy as np
import os.path

print "Py: Start Python script"
print "Py: Python Input: %s group  Output: %s." %( sys.argv[1], sys.argv[2] )

# declare x size with first group
string = "group_01_array.txt" # group_3_array.txt
data = np.loadtxt( string ,skiprows=1)
print "Py: Input Data format: (i=, j=) %s" %( str(data.shape) )
x=np.zeros(data.shape)

for i in range(1, int( sys.argv[1] )+1, 1):
  string = "group_" + str(i).zfill(2) + "_array.txt" # group_3_array.txt
  data=np.loadtxt( string ,skiprows=1)
  x = x + data
#  print "Py: data[82][0]=%5.3E x[82][0]=%5.3E for Eg=%d" %(data[82][0], x[82][0], i)

np.savetxt( sys.argv[2], x, fmt='%5.3E' )
print "Py: End Python script"
