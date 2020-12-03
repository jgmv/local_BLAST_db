# local_BLAST_db
Create or update a local BLAST database, including aliases for comparison of
fungal sequences.

### update_blast_nt.sh
Automatically downloads the BLAST nt database from the NCBI FTP server ([ftp://ftp.ncbi.nlm.nih.gov/blast/db/](ftp://ftp.ncbi.nlm.nih.gov/blast/db/)). The log with the updated dates can be found at: `$HOME/databases/blast/blast_updates.log`

The script also prepares aliases of the database for particular searches. These are included in the following databases:
* `fungalITS`: Fungal ITS sequences.
* `fungalITS-id`: Fungal ITS sequences with full species names.
* `fungalRefs`: Sequences from fungal strains in reference collections.
* `fungalType`: Sequences from fungal type material.
* `fungalSeq`: Fungal sequences.
* `eukSeq`: Eukaryote sequences.

### update_blast_sra.sh
Prepares a local database with selected SRA objects. Selected objects can be added to the list within the script, where `# select SRA objects to download`.  
