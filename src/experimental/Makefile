all: missing-omc.obo missing-omimps.obo sim-omc.tsv

../contrib/omimclusters.obo:
	wget ftp://ftp.informatics.jax.org/pub/curatorwork/OMIM.clusters -O $@

omimclusters.obo: ../contrib/omimclusters.obo
	cp $< $@

omc.obo: ../contrib/omimclusters.obo
	obo-grep.pl -r 'id: DC' $< > $@.tmp && mv $@.tmp $@

omimps.obo: ../ontology/imports/omim_import.obo
	obo-grep.pl -r 'id: OMIM:PS' $< > $@.tmp && grep -v ^owl-ax $@.tmp > $@

align-doid-to-omc.tsv: omc.obo
	blip-findall -i ignore.pro -u metadata_nlp -i $< -r disease -goal index_entity_pair_label_match "entity_pair_label_reciprocal_best_intermatch(X,Y,S),class(X),class(Y),\\+disjoint_from(X,Y),\\+disjoint_from(Y,X)" -select "m(X,Y,S)" -use_tabs -label -no_pred > $@.tmp && sort -u $@.tmp > $@

align-doid-to-omimps.tsv: omimps.obo
	blip-findall -i ignore.pro -u metadata_nlp -i $< -r disease -goal index_entity_pair_label_match "entity_pair_label_reciprocal_best_intermatch(X,Y,S),class(X),class(Y),\\+disjoint_from(X,Y),\\+disjoint_from(Y,X)" -select "m(X,Y,S)" -use_tabs -label -no_pred > $@.tmp && sort -u $@.tmp > $@

xrefs-%.obo: align-%.tsv
	cut -f1-4 $< | sort -u | grep ^DOID | tbl2obolinks.pl --rel xref > $@.tmp && mv $@.tmp $@

ixrefs-%.obo: align-%.tsv
	cut -f1-4 $< | sort -u | grep -v ^DOID | tbl2obolinks.pl --rel xref > $@.tmp && mv $@.tmp $@

missing-%.obo: %.obo ixrefs-doid-to-%.obo
	obo-subtract.pl $^ | obo-grep.pl --neg -r is_obsolete - > $@

sim-omc.tsv: ../contrib/omimclusters.obo
	blip-findall -debug index -consult jaccard.pro -i ../contrib/omimclusters.obo -r disease -goal ix sim_dc_bm/5 -label -no_pred > $@.tmp && mysort -k1,3 -n $@.tmp > $@
