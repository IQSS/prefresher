#!/bin/sh

# Called by .travis.yml. Compiles bookdown in HTML form. All R packages needed to 
# be listed in the separate DESCRIPTION file to be installed.

set -ev

Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"
# Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::pdf_book')"