
# Set the path to the local SRA databases
SRA_PATH="$HOME/databases/sra" # change the path if necessary

# select SRA objects to download
declare -a arr=( \
  "SRP106137"
  "SRP148435"
  "SRP106691"
  "SRP034435"
  "SRP043706"
  "PRJNA386947"
)

# get metadata of SRA objects from NCBI
echo -n > runinfo.csv 
for i in "${arr[@]}"
do
  esearch -db sra -query $i | efetch -format runinfo >> runinfo.csv
  sleep 0.34 # to get ca. 3 requests / second (see NCBI guidelines)
done
sed -i '1!{/^Run/d;}' runinfo.csv 
sed -i '/^$/d' runinfo.csv 


# downloaded the samples
cut -d',' -f25 < runinfo.csv | tail -n +2 > sra_samples.txt 
prefetch --option-file sra_samples.txt -O $SRA_PATH

# get metadata of samples
cut -d',' -f26 < runinfo.csv | tail -n +2 > sra_samples_data.txt 
echo -n > sra_samples_metadata.txt 
IFS=$'\n'
set -f
for i in $(cat < sra_samples_data.txt); do
  esearch -db biosample -query $i | efetch -format native >> \
    sra_samples_metadata.txt
done

# samples metadata to table
if test -f ./scripts/ncbi_data_analysis/fetch_gb.py
then
  echo "ncbi_data_analysis found"
else
  git clone https://github.com/jgmv/ncbi_data_analysis.git \
    scripts/ncbi_data_analysis
  for i in scripts/ncbi_data_analysis/*.py
  do
    chmod +x $i
  done
fi
export PATH="$PATH:scripts/ncbi_data_analysis"
get_metadata_from_BioSample.py sra_samples_metadata.txt -o \
  sra_samples_metadata.csv

# end
