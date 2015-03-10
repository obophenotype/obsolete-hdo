# Making MonDo (Monarch Disease Ontology)

MonDo is a merge of 4 sources:

 * OMIM
 * Orphanet/ORDO
 * DOID
 * MGI DiseaseClusters

No one set on its own is sufficient; we have HPO annotations to OMIM
diseases, but OMIM is a flat list (OMIM Phenotypic Series are highly
incomplete). In addition, we have some HPO annotations to Orphanet
diseases.

The Disease Ontology (DOID) is in itself not complete enough for
complete classification of OMIM. There are many gaps, and in many
cases xrefs in DOID are ambiguous w.r.t whether the meaning is
equivalence or subclass, which presents problems for making a unified
heirarchy

One option is to use Orphanet by itself, or the combination of
Orphanet plus OMIM. However, The ORDO ontology representation of
Orphanet presents a number of challenges.

## Hierarchy issues with ORDO

ORDO includes various distinct terms of the form

 * X
 * rare X
 * genetic X
 * rare genetic X

However, these are typically arranged in separate hierarchies. See for
example:

![ataxia](images/familial-prostate-cancer-orphanet.png)

Despite these ontological issues, Orphanet has obvious advantages.

## MGI DiseaseClusters

## MonDo Structure

In MonDo, OMIMs are always placed as leaf nodes. They may classify
under some mixture of DC, DOID and Orphanet, and these 3 hierarchies
are themselves intermingled in a way that should be inutitive.

Examples:

### PD

### Alzheimers

# Methods

## Rewiring ORDO



# OLD DOCS

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
