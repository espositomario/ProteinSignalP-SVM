#!/bin/bash
UniProt release 2023_04
#select the positive set and negative
#POSITIVE TEST:
(taxonomy_id:2759) AND (reviewed:true) AND (ft_signal_exp:*) AND (length:[30 TO *])
NEGATIVE:
(taxonomy_id:2759) AND (length:[30 TO ]) AND (reviewed:true) NOT (ft_signal:) AND ((cc_scl_term_exp:SL-0091) OR (cc_scl_term_exp:SL-0173) OR (cc_scl_term_exp:SL-0209) OR (cc_scl_term_exp:SL-0204) OR (cc_scl_term_exp:SL-0039) OR (cc_scl_term_exp:SL-0191))
#remove entries with IGNOTE POS OF SP (1..?)
p remove?.py list_positive.tsv id_positive.list short_seq
#2942
# -i case insesitive -v remove lines 
grep -ivE 'endoplasmic|golgi|secreted|lysosome' list_negative.tsv |cut -f 1 | tail +2 > id_negative.list
#30011
# map ids and download fasta files
mmseqs easy-cluster positive.fasta positive tmp --min-seq-id 0.3 \
-c 0.4 --cov-mode 0 --cluster-mode 1
#1093
mmseqs easy-cluster negative.fasta negative tmp --min-seq-id 0.3 \
-c 0.4 --cov-mode 0 --cluster-mode 1
#9523
#extract rep id
cut -f 1 positive_cluster.tsv | sort -uR > positive_rep_id.list
cut -f 1 negative_cluster.tsv | sort -uR > negative_rep_id.list
#POSITIVE SPLIT 80-20% and 5-fold CV-------------------------------------------
#Training 1....874 Test 875....1093
head -n 874 positive_rep_id.list > training_pos
tail +875 positive_rep_id.list > test_pos
#NEGATIVE SPLIT 80-20% and 5-fold CV-------------------------------------------
head -n 7618 negative_rep_id.list > training_neg
tail +7619 negative_rep_id.list > test_neg
# 5-fold CV split
#positive (-n o -l)
split -d -a 1 -l 175 training_pos subset_
#negative
split -d -a 1 -l 1524 training_neg subset_
#
cat negative/training_neg positive/training_pos > training_id
#8492
cat negative/test_neg positive/test_pos > test_id
#2124
#
cd stats
p metadata.py test_metadata.tsv benchmark_metadata_parsed.tsv 
p metadata.py training_metadata.tsv training_metadata_parsed.tsv