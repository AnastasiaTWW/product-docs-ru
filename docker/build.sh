#!/bin/sh

set -ex

mkdir -p /tmp/builder
export HOME=/tmp/builder

cd /opt/build
mkdir -p books html

for branch in html/*; do
    branch=${branch#html/}
    if ! git branch -lr |sed -e "s/^ *//" -e "s@/@-@g" |grep -qxF "origin-$branch"; then
        rm -rf "html/$branch"
    fi
done

for branch in `git branch --list -r |sed -e 's/^  //' -e 's/ .*//'`; do
    echo "x${branch}x"
    name=$(echo "$branch" |sed -e "s@origin/@@" -e "s@/@-@")
    commit=$(git log -1 --pretty=%h "$branch")

    if [ ! -f "html/$name/$commit" ]; then
        rm -rf "books/$name" "html/$name"
        mkdir -p "books/$name" "html/$name"
        git archive "$branch" |tar x -C "books/$name"

        gitbook install "books/$name"
        gitbook build "books/$name" "html/$name"

        touch "html/$name/$commit"
    fi
done
