
# This Makefile is for use by the doid Release Manager.
#
# requirements: Oort (http://code.google.com/p/owltools/wiki/OortIntro)
#
# To make a release, type 'make release' in this directory

OBO = http://purl.obolibrary.org/obo

initial-build: doid.obo
build: doid.obo minidiff
release: doid.obo diff

# all release files are derived from the editors version.
# we use the default Oort setup (hermit as reasoner)
doid.obo: doid-edit.owl
	ontology-release-runner $< --allow-overwrite --asserted --simple

# ----------------------------------------
# Imports
# ----------------------------------------
all_imports: imports/go_import.owl imports/pato_import.owl

imports/%_import.owl: doid-edit.owl
	owltools $< $(OBO)/$*.owl --add-imports-from-supports --extract-module -s $(OBO)/$*.owl -c --extract-mingraph  --set-ontology-id $(OBO)/go/extensions/$@ -o $@

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



