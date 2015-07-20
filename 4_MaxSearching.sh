#!\bin\bash

MinR=1     # 70
MaxR=46    # 75
MinZ=11    # 166
MaxZ=90    # 261
MinT=1     # 90
MaxT=90    # 1



echo "Processing format between layer${MinZ}.txt and layer${MaxZ}.txt"
for i in $(seq -f %03g $((MinZ)) $((MaxZ))); do
  paste Rindex.txt ORI_Layer${i}.txt | expand -t 1 >> layer${i}.txt
done

echo "Searching data between layer${MinZ}.txt and layer${MaxZ}.txt"
for i in $(seq -f %03g $((MinZ)) $((MaxZ)) ); do
  echo "  Searching R data between ${MinR} and ${MaxR} in layer${i}.txt"
  sed -n "$((MinR+1)),$((MaxR+1))p" layer${i}.txt >> Ext_layer${i}.txt
done

echo " find Maximum and position for interest region"
python Search_Max.py ${MinZ} ${MaxZ}

rm Ext_layer* Rindex.txt
