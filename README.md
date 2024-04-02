# Building custom reference databases for metabarcoding
This pipeline can be used to develop a de-contamination database (i.e used to create a database of potential contaminants), or as a database for general purpose metabarcoding. We have provided three databases - a very small database composed of common contaminants (i.e human, sheep, goat, flies etc), as well as two metabarcoding databases for marine eukaryotes. 

These scripts support the MARES (MARine Eukaryote Species) pipeline used to create the MARES database of COI sequences for metabarcoding studies (presented in [Arranz, V., Pearman, W.S., Aguirre, J.D. & Liggins, L. MARES, a replicable pipeline and curated reference database for marine eukaryote metabarcoding. Sci Data 7, 209 (2020)](https://doi.org/10.1038/s41597-020-0549-9)). The scripts are designed to be run using a Linux OS, and were developed on Ubuntu 16.04. If you use windows, you may be able to use the Windows Linux subsystem (https://docs.microsoft.com/en-us/windows/wsl/install-win10) but you may have additional dependencies to install that aren't covered by the list below. 

![Flowchart](https://github.com/wpearman1996/MARES_database_pipeline/blob/master/Flowchart_metabarcodingdb.svg)
*The MARES bioinformatic pipeline for generating a custom reference database combining sequences retrieved from the Barcode of Life Database (BOLD) and NCBI for a taxonomic group of interest. Shaded boxes detail the workflow within each step and the names of the scripts required. Smaller open boxes describe the subroutines including the functions, packages, and software required (in italics). Boxes with solid outlines indicate input files and boxes with dotted-lined boxes indicate the output files. Many of the scripts and functions used in the MARES pipeline were developed by others; asterisks denote the original contributions of the MARES pipeline.*

## Before using MARES pipeline 
Installing some of the dependencies can be problematic. We provide two options to set up the dependencies in your computer before running the step-by-step MARES pipeline. 

Chose one of the two Option below to set up the dependencies in your computer: 

### OPTION 1. DOCKER container (recommended)

**What is a Docker container-image?**

"A container is a standard unit of software that packages up code and all its dependencies so the application runs quickly and reliably from one computing environment to another. A Docker container image is a lightweight, standalone, executable package of software that includes everything needed to run an application: code, runtime, system tools, system libraries and settings." Learn more: https://www.docker.com/resources/what-container

We have built a **Docker image for MARES** and you can pull it in your computer (regardless the operting system you have) with 3 main steps and... forget about installing dependencies locally. It will be all ready to go! You can follow the step-by-step MARES pipeline to create your own custom made reference sequence database.

#### Steps to use MARES Docker image

1. Install Docker : https://docs.docker.com/get-docker/

In the command-line:

2. Pull MARES Docker image from Docker Hub : https://hub.docker.com/r/vanearranz/mares
```
docker pull vanearranz/mares
```
3. Run the MARES container in interactive mode. This means you can execute commands inside the container while it is running.
```
docker container run -it vanearranz/mares /bin/bash
```
Make sure you are in MARES folder to follow the steps: 
```
cd MARES
```

*NOTE: The text editor installed in MARES image is ```vim```. More information on how to use vim text editor: https://www.arubacloud.com/tutorial/how-to-instal-and-use-vim-text-editor-on-linux-ubuntu.aspx*  

### OPTION 2. Install the dependencies locally in your computer 

Installation of dependencies for ubuntu 20.04 - please note this is an evolving section and may not work on all systems. 

### Dependency List

`vsearch`
`BLAST+`
`cpanminus`
`biopython`
`Bio::Lite::Taxonomy::NCBI`
`Bio::DB::EUtilities`
`HTTP::Date`
`LWP::Simple`
`LWP::UserAgent`
`parallel`
`perl`
`r`
`python2`
`seqtk`
`Kraken2`

#### + R packages
`stringr`
`rvest`
`httr`
`taxize`
`dplyr`
`bold`
`betapart`
`stingi`
`qdapDictionaries`
`splitstackshape`
`taxizedb`
`readr`
`optparse`

The following commands should help you install the dependencies and get started. If you don't have sudo access, then execute the cpanm commands without the `sudo`, and it will give you an explanation of how to install it without sudo access.

        sudo apt-get install cpanminus
        sudo apt-get install parallel
        conda install -c bioconda BioPython
        conda install -c bioconda seqtk
        conda install -c bioconda seqkit
        wget https://cpan.metacpan.org/authors/id/M/MI/MIROD/XML-DOM-XPath-0.14.tar.gz
        tar xvzf ./XML-DOM-XPath-0.14.tar.gz

Then modify the file at t/test_non_ascii.t and change line 9 from "use encoding 'utf8';" 
to "use utf8;" - https://stackoverflow.com/questions/47966512/error-installing-xmldomxpath

        rm XML-DOM-XPath-0.14.tar.gz 
        tar -czvf XML-DOM-XPath.tar.gz XML-DOM-XPath-0.14 
        cpanm XML-DOM-XPath.tar.gz

Generally we suggest not using conda to install the perl modules, as this seems to cause dependency issues. We recommend to install the perl modules with cpanm. 

        sudo cpanm Encode
        sudo cpanm HTTP::Date
        sudo cpanm Bio::LITE::Taxonomy::NCBI
        conda install -c bioconda perl-bio-eutilities
        sudo cpanm LWP::Simple --force
        sudo cpanm LWP::UserAgent --force
        
#### Because MARES relies on a local copy of the NCBI taxonomy, the locations of these files must be specified prior to running the pipeline. Where indicate below, you should adjust the scripts to point to the location of the nodes.dmp and names.dmp files from the NCBI taxdump file - ftp://ftp.ncbi.nlm.nih.gov/pub/taxonomy/taxdump.tar.gz.



# MARES pipeline

Either you choose Option 1 or 2 to set up your dependencies, now you are ready to start running the step-by-step MARES pipeline and build your own custom reference sequences database for taxonomic classification of your metabarcoding data! 

You need to run each of the following steps in order and choose different parameters to customise your database in the different steps of the pipeline (see MODIFICATIONS in each step of the pipeline). 

First, download the contents of this repository if you chose running MARES pipeline locally (Option 2). If you chose Docker contaoner option (Option 1) the contents of the repository are already in the Docker image. 
Note: make sure you are in the same folder as the steps scripts to run the pipeline. 

May the force be with you!


### List of Files that need modification before running the step-by-step MARES pipeline

Email authentification: 
* ./coi_ret/ebot_taxonomy3.plx - line 86 requires email   ### done on 01.04.2024
* ./coi_ret/grab_many_gb_catch_errors_auto_CO1_year.plx - line 32 requires email  ### done on 01.04.2024

NCBI taxonomy - modify only if OPTION 2 was used to install dependencies. 
* ./coi_ret/taxonomy_crawl_for_genus_species_list.plx lines 29 and 30 require location of names.dmp and nodes.dmp files
* step4a_taxid_addition.r - line 75, may need to change location of nodes.dmp and names.dmp 


## Step 1: NCBI COI Retrieval 

First, it is necessary to modify the **taxa.list** file - this file contains the list of taxa that you are interested in. 
You can use different lists for BOLD or NCBI, or the same for both. 

############# 04.02.2024 ################

# i wanted to include alternate taxa list of marine species 

(1)
### all accepted marine antarctic species from marine antartic register (no terrestrial classification) (Bioinformatics Documentation/RAMS_taxlist_20240402_acceptedonly) [912 records of family names] named taxa1.list 

(2) 
### all accepted marine anctactic species from marine antarctic regsiter (terrestiral included)
 to access full list need to register [1664 records of family names]

(3)
 ### all accepted antarctic species from WoRMS antartic register 
 to access full list need to register [5961 records of family names]

Then, from the terminal run the Step1 script :

```
sh step1_NCBI_COI_Retrieval.sh  
```

which does the following:

1. Converts your list of taxa (i.e. taxa.list) into a list of taxids for every species. For example, "Chordata" will be turned into a list of taxids for every species found in Chordata.
2. Converts taxids to binomial names that can be searched for in NCBI.
3. Searches NCBI and downloads all relevant genbank files (.gb format).
4. Convert genbank files to fasta files 

**MODIFICATIONS**

- If you want to modify the search terms to include additional genes or keywords, modify line 29 in the following script ./coi_ret/grab_many_gb_catch_errors_auto_CO1_year.plx  

- *By default* : Script to grab COI records from NCBI nucleotide database using 4 COI search terms, for all Eukaryota, from 2003 to 2021, with the BARCODE keyword
        - edit the CO1 term to look for other barcode of interest ex. "COXI\"[GENE]
        - edit the search term below for one year or many years ex. 2017 or 2003:2021[PDAT]
        - edit whether you want to match the BARCODE in the keyword field or remove it ex. BARCODE[KYWD]

Note - if there are no sequences in NCBI for any of your chosen taxa, this will return an error:
"Use of uninitialized value $count in numeric lt (<) at ../../coi_ret/grab_many_gb_catch_errors_auto_CO1_year.plx line 58."


## Step 2: BOLD Retrieval

The Step2_retrieve_bold.r script takes a list of taxa from **taxa.list** and retrieves the BOLD genetic data, and formats this data as a fasta file. 

This can take a while for large taxonomic groups, and may timeout when connecting to BOLD if you do not have large amounts of RAM. If this does become problematic, it may be wise to remove this group from your taxlist, replacing it with the subtaxa for that group to avoid timing out. 

For BOLD retrieval, run the R script : 
```
r step2_retrieve_bold.r
```

**MODIFICATIONS**

- *By default* it uses same **taxa.list** as in the previous step. If different, you have to specify the taxa list files you wish to use on line 48 in the step2_retrieve_bold.r script. 

- If you want to modify the search terms to include additional genes (barcodes), you can specify on line 6 in the step2_retrieve_bold.r script.


## Step 3: The BOLD_NCBI merger

The Step 3 BOLD_NCBI merger is based largely on Macher J, Macher T, Leese F (2017) Combining NCBI and BOLD databases for OTU assignment in metabarcoding and metagenomic datasets: The BOLD_NCBI _Merger. Metabarcoding and Metagenomics 1: e22262. https://doi.org/10.3897/mbmg.1.22262

This process takes the BOLD file, ensures it is for the COI-5P region, and processes the names to enable dereplication of sequences and the merging of sequences from NCBI and BOLD into a single file. Last, the headers are reformatted, and the sequences converted to single line fasta format.

Run the script : 
```
sh step3_merge_bold_ncbi.sh
```

**MODIFICATIONS**

- You may need to modify Step3_merge_bold_ncbi.sh on line 6 to specify the name for your reference database. *By default : "database".*

- You may want to modify the script in line 42 to a greater max sequence length, as vsearch defaults to 50KB (which means it is unlikely to get many plant or algal mitogenomes).

- The step also removes a list of accessions that can be provided by a user. This is the **blacklisted_accessions.txt** file that will allow removal of accesion numbers and corresponding DNA sequences. In case there are certain accessions (i.e ones that you know have the wrong species associated with the sequence) that you wish to remove from the database.

**blacklisted_accessions.txt** - this file contains a list of accessions that you do not want included in your database. This should include BOTH NCBI and BOLD accessions. For BOLD the accession should be formatted as ABCI122225-19 (example case), while NCBI accessions should be WITHOUT the version i.e AC1234 rather than AC1234.1. 


## Step 4: Normalise taxonomy IDs

Many taxonomic classifiers software use lowest common ancestor (LCA) approaches for taxonomic classification, and rely on the NCBI taxonomy to do this. However, many species do not have taxonomic identification number (taxid) in NCBI or have been uploaded with synonym names, making the retrieval of reliable taxonomic classifications difficult.

In our pipeline, we identify any synonyms and consolidate them so that each taxon has only one name, and is provided with the appropriate taxid. If a taxon does not have a taxid assigned, we will create a new one based on the genus name and incorporate this into the nodes and names dmp files. This only occurs if the genus name is unique taxonomically (i.e "Acanthocephala" is both a genus of fly, and phylum of worms, as a result of ambiguous naming, we do not assign a taxid). If a taxid cannot be assigned because the genus was not able to be identified, then the sequence is removed from the database.

To normalise the taxonomic IDs we first export a list of sequence names from the merged BOLD and NCBI database.

We then generate two lists of sequence names - the first is the original sequence names, for sequences that have taxids. The second is the new set of names for the sequences, that now are in a standardized format, with taxid included in the seq name. We use these lists to rename and generate a new fasta called *databasename_BOLD_NCBI_sl_reformatted.fasta* which is now our completed database.

Run the following commands in order : 
```
r step4a_taxid_addition.r
```
```
sh step4b_taxid_generation.sh
```
```
r step4c_taxid_processing.r
```
```
sh step4d_taxid_processing.sh
```

Optional, Step4e remove sequences that have excessive numbers of ambiguous bases (N), and trim leading or trailing Ns.

```
sh step4e_Ncorrection.sh
```

**MODIFICATIONS**

If you have changed the name of your database, you should also specify it in: 

- step4a_taxid_addition.r: modify the file name of the sequences in line 3. *By default: seqnames_database_nobarcode.txt*

- step4d_taxid_processing.sh: modify the database name in line 3 to your chosen database name. *By default: database*

- step4e_Ncorrection.sh: modify the database name in line 3 to your chosen database name. *By default: database*

In step4e_Ncorrection.sh you can adjust the percent of maximum ambiguous bases (N) that you sequences can contain in line 10. Any sequence containing > percent N will be removed. *By default : 10%.*



**YOUR CUSTOM REFERENCE DATABASE IS COMPLETED!!**
---
You can find it in the main folder of the repository **MARES_database_pipeline/yourdatabasename_db.fasta**
OR
In Docker **MARES/yourdatabasename_db.fasta**

Feel free to use this reference sequence database fasta file OR move to the next Step 5 (5a. Kraken2 or 5b.MEGAN) to format the fasta file for taxomic classifiers. 



## Step 5: Format for taxonomy classifiers

### 5a : Prepare for KRAKEN2

At this point, we want to format our database for taxonomic classification using Kraken2. For this to work the header for each fasta needs to be reformatted to kraken:taxid|{taxid}. Run the following script to generate the Kraken2 database: 

```
sh step5_make_krakendb.sh
```
You will need to adjust the code on line 3 of step5_make_krakendb if you have changed the name of your database. *By default: database.*

More information on how to use KRAKEN2 : https://github.com/DerrickWood/kraken2/wiki/Manual#kraken-2-databases
Citation: Wood DE, Lu J, Langmead B. Improved metagenomic analysis with Kraken 2 (2019). Genome Biology. 2019 Nov;p. 76230. https://doi.org/10.1186/s13059-019-1891-0

### 5b : Prepare for MEGAN 

In this step, we build a BLAST database with our custom made reference sequences. More information: https://www.ncbi.nlm.nih.gov/books/NBK569841/

```
sh step5b_prepare_to_MEGAN.sh
```

Specifically, our script : 
- Trims the fasta file names to just the accession.
Because BLAST imposes length limits on the sequence names, we trim the sequence names down to just the accession. If you wish to retain that information after classification, then the information is available in the *yourdatbase*_informative_name_table.tsv file. 
- Generates an additional file mapping the accesion numbers to taxids, called **cust_taxid_map**.
- Use ```makeblastdb``` to build a BLAST database with your custom made reference sequences.  

- Create a new folder with the relevant files to use your CUSTOM MADE REFERENCE DATABASE for taxonomic assignment. 

**NOTE**: At this point you can export the relevant database files from the Docker container to your local computer to use YOUR CUSTOM MADE REFERENCE DATABASE for taxonomic assignment. 

In your local command-line: 
```
docker cp <containerId>:/file/path/within/container /host/path/target
```

**ADDITIONAL NOTES**
Before import it to MEGAN you should Blast the fasta file containing your metabarcoding sequences against the database you just built. Adjust blast settings according to your needs. More information: https://www.ncbi.nlm.nih.gov/books/NBK279684/

```
# Example
blastn -db yourcustommadedatabase -query yourmetabarcodingreads.fasta -evalue 1e-60 -outfmt 5 -out yourdesiredpath/megan.txt -num_threads 8
```
The output is a XML Blast output that can be imported into MEGAN (Husson et al. 2007) for taxonomic assignment using Lower Common Ancestor (LCA) algorithm. 

MEGAN is freely available at http://www-ab.informatik.uni-tuebingen.de/software/megan.
Citation : Huson, D. H., Auch, A. F., Qi, J., & Schuster, S. C. (2007). MEGAN analysis of metagenomic data. Genome research, 17(3), 377-386. https://doi.org/10.1101/gr.5969107

## Step 6 : Marine and contaminants check

We suggest that users ensure their database is representative of not only the taxa they expect to encounter, but also of possible contaminants. One way to do this is to include potential contaminants in your taxa list. The other way is to create a separate contaminant list. In our MARES database, we have opted for the latter. This enables you to screen your sequence reads for contaminants, and remove them, before processing and further analysing your data. Alternatively, you could merge these two databases (i.e. fasta files) together. 

In our workflow, we provide scripts that help trawl through your sequence reads, and taxa list, and provide a list of reads or taxa that are potentially contaminants and/or marine species.

> Run the the R script step6_marine_contaminants_checker.R in R. 

You can then use the *step6_marine_contaminants_checker.R* script on the taxonomically classified sequences output from MEGAN and Kraken2, and it will flag potential contaminants (based on a provided list of contaminants) or marine species (Based on the WoRMS local database). Please note, not all species of algae are in the local WoRMS download, so algal taxa may not be identified as marine.

If you want to check for contaminants or marine taxa you need the following:
1) A list of contaminant taxa (taxa_contam.list)
2) The WoRMS local database

### Requesting a local copy of WoRMS 
To request a local copy of WoRMS visit https://www.marinespecies.org/usersrequest.php and fill in the forms. We would encourage people who do this to consider financially supporting WoRMS during funding applications. 

Then modify lines 5 & 6 to point to the local WoRMS taxonlist, and your contaminant list.
Also modify lines 10 or 34 to point to the Kraken or Megan output, and finally modify line 24 to the location of the names.dmp file.

# Using MARES pre-compiled reference database

We would recommend users compile their own reference database, as our pre-compiled reference database will not necessarily be appropriate for every use case. However, in the event you wish to use our databases - they are accessible at the following link: https://osf.io/8rdqk/

For the MARES reference sequences database, our list of taxa included all families known to have marine species (based on the World Registry of Marine Species, WoRMS, http://www.marinespecies.org/), and we additionally built a database that included common laboratory contaminants.

We used Cytochrome oxydase 1 (CO1) mirhochondrial gene region as universal DNA barcode for our target system. 

There are two files - MARES_BAR.tar.gz and MARES_NOBAR.tar.gz. 

These represent whether "BARCODE" was used as a keyword during compilation of NCBI sequences. In the unzipped files, there are the appropriate names.dmp, nodes.dmp, and the custom accession2taxid files required to use our database. You will still need to download the nucl_gb.accession2taxid & nucl_wgs.accession2taxid files - these are large and thus we have not included them with our pre-compiled databases.


## Technical Validation

To highlight the value and potential utility of our curated reference databases (MARES_COI_BAR and MARES_COI_NOBAR) we compare them with previously published reference databases for the metabarcoding locus CO1. 

To compare the MARES databases with databases in terms of taxonomic composition, we used pairwise beta (β)‐diversity measures based on the presence and absence of taxa within each database. Additionally, we calculated the proportion of marine species out of the total of unique species names for each database.

The scripts to reproduce our comparisons are in in the technical_validation folder. 

The script *database_formatting.R* first re-formats the species names of each database to find the unique species names after a quality control procedure for retaining fully identified taxa with binomial species names. For this step the sequence names of each reference database are needed, these can be found in the technical validation folder. Next, all the species names across all databases were merged and a presence/absence species matrix was generated to use as input for the script *bdiv_database_comparison.R*. Lastly, the species list from all the databases was checked against WORMS database to identify which were the marine species and to calculate the proportion present in each database.  

The script *bdiv_database_comparison.R* includes the calculations for the pairwise beta (β)‐diversity measures between databases. 

Databases included in this comparison: 
-	BOLD 
-	Genbank
-	MiDori-LONGEST
-	db_COI_MBPK
-	Anacapa CO1


# Citations and Acknowledgements

Macher, Jan-Niklas, Till-Hendrik Macher, and Florian Leese. "Combining NCBI and BOLD databases for OTU assignment in metabarcoding and metagenomic datasets: The BOLD_NCBI _Merger." Metabarcoding and Metagenomics 1 (2017): e22262.

Porter, Teresita M., and Mehrdad Hajibabaei. "Over 2.5 million COI sequences in GenBank and growing." PloS one 13.9 (2018): e0200177.

WoRMS Editorial Board (2020). World Register of Marine Species. Available from http://www.marinespecies.org at VLIZ. Accessed 2020-04-01. doi:10.14284/170

Guiry, M.D. & Guiry, G.M. 2020. AlgaeBase. World-wide electronic publication, National University of Ireland, Galway. https://www.algaebase.org; searched on 01 April 2020.

Please also cite: https://doi.org/10.5281/zenodo.3701276 if you're usage involved the addition of custom TaxIDs (this is included by default within the pipeline)

The genbank_to_fasta.py script was developed by the Rocap Lab https://rocaplab.ocean.washington.edu/

Special mention and acknowledgments to Edgar Valdez who help creating the Docker image for MARES. 

## Questions

If there are any questions or issues - please email William Pearman (wpearman1996@gmail.com) or Vanessa Arranz (vanearranz@hotmail.com), or alternatively leave comment on this repository.


# Suggested Citation

Please refer to the publication: Arranz, V., Pearman, W.S., Aguirre, J.D. & Liggins, L,. MARES, a replicable pipeline and curated reference database for marine eukaryote metabarcoding. Sci Data 7, 209 (2020). https://doi.org/10.1038/s41597-020-0549-9


## In addition, if you make use of this pipeline, please also cite the following publications:

Macher, Jan-Niklas, Till-Hendrik Macher, and Florian Leese. "Combining NCBI and BOLD databases for OTU assignment in metabarcoding and metagenomic datasets: The BOLD_NCBI _Merger." Metabarcoding and Metagenomics 1 (2017): e22262.

Porter, Teresita M., and Mehrdad Hajibabaei. "Over 2.5 million COI sequences in GenBank and growing." PloS one 13.9 (2018): e0200177.

https://doi.org/10.5281/zenodo.3701276

## If you used the MARES reference sequence database - please also cite:
WoRMS Editorial Board (2020). World Register of Marine Species. Available from http://www.marinespecies.org at VLIZ. Accessed 2020-04-01. doi:10.14284/170

Guiry, M.D. & Guiry, G.M. 2020. AlgaeBase. World-wide electronic publication, National University of Ireland, Galway. https://www.algaebase.org; searched on 01 April 2020.


