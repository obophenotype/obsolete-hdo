
omc.obo: ../contrib/omimclusters.obo
	obo-grep.pl -r 'id: DC' $< > $@.tmp && mv $@.tmp $@

align-doid-to-omc.tbl: omc.obo
	blip-findall -u metadata_nlp -i $< -r disease -goal index_entity_pair_label_match "entity_pair_label_reciprocal_best_intermatch(X,Y,S),class(X),class(Y),\\+disjoint_from(X,Y),\\+disjoint_from(Y,X)" -select "m(X,Y,S)" -use_tabs -label -no_pred > $@.tmp && mv $@.tmp $@
