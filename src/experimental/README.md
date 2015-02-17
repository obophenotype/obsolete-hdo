
Matching DO to OMIM via external sources

Note on viewing in GH: use scroll bar to see all cols

## Methods

Two methods are applied:

 * label/synonym matching (applying stemming and some pre-processing)
    * cols 1-4 terms A and B
    * col 5 if stemming was used to make the match
 * Jaccard similarity based on OMIM diseases grouped in common
    * cols 1-2 terms A and B

## OMIM Phenotypic Series

The purpose of this analysis is to determine how OMIM PS numbers align to DO

## OMIM Clusters

The purpose of this analysis is to determine how the MGI disease
clusters (id space 'DC') align to DOID, in order to determine which
new classes need to be added to DO.

 * [align-doid-to-omc.tsv](align-doid-to-omc.tsv) -- matching based on labels
 * [sim-omc.tsv](sim-omc.tsv) -- jaccard similarity of OMIMs in common

## OMIM Cluster + PS overlap

TODO
