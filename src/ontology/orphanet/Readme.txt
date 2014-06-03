 To generate Orphanet bridge files do the following:
 
 1. run: make orphanet_ontology
 This will download and unzip the hard coded Orphanet ontology version 
 into the orphanet/orphanet-orig.owl file
 
 2. Open the ontology file in Protege and delete the "gene" class and its 
 subtree and save as orphanet-disease.owl

 3. run: make orphanet_bridges