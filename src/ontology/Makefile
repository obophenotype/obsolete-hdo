
# This Makefile is for use by the doid Release Manager.
#
# requirements: 
#   - OWLTools (http://code.google.com/p/owltools/)
#   - Oort (http://code.google.com/p/owltools/wiki/OortIntro)
#   - owljs (advanced operations only)
#   - apache-jena arq (for generating reports)
#
# To make a release, type 'make release' in this directory
#
# Questions to: Chris Mungall cjmungall AT lbl DOT gov

OBO = http://purl.obolibrary.org/obo

initial-build: doid.obo
build: doid.obo minidiff
release: doid.obo diff

all: doid.obo
release: all all_imports all_bridges

# all release files are derived from the editors version.
# we use the default Oort setup
doid.obo: doid-edit.owl
	ontology-release-runner --catalog-xml catalog-v001.xml $< --skip-format owx --allow-overwrite --asserted --simple && mv doid-simple.obo doid.obo
doid.owl: doid.obo

# axiom from imported ontology (ext) merged in
doid-merged.owl: doid.owl
	owltools --use-catalog $< --merge-imports-closure -o $@
doid-merged.obo: doid-merged.owl
	owltools $< -o -f obo $@

# TEMPORARY!!! Sync with SVN. Once github is primary, this will be removed
doid-edit.owl:
	owltools $(HOME)/repos/diseaseontology/HumanDO.obo --add-imports-declarations $(OBO)/doid/ext.owl -o -f ofn $@

# ----------------------------------------
# Imports
# ----------------------------------------
all_imports: imports/omim_import.owl imports/ncit_import.owl

KEEPRELS = BFO:0000050 BFO:0000051 RO:0002202 immediate_transformation_of

mirror/%.owl:
	owltools $(OBO)/$*.owl --remove-annotation-assertions -l --make-subset-by-properties -f $(KEEPRELS) --set-ontology-id $(OBO)/$*.owl -o $@
.PRECIOUS: mirror/%.owl

mirror/cl.owl:
	owltools $(OBO)/cl/cl-basic.owl --remove-annotation-assertions -l --make-subset-by-properties -f $(KEEPRELS) --set-ontology-id $(OBO)/cl.owl -o $@
.PRECIOUS: mirror/%.owl

#imports/%_import.owl: seed.owl mirror/%.owl
#	owltools --use-catalog --map-ontology-iri $(OBO)/doid/imports/$*_import.owl mirror/$*.owl $<   --extract-module -s $(OBO)/$*.owl -c --extract-mingraph  --set-ontology-id $(OBO)/doid/imports/$@ -o $@

mirror/Thesaurus.owl:
	cd mirror && wget -N http://ncicb.nci.nih.gov/xml/owl/EVS/$@
.PRECIOUS: mirror/Thesaurus.owl

mirror/CTD_diseases.obo:
	cd mirror && wget http://ctdbase.org/reports/CTD_diseases.obo.gz && gzip -d CTD_diseases.obo.gz

mirror/ctd.owl: mirror/CTD_diseases.obo
	owltools $< -o $@

imports/%_import.owl: seed.owl mirror/%.owl
	owltools --use-catalog $< mirror/$*.owl --merge-support-ontologies  --extract-module -s $(OBO)/$*.owl -c --extract-mingraph  --set-ontology-id $(OBO)/doid/$@ -o $@

imports/orphanet_import.owl: seed.owl orphanet/ordo-slim.owl
	owltools --use-catalog $< orphanet/orphanet-orig.owl --merge-support-ontologies --extract-module -s http://www.orpha.net/ontology/orphanet.owl -c --extract-mingraph --set-ontology-id $(OBO)/doid/imports/orphanet_import.owl -o $@

imports/ncit_import.owl: mirror/Thesaurus.owl
	owltools $<  --run-reasoner -r elk --assert-implied --reasoner-query -d -l 'Disease or Disorder' --make-ontology-from-results $(OBO)/doid/imports/ncit_import.owl -o $@

imports/ctd_import.owl: mirror/ctd.owl
	owltools $<  --set-ontology-id $(OBO)/doid/$@ -o $@

imports/omim_import.owl:
	owltools $(OBO)/upheno/data/disorders.owl --set-ontology-id $(OBO)/doid/$@ -o $@

#seed.owl: doid-edit.owl
#	cp $< $@
seed.owl: doid-edit.owl
	owltools --use-catalog $< disease-miner/all-do-bridge.obo --merge-support-ontologies  --remove-imports-declarations -o $@


imports/%.obo: imports/%.owl
	owltools $< -o -f obo $@

# ----------------------------------------
# Bridge
# ----------------------------------------
all_bridges: bridge/ncit_bridge.owl bridge/omim_bridge.owl bridge/mesh_bridge.owl

bridge/ncit_bridge_init.owl: doid-edit.owl
	owltools --use-catalog $< --translate-xrefs-to-equivs -n -p NCI -m NCI 'http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#' --set-ontology-id $(OBO)/doid/$@ --add-imports-declarations $(OBO)/doid.owl $(OBO)/doid/imports/ncit_import.owl -o $@

bridge/umls_bridge_init.owl: doid-edit.owl
	owltools --use-catalog $< --translate-xrefs-to-equivs -n -p UMLS_CUI -m UMLS_CUI 'http://linkedlifedata.com/resource/umls/id/' --set-ontology-id $(OBO)/doid/$@ -o $@

bridge/omim_bridge_init.owl: doid-edit.owl
	owltools --use-catalog $< --translate-xrefs-to-equivs -n -p OMIM --set-ontology-id $(OBO)/doid/$@ --add-imports-declarations $(OBO)/doid.owl $(OBO)/doid/imports/omim_import.owl -o $@

bridge/mesh_bridge_init.owl: doid-edit.owl
	owltools --use-catalog $< --translate-xrefs-to-equivs -n -p MSH -m MSH $(OBO)/MESH_ --set-ontology-id $(OBO)/doid/$@ --add-imports-declarations $(OBO)/doid.owl $(OBO)/doid/imports/ctd_import.owl -o $@

bridge/ctd_omim_mesh_bridge_init.owl: imports/ctd_import.owl
	owltools --use-catalog $< --translate-xrefs-to-equivs -a -n -p OMIM -m OMIM $(OBO)/OMIM_ --set-ontology-id $(OBO)/doid/$@ -o $@
##	owltools --use-catalog $< --translate-xrefs-to-equivs -n -p MESH -m MSH $(OBO)/MESH_ --set-ontology-id $(OBO)/doid/$@ --add-imports-declarations $(OBO)/doid.owl $(OBO)/doid/imports/ctd_import.owl -o $@

## TODO: Orphanet
orphanet_bridges: bridge/orphanet_disease_omim_bridge.owl

orphanet_ontology: orphanet/orphanet-orig.owl

# The Orphanet "orphanet-disease.owl" file is manually created by opening the
# "orphanet-orig.owl" in Protege, deleting the gene subtree, and then saving
# as "orphanet-disease.owl"
bridge/orphanet_disease_omim_bridge_init.owl: orphanet/orphanet-orig.owl
	owltools --use-catalog $< --translate-xrefs-to-equivs -n -p OMIM \
	--set-ontology-id $(OBO)/doid/$@ -o $@

orphanet/orphanet-orig.owl:
	wget -nd -P orphanet http://www.orphadata.org/data/ORDO/ordo_orphanet_1.2.owl.zip
	unzip  orphanet/ordo_orphanet_1.2.owl.zip -d orphanet && rm orphanet/ordo_orphanet_*.zip
	mv orphanet/orphadata1.2.owl orphanet/orphanet-orig.owl
	rm orphanet/ontology_version_* >/dev/null 2>&1 || true
	touch orphanet/ontology_verion_1.2

# preserve only 'disease' and 'group of disorders' hierarchies, plus links between them
orphanet/ordo-slim-1.owl: orphanet/orphanet-orig.owl
	owltools $<  --add-obo-shorthand-to-properties --make-subset-by-properties  part_of --reasoner-query -l 'group of disorders' --reasoner-query -l disease --make-ontology-from-results $(OBO)/doid/ordo-slim.owl  -o $@

orphanet/ordo-slim.owl: orphanet/ordo-slim-1.owl
	owljs-dlmatch -o $@ -r 'function(m){return owl.subClassOf(m.x, m.y)}' 'q.subClassOfMatch("?x",q.objectSomeValuesFromMatch("?r","?y"))'  $< 

bridge/%_bridge.owl: bridge/%_bridge_init.owl
	owljs-decluster -m bridge/$*_report.md -o $@.tmp $<  >& $@.log && owltools --use-catalog $@.tmp --set-ontology-id $(OBO)/doid/$@ -o $@

bridge/%_bridge.obo: bridge/%_bridge.owl
	owltools --use-catalog $< --remove-imports-declarations -o -f obo $@

bridge/%_merged.obo: bridge/%_bridge.owl
	owltools --use-catalog $< --merge-imports-closure -o -f obo $@
bridge/%_merged.owl: bridge/%_bridge.owl
	owltools --use-catalog $< --merge-imports-closure -o $@

bridge/all.obo: bridge/all.owl
	owltools --use-catalog $< --merge-imports-closure -o -f obo --no-check $@



## TODO - convert to java/js
#bridge/omim-doid-equiv.tbl: imports/omim_import.obo
#	blip-findall -i $< -i doid.obo "one_to_one_xref(D,X,'OMIM')" -no_pred -select X-D -label -use_tabs > $@.tmp && mv $@.tmp $@
#bridge/omim-doid-subclass.tbl:  imports/omim_import.obo
#	blip-findall -i $< -i doid.obo "one_to_many_xref(D,X,'OMIM')" -no_pred -select X-D -label -use_tabs > $@
#bridge/omim-doid-rev-subclass.tbl: imports/omim_import.obo
#	blip-findall -i $< -i doid.obo "many_to_one_xref(D,X,'OMIM')" -no_pred -select X-D -label -use_tabs > $@
#bridge/omim-doid-m2m.tbl: imports/omim_import.obo
#	blip-findall -i $< -i doid.obo "many_to_many_xref(D,X,'OMIM')" -no_pred -select X-D -label > $@

# ----------------------------------------
# Subsets
# ----------------------------------------
doid-mingraph.obo: doid.owl
	owltools --use-catalog $< --extract-mingraph -o -f obo $@

# ----------------------------------------
# Reports
# ----------------------------------------
reports/doid-%.csv: doid-merged.owl sparql/%.sparql
	arq --data $< --query sparql/$*.sparql --results csv > $@.tmp && ./util/curiefy-purls.pl $@.tmp > $@ && rm $@.tmp

reports/omim-%.csv: bridge/omim_merged.owl sparql/%.sparql
	arq --data $< --query sparql/$*.sparql --results csv > $@.tmp && ./util/curiefy-purls.pl $@.tmp > $@ && rm $@.tmp

reports/umls-%.csv: bridge/umls_merged.owl sparql/%.sparql
	arq --data $< --query sparql/$*.sparql --results csv > $@.tmp && ./util/curiefy-purls.pl $@.tmp > $@ && rm $@.tmp

# ----------------------------------------
# Diffs
# ----------------------------------------

# 
diff: doid.obo
	cd diffs && touch doid-diff && rm doid-*diff* && make

# Minidiff: intra-release differences
minidiff: doid.obo
	cd diffs  && touch doid-diff && rm doid-*diff* && make TGTS='html txt' SRC=../doid.obo && mail -s doid-diffs RELEASE-MANAGER@FOO.BAR < doid-combined-diff.txt

# ----------------------------------------
# Sync with old DO (TEMPORARY)
# ----------------------------------------

LEGACY=../../../diseaseontology/HumanDO.obo 
test.ofn: $(LEGACY)
	owltools $<  --make-subset-by-properties // --set-ontology-id $(OBO)/doid.owl -o -f ofn $@

test2.ofn: test.ofn
	grep -v 'oboInOwl\#id' $< > $@




