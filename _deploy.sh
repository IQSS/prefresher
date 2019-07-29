#!/bin/sh

# Called by .travis.yml. Copies the compiled html into a separate directory, 
# book-deploy, and pushes that up to the gh-pages branch of the main repository. 
# This then gets automatically recognized by Github Pages and is deployed.

set -e

[ -z "${GITHUB_PAT}" ] && exit 0
[ "${TRAVIS_BRANCH}" != "master" ] && exit 0

git config --global user.email "shirokuriwaki@gmail.com"
git config --global user.name "Shiro Kuriwaki"

# clone the repository to the book-deploy directory
git clone -b gh-pages https://${GITHUB_PAT}@github.com/${TRAVIS_REPO_SLUG}.git book-deploy
cd book-deploy
git rm -rf *
cp -r ../_book/* ./
git add --all *
git commit -m "copy to deployment via travis" || true
git push -q origin gh-pages
