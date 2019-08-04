#!/bin/bash

# Set the path to the local BLAST databases
BLAST_PATH="$HOME/databases/blast" # change the path if necessary

# download necessary scripts from GitHub
if test -f ./scripts/search_ncbi_gi_by_term.py
then
  echo "./scripts/search_ncbi_gi_by_term.py found"
else
  git clone https://github.com/jgmv/ncbi_data_analysis.git scripts
fi


# Download BLAST nt files from NCBI's FTP server
wget "ftp://ftp.ncbi.nlm.nih.gov/blast/db/nt.*.tar.gz" -P $BLAST_PATH

# Download the taxonomy information
wget "ftp://ftp.ncbi.nlm.nih.gov/blast/db/taxdb.tar.gz" -P $BLAST_PATH

# Add update date as record to log file (blast_updates.log)
if [ -f $BLAST_PATH/blast_updates.log ]
then
    echo "BLAST nt database update: "$(date -R) >> $BLAST_PATH/blast_updates.log
else
    echo "BLAST nt database update: "$(date -R) > $BLAST_PATH/blast_updates.log
fi

# Decompress the downloaded files (overwrites pre-existing files)
gunzip -f $BLAST_PATH/*.gz

# Extract tarball files
for i in $(ls $BLAST_PATH/*.tar); do tar -xf $i -C $BLAST_PATH; rm $i; done

# Remove tarball files
#rm $BLAST_PATH/*.tar

# Create alias containing only Eukaryota sequences (eukSeq)
#search_ncbi_gi_by_term.py "Eukaryota[Organism] NOT Genome NOT Chromosome" \
#  -o $BLAST_PATH/eukSeq.gi
#blastdb_aliastool -db nt -gilist $BLAST_PATH/eukSeq.gi -dbtype nucl \
#  -out $BLAST_PATH/eukSeq -title "Eukaryota sequences"

# Create alias containing only fungal sequences (fungalSeq)
python scripts/search_ncbi_gi_by_term.py "Fungi[Organism] NOT Genome NOT Chromosome" \
  -o $BLAST_PATH/fungalSeq.gi
blastdb_aliastool -db nt -gilist $BLAST_PATH/fungalSeq.gi -dbtype nucl \
 -out $BLAST_PATH/fungalSeq -title "Fungal sequences"

# Create alias containing only fungal ITS sequences (fungalITS)
python scripts/search_ncbi_gi_by_term.py "Fungi[Organism] AND (internal transcribed spacer OR ITS OR ITS1 OR ITS2) NOT Genome NOT Chromosome" \
  -o $BLAST_PATH/fungalITS.gi
blastdb_aliastool -db nt -gilist $BLAST_PATH/fungalITS.gi -dbtype nucl \
  -out $BLAST_PATH/fungalITS -title "Fungal ITS sequences"

# Create alias containing only fungal ITS sequences with full species names (fungalITS-id)
python scripts/search_ncbi_gi_by_term.py "Fungi[Organism] AND (internal transcribed spacer OR ITS OR ITS1 OR ITS2) NOT uncultured NOT fungus NOT endophytic NOT sp. NOT sp NOT cf NOT cf. NOT aff NOT aff. NOT mycorrhizal NOT Genome NOT Chromosome" \
  -o $BLAST_PATH/fungalITS-id.gi
blastdb_aliastool -db nt -gilist $BLAST_PATH/fungalITS-id.gi -dbtype nucl \
  -out $BLAST_PATH/fungalITS-id -title "Fungal ITS sequences with full species names"

# Create alias containing only fungal sequences from fungal strains in reference collections (fungalRefs)
python scripts/search_ncbi_gi_by_term.py "Fungi[Organism] AND (CBS OR NRRL OR AFTOL) NOT Genome NOT Chromosome NOT Environmental NOT Uncultured" \
  -o $BLAST_PATH/fungalRefs.gi
blastdb_aliastool -db nt -gilist $BLAST_PATH/fungalRefs.gi -dbtype nucl \
  -out $BLAST_PATH/fungalRefs -title "Fungal strains in reference collections"

# Create alias containing only fungal sequences from fungal type material (fungalType)
python scripts/search_ncbi_gi_by_term.py "Fungi[Organism] AND type material NOT Genome NOT Chromosome NOT Environmental NOT Uncultured" \
  -o $BLAST_PATH/fungalType.gi
blastdb_aliastool -db nt -gilist $BLAST_PATH/fungalType.gi -dbtype nucl \
  -out $BLAST_PATH/fungalType -title "Sequences from fungal type material"

# end
