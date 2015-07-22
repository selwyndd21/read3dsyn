#!\bin\bash

####################
# ERROR code: no any parameters
####################
opt=$#
if [ $opt -eq 0 ]; then
  echo "ERROR: No parameters nor inputs. Noting should be done!"
# echo
# HELP
  exit 2
fi
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Read Options and Parameters Section:
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
while getopts "t:z:" opt; do
  case $opt in
    t)
      RT=${OPTARG}
      echo "RT is $RT"
      ;;
    z)
      RZ=${OPTARG}
      echo "RZ is $RZ"
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      exit 2
      ;;
    :)
      echo " -$OPTARG requires an argument."
      exit 2
      ;;
  esac
done
shift $((OPTIND-1))  #This tells getopts to move on to the next argument.
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
# End Options and Parameters section.
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


####################
# ERROR code: check the input parameters
####################
if [ ! -f "$RT" ] && [ ! -f "$RZ" ] ; then
  echo "ERROR: no input file disignated"
  exit 2
fi

array[0]=$RT
array[1]=$RZ

# Main loop
filenum=0
for inputfile in "${array[@]}"; do
  
  case=${inputfile%\.*}
  block_num=64
  if [ "$filenum" -eq 0 ]; then
    echo "Calculating Total Flux for R-Theta, from $inputfile"
  else
    echo "Calculating Total Flux for R-Z, from $inputfile"
  fi
  
  echo "  Extract group-wise flux in each location:"
  sed -n "/^0flux/,/^1groupwise balances/p" $inputfile > temp_flux.txt
  sed -i "/^1groupwise balances/d" temp_flux.txt
  
  echo "  Separate lines into each group:"
  line_num=0
  i=0
  gr=$(printf "%02d" $i)
  while read line && [ "$i" -le 47 ] ; do
    if [[ $line == 0flux* ]]; then
      echo "    Extract group $i: $line_num lines to group_${gr}.txt"
      i=$((i+1))
      gr=$(printf "%02d" $i)
      line_num=0
    fi
    echo $line >> group_${gr}.txt
    line_num=$((line_num+1))
  done < temp_flux.txt
  echo "    Extract group $i: $line_num lines to group_${gr}.tx"
  Eg=$((i-1))
  rm temp_flux.txt
  echo "End Separate lines into Groups $0 -> $i"
  
  echo "Remove i=, j= syntax for Group: $1 -> $Eg"
  for i in $(seq -f %02g 1 $Eg); do 
    sed -i "/flux for group/d" group_${i}.txt
    sed -i "s/i=/  /g" group_${i}.txt
    sed -i "s/j=/  /g" group_${i}.txt
  done  
  
  echo "  Rearrange the groupwise data into full matrix form"
  for i in $(seq -f %02g 1 $Eg)  # $i is Group
  do
    # Remove temp files: 
    for j in $(seq -f %02g 1 $block_num); do  # matrix $j in $i group
      if [[ -f matrix_${j}.txt ]]; then
        rm matrix_${j}.txt
      fi
      if [[ -f small_${j}.txt ]]; then
        rm small_${j}.txt
      fi
    done
    if [[ -f group_${i}_array.txt ]]; then
      rm group_${i}_array.txt
    fi
    
    j=0
    echo "    Separate block data into matrix for group $i"
    while read line; do
      if [[ $line == 0* ]]; then
        j=$((j+1))
  #     echo "mtx = $mtx"
      fi
      mtx=$(printf "%02d" $j)
      echo $line >> matrix_${mtx}.txt
    done < group_${i}.txt
    block_num=$j
    
#   echo "    Tidy up $block_num matrixes in Group $i" # matrix $j in $i group
    for j in $(seq -f %02g 1 $block_num); do
      cut -d " " -f 2- matrix_${j}.txt > small_${j}.txt
    done
    cut -d " " -f 1 matrix_01.txt > small_00.txt
    
  #  echo "    Joint Each matrix to form whole Matrix"
    for j in $(seq -f %02g 1 $block_num); do # matrix $j in $i group
      if [[ -f group_${i}_array.txt ]]; then
        paste group_${i}_array.txt small_${j}.txt | expand -t 1 > tmp_fluxData
        mv tmp_fluxData group_${i}_array.txt
      else
        cp small_${j}.txt group_${i}_array.txt # Creat RawData for total flux summation in Python script
      fi
    done
  
#   echo "    Tidy up Whole Matrix in Group $i"
#   tr -s " " < group_${i}_array.txt > tmp_fluxData
#   mv tmp_fluxData group_${i}_array.txt
  done  
  
  #>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  # Flux summary
  # Arrange flux format for SCALE/COUPLE & SCALE/ORIGEN-S
  #>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  ##########
  # WARNING code: remove existing group data file
  if [[ -f "${case}_py_TotalFlux.txt" ]]; then 
    echo "!!!WARN: File '${case}_py_TotalFlux.txt' exists. It will be overwrited!!!"
  fi
  
  echo "  Flux summary: Total Flux"
  python Adding2D.py  1 $Eg ${case}_py_TotalFlux.txt
  echo "  Flux summary: Thermal Flux"
  python Adding2D.py  1  44 ${case}_py_G2.txt
  echo "  Flux summary: Fast Flux"
  python Adding2D.py 45  47 ${case}_py_G1.txt
  #<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  # Flux summary
  #<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  
  echo "  Clean up temp files"  
  rm matrix_[0-9][0-9].txt small_[0-9][0-9].txt 
  rm group_[0-9][0-9].txt
  rm group_[0-9][0-9]_array.txt
  if [ "$filenum" -eq 0 ]; then
    mv ${case}_py_TotalFlux.txt RT_TotalFlux.txt
    mv ${case}_py_G1.txt RT_G1.txt
    mv ${case}_py_G2.txt RT_G2.txt
  else
    mv ${case}_py_TotalFlux.txt RZ_TotalFlux.txt
    mv ${case}_py_G1.txt RZ_G1.txt
    mv ${case}_py_G2.txt RZ_G2.txt
  fi

  filenum=$((filenum+1))
done


