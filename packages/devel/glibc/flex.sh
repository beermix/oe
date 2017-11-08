#!/bin/bash
set -e
url=https://github.com/westes/flex
package=flex
tag=glibc-2.26
branch=release/2.26/master
out=$package-git.patch
repo=$package.git

# use filterdiff, etc to exclude bad chunks from diff
filter() {
	cat
}

if [ ! -d $repo ]; then
	git clone --bare $url -b $branch $repo
fi

cd $repo
	git fetch origin +$branch:$branch +refs/tags/$tag:refs/tags/$tag
	git log -p --reverse $tag..$branch | filter > ../$out.tmp
cd ..

if cmp -s $out{,.tmp}; then
	echo >&2 "No new diffs..."
	rm -f $out.tmp
	exit 0
fi
mv -f $out{.tmp,}


