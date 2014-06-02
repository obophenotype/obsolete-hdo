
# This Makefile is for use by the doid Release Manager.
#
# requirements: Oort (http://code.google.com/p/owltools/wiki/OortIntro)
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
	ontology-release-runner --catalog-xml catalog-v001.xml $< --allow-overwrite --asserted --simple && mv doid-simple.obo doid.obo

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
	owltools --use-catalog $< mirror/$*.owl --merge-support-ontologies  --extract-module -s $(OBO)/$*.owl -c --extract-mingraph  --set-ontology-id $(OBO)/doid/imports/$@ -o $@

imports/ncit_import.owl: mirror/Thesaurus.owl
	owltools $<  --run-reasoner -r elk --assert-implied --reasoner-query -d -l 'Disease or Disorder' --make-ontology-from-results $(OBO)/doid/imports/ncit_import.owl -o $@

imports/ctd_import.owl: mirror/ctd.owl
	owltools $<  --set-ontology-id $(OBO)/doid/$@ -o $@

imports/omim_import.owl:
	owltools $(OBO)/upheno/data/disorders.owl -o $@

#seed.owl: doid-edit.owl
#	cp $< $@
seed.owl: doid-edit.owl
	owltools --use-catalog $< disease-miner/all-do-bridge.obo --merge-support-ontologies  --remove-imports-declarations -o $@


imports/%.obo: imports/%.owl
	owltools $< -o -f obo $@


# ----------------------------------------
# Bridge
# ----------------------------------------
all_bridges: bridge/ncit_bridge.owl bridge/omim_bridge.owl

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

bridge/%_bridge.owl: bridge/%_bridge_init.owl
	owljs-decluster -m bridge/$*_report.md -o $@.tmp $<  >& $@.log && owltools $@.tmp --set-ontology-id $(OBO)/doid/$@ -o $@

bridge/%_bridge.obo: bridge/%_bridge.owl
	owltools --use-catalog $< --remove-imports-declarations -o -f obo $@

bridge/%_merged.obo: bridge/%_bridge.owl
	owltools --use-catalog $< --merge-imports-closure -o -f obo $@

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




