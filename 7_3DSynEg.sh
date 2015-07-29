#!\bin\bash


for i in $(seq -w 1 47); do
  python ThreeDSynthesis.py $i RT_group_${i}_array.txt RZ_group_${i}_array.txt input_anisn_grp_${i}
done

for i in $(seq -w 1 90); do
  mkdir ThetaData$i
  mv Eg[0-4][0-9]_Theta${i}.txt ThetaData$i
done
