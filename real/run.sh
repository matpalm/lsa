#!/usr/bin/env bash 
set -x
set -e

# vars
INPUT_DIR=feed_data_medium
WORKING_DIR=output.medium.doclen
NUM_FEATURES=20

export PATH=$PATH:`pwd`:`pwd`/..

# convert from raw feeds to term occurence matrix
rm -rf $WORKING_DIR
cat $INPUT_DIR/* | feed_to_occurrence_matrix.rb $WORKING_DIR 30 0.10
cd $WORKING_DIR

# normalisation (if required)
#cat tom.sparse.raw > tom.sparse.normalised # none
cat tom.sparse.raw | normalise_doclen.rb > tom.sparse.normalised # doclength
#cat tom.sparse.raw | tf_idf_sparse.rb > tom.sparse.normalised # tfidf

# decompse
svd -d $NUM_FEATURES tom.sparse.normalised -o decomp

# convert S to be 'real' matrix, not just singular values outputted from libsvd
convert_from_svd_s_matrix_to_2d_matrix.rb $NUM_FEATURES < decomp-S > decomp-S.square

# construct US; terms vs features
transpose < decomp-Ut > decomp-U
multiply.rb decomp-U decomp-S.square > decomp-US
matrix_to_csv_for_r.rb < decomp-US > decomp-US.csv

# construct VS; docs vs features
transpose < decomp-Vt > decomp-V
multiply.rb decomp-V decomp-S.square > decomp-VS
matrix_to_csv_for_r.rb < decomp-VS > decomp-VS.csv

# join actual terms with US(terms) 
# use terms_for_features.sh to examine this file
join_with_features.rb terms > terms_with_features
export_to_ggobi.rb < terms_with_features > terms_with_features.ggobi.xml

# join urls with VS(documents)
# and export to ggobi format
join_with_features.rb urls > urls_with_features
export_to_ggobi.rb < urls_with_features > urls_with_features.ggobi.xml

# build US and VS scatterplots
exit 0
R --vanilla <<EOF
graph_size=500
#dat = read.csv('decomp-US.csv',header=TRUE)
#png("decomp-US.png", width=graph_size, height=graph_size, bg = "transparent")
#plot(dat, cex=1, pch=16)
#dev.off()
dat = read.csv('decomp-VS.csv',header=TRUE)
png("decomp-VS.png", width=graph_size, height=graph_size, bg = "transparent")
plot(dat, cex=1, pch=16)
dev.off()
EOF



