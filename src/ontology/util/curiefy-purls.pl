#!/usr/bin/perl -pn
if (m@http://purl.obolibrary.org/obo/([A-Za-z]+)_@) {
    s@http://purl.obolibrary.org/obo/([A-Za-z]+)_@$1:@g;
}
