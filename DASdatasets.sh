#!/bin/bash

# Lists all DAS datasets and nevents for "dataset_name" 
#
# first do
# > voms-proxy-init -voms cms
# the execute the script as 
# > ./DASdatasets.sh "dataset_name"
# e.g.
# > ./DASdatasets.sh "/RSGluonToTT_M-*_TuneCP5_13TeV-pythia8/RunIISummer20UL18*/MINIAODSIM"


args=("$@")
if [ $# -lt 1 ] ; then
  echo "Please provide Dataset name "
fi

if [ $# -eq 1 ] ; then
  dset=${args[0]}
fi

echo "Search dataset string:"
echo $dset


dasgoclient --query="dataset dataset=$dset" > samples_list_tmp.txt


# < below removes filename in the output of wc
echo "Total samples: " $(wc -l < samples_list_tmp.txt)

for x in $(cat samples_list_tmp.txt)
do
   echo " "
   echo $x
   dasgoclient -query="summary dataset=$x" >  samples_summary_tmp.txt
   echo "nevents =" $(cut -d : -f 4 samples_summary_tmp.txt | cut -d , -f 1)
   rm samples_summary_tmp.txt   
done

rm samples_list_tmp.txt
