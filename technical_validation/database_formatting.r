
owendb<-read.delim("./owen_seqnamest.txt",head=F)
owendb2<-sub(".*species_name=", "", owendb$V1)
owendb2<-sub(';.*', '', owendb2)
owendb2<-unique(owendb2)
owendb2<-gsub("_"," ",owendb2)
owendb2<-gsub("'","",owendb2)


owendb2<-owendb2[!grepl("\\.",owendb2)]
owen_acc<-owendb2[grepl(">",owendb2)]
library(taxize)
ENTREZ_KEY<-"QWERTY" # INSERT YOUR ENTREZ KEY HERE
acc_det<-genbank2uid(owen_acc,key = ENTREZ_KEY)
acc_det_tax<-do.call("rbind",acc_det)
acc_det_tax<-acc_det_tax[!is.na(acc_det_tax)]
taxnames_owenacc<-id2name(acc_det_tax,db="ncbi")
taxnames<-do.call("rbind",taxnames_owenacc)
owendb2_acc<-taxnames$name[!grepl("\\.",taxnames$name)]
owendb2_acc<-unique(owendb2_acc)
owendb2_acc<-gsub("_"," ",owendb2_acc)
owendb2<-c(owendb2,owendb2_acc)
owendb2<-owendb2[!grepl(">",owendb2)]
owen_acc<-gsub(">","",owen_acc)
owen_acc<-gsub("_"," ",owen_acc)
owendb2<-sub("^(\\S*\\s+\\S+).*", "\\1", owendb2)
owendb2<-(owendb2[!grepl("\\d",owendb2)])
countSpaces <- function(s) { sapply(gregexpr(" ", s), function(p) { sum(p>=0) } ) }
t<-countSpaces(owendb2)
owendb2<-(owendb2[t !=0])


genbank<-read.delim("./genbank_seqnames.txt",head=F,sep="|")
genbank<-unique(genbank$V2)
genbank<-as.character(genbank)
genbank<-(genbank[!grepl("\\d",genbank)])
genbank<-gsub("_"," ",genbank)
countSpaces <- function(s) { sapply(gregexpr(" ", s), function(p) { sum(p>=0) } ) }
library(stringr)
genbank<-str_trim(genbank,side="both")
t<-countSpaces(genbank)
genbank<-(genbank[t !=0])
genbank<-genbank[!grepl("\\.",genbank)]
genbank<-sub("^(\\S*\\s+\\S+).*", "\\1", genbank)
genbank<-gsub("'","",genbank)
genbank<-gsub("\\[","",genbank)
genbank<-gsub("\\]","",genbank)
genbank<-gsub("\\(","",genbank)
genbank<-unique(genbank)

bold<-read.delim("./bold_seqnames.txt",head=F,sep="|")
bold<-bold$V2
bold<-as.character(unique(bold))
bold<-(bold[!grepl("\\d",bold)])
bold<-gsub("_"," ",bold)
countSpaces <- function(s) { sapply(gregexpr(" ", s), function(p) { sum(p>=0) } ) }
library(stringr)
bold<-str_trim(bold,side="both")
t<-countSpaces(bold)
bold<-(bold[t !=0])
bold<-bold[!grepl("\\.",bold)]
bold<-sub("^(\\S*\\s+\\S+).*", "\\1", bold)
bold<-unique(bold)

me_wo<-read.delim("../ME_wo_barcodes_seqnames.txt",sep=" ",stringsAsFactors=FALSE,head=F)
me_wo<-paste(me_wo$V2,me_wo$V3)
me_wo<-unique(me_wo)
me_wo<-(me_wo[!grepl("\\d",me_wo)])
me_wo<-gsub("_"," ",me_wo)
countSpaces <- function(s) { sapply(gregexpr(" ", s), function(p) { sum(p>=0) } ) }
library(stringr)
me_wo<-str_trim(me_wo)
t<-countSpaces(me_wo)
me_wo<-(me_wo[t !=0])
me_wo<-me_wo[!grepl("\\.",me_wo)]
me_wo<-sub("^(\\S*\\s+\\S+).*", "\\1", me_wo)
me_wo<-unique(me_wo)
me_wo<-stringr::str_replace_all(me_wo, "(\\w)N(\\w)", "\\1-\\2")
me_wo<-(me_wo[!grepl(" CMF",me_wo)]);me_wo<-(me_wo[!grepl(" JLE",me_wo)]);me_wo<-(me_wo[!grepl(" RW",me_wo)])
me_wo<-me_wo[!ifelse(word(me_wo,2)=="sp",TRUE,FALSE)]

me_bar<-read.delim("../ME_barcode_seqnames.txt",sep=" ",stringsAsFactors=FALSE,head=F)
me_bar<-paste(me_bar$V2,me_bar$V3)
me_bar<-unique(me_bar)
me_bar<-(me_bar[!grepl("\\d",me_bar)])
me_bar<-gsub("_"," ",me_bar)
countSpaces <- function(s) { sapply(gregexpr(" ", s), function(p) { sum(p>=0) } ) }
library(stringr)
me_bar<-str_trim(me_bar)
t<-countSpaces(me_bar)
me_bar<-(me_bar[t !=0])
me_bar<-me_bar[!grepl("\\.",me_bar)]
me_bar<-sub("^(\\S*\\s+\\S+).*", "\\1", me_bar)
me_bar<-unique(me_bar)
library(stringi)

me_bar<-stringr::str_replace_all(me_bar, "(\\w)N(\\w)", "\\1-\\2")
me_bar<-(me_bar[!grepl(" CMF",me_bar)]);me_bar<-(me_bar[!grepl(" JLE",me_bar)]); me_bar<-(me_bar[!grepl(" RW",me_bar)])
me_bar<-me_bar[!ifelse(word(me_bar,2)=="sp",TRUE,FALSE)]

midori<-read.delim("./MIDORI_LONGEST_20180221_COI.taxon",
                   head=F,sep=";")
midori_spec<-(midori$V7)
midori<-(midori[!grepl("\\d",midori)])
midori<-gsub("_"," ",midori)
countSpaces <- function(s) { sapply(gregexpr(" ", s), function(p) { sum(p>=0) } ) }
library(stringr)
midori<-str_trim(midori)
t<-countSpaces(midori)
midori<-(midori[t !=0])
midori_spec<-gsub("s__","",midori_spec)
midori_spec<-gsub("_","",midori_spec)
midori_spec<-sub("^(\\S*\\s+\\S+).*", "\\1", midori_spec)
midori_spec<-midori_spec[!grepl("\\.",midori_spec)]
midori_spec<-unique(midori_spec)
midori_spec[8]<-NA;midori_spec<-midori_spec[!is.na(midori_spec)]

library(stringr)
anacapa<-read.delim("C:/Users/wpear/Downloads/CO1_filtered_01102018.tar/CO1_filtered_01102018/CO1_db_filtered_to_remove_ambigous_taxonomy/CO1_fasta_and_taxonomy/CO1_taxonomy.txt",head=F)
anacapa_spec<-sub('.*\\;', '', anacapa$V2)
anacapa_spec<-stringr::word(anacapa_spec,1,2)

anacapa_spec<-gsub("(?! )[[:punct:]]", "", anacapa_spec, perl=TRUE)
anacapa_spec<-anacapa_spec[word(anacapa_spec, 2) != "cf"]
anacapa_spec<-anacapa_spec[word(anacapa_spec, 2) != "sp"]
anacapa_spec<-anacapa_spec[word(anacapa_spec, 2) != "pr"]
anacapa_spec<-anacapa_spec[word(anacapa_spec, 2) != "nr"]
anacapa_spec<-unique(anacapa_spec)

all_spec<-c(midori_spec,bold,genbank,
                owendb2,me_wo,me_bar,anacapa_spec)
all_spec<-unique(all_spec)

all_spec<-as.data.frame(all_spec)
all_spec$length_word1<-nchar(word(all_spec$all_spec,1))
all_spec$length_word2<-nchar(word(all_spec$all_spec,2))
all_spec<-all_spec[all_spec$length_word1 > 1,]
all_spec<-all_spec[all_spec$length_word2 > 1,]
all_spec<-all_spec[word(all_spec$all_spec,1) != "nr",]
all_spec<-all_spec[word(all_spec$all_spec,1) != "cf",]
all_spec<-all_spec[word(all_spec$all_spec,2) != "pr",]
all_spec<-all_spec[word(all_spec$all_spec,2) != "cf",]
#install.packages("qdapDictionaries")
library(qdapDictionaries)
all_spec$word1_dict<-word(all_spec$all_spec,1) %in% GradyAugmented
all_spec$word2_dict<-word(all_spec$all_spec,2) %in% GradyAugmented
all_spec<-as.character(all_spec$all_spec[all_spec$word1_dic==FALSE])

midori_spec<-midori_spec[midori_spec %in% all_spec]
bold<-bold[bold %in% all_spec]
genbank<-genbank[genbank %in% all_spec]
me_bar<-me_bar[me_bar %in% all_spec]
me_wo<-me_wo[me_wo %in% all_spec]
owendb2<-owendb2[owendb2 %in% all_spec]
anacapa_spec<-anacapa_spec[anacapa_spec %in% all_spec]


#install.packages("splitstackshape")
library(splitstackshape)
out <- t(splitstackshape:::charMat(listOfValues = mget(c("midori_spec","bold","genbank",
                "owendb2","me_wo","me_bar","anacapa_spec")), fill = 0L))

fac<-c("midori_spec","bold","genbank",
                "owendb2","me_wo","me_bar","anacapa_spec")
colnames(out)<-fac

outsub<-out[sample(nrow(out), 1000), ]
write.csv(out,"./presab_allspec_alldatabases.csv")
#outdist<-vegdist(t(outsub))
#library(BiodiversityR)
#xx<-CAPdiscrim(outsub~fac,data=outsub,dist="jaccard")



