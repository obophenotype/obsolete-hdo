
# This Makefile is for use by the doid Release Manager.
#
# requirements: Oort (http://code.google.com/p/owltools/wiki/OortIntro)
#
# To make a release, type 'make release' in this directory

OBO = http://purl.obolibrary.org/obo

initial-build: doid.obo
build: doid.obo minidiff
release: doid.obo diff

all: doid.obo

# all release files are derived from the editors version.
# we use the default Oort setup
doid.obo: doid-edit.owl
	ontology-release-runner --catalog-xml catalog-v001.xml $< --allow-overwrite --asserted --simple && mv doid-simple.obo doid.obo

# ----------------------------------------
# Imports
# ----------------------------------------
all_imports: imports/go_import.owl imports/pato_import.owl

KEEPRELS = BFO:0000050 BFO:0000051 RO:0002202 immediate_transformation_of

mirror/%.owl:
	owltools $(OBO)/$*.owl --remove-annotation-assertions -l --make-subset-by-properties -f $(KEEPRELS) --set-ontology-id $(OBO)/$*.owl -o $@
.PRECIOUS: mirror/%.owl

#imports/%_import.owl: seed.owl mirror/%.owl
#	owltools --use-catalog --map-ontology-iri $(OBO)/doid/imports/$*_import.owl mirror/$*.owl $<   --extract-module -s $(OBO)/$*.owl -c --extract-mingraph  --set-ontology-id $(OBO)/doid/imports/$@ -o $@


imports/%_import.owl: seed.owl mirror/%.owl
	owltools --use-catalog $< mirror/$*.owl --merge-support-ontologies  --extract-module -s $(OBO)/$*.owl -c --extract-mingraph  --set-ontology-id $(OBO)/doid/imports/$@ -o $@

#seed.owl: doid-edit.owl
#	cp $< $@
seed.owl: doid-edit.owl
	owltools --use-catalog $< disease-miner/all-do-bridge.obo --merge-support-ontologies  --remove-imports-declarations -o $@


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
	owltools $<  --make-subset-by-properties // --set-ontology-id $(OBO).doid.owl -o -f ofn $@

test2.ofn: test.ofn
	grep -v 'oboInOwl\#id' $< > $@




