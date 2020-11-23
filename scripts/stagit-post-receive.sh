#!/bin/sh
# generic git post-receive hook.
# change the config options below and call this script in your post-receive
# hook or symlink it.
#
# usage: $0 [name]
#
# if name is not set the basename of the current directory is used,
# this is the directory of the repo when called from the post-receive script.

# NOTE: needs to be set for correct locale (expects UTF-8) otherwise the
#       default is LC_CTYPE="POSIX".
export LC_CTYPE="en_US.UTF-8"

name="$1"
if test "${name}" = ""; then
	name=$(basename $(pwd))
fi

# config
# paths must be absolute.
reposdir="$HOME/git/"
dir="${reposdir}/${name}"
htmldir="$HOME/public_html"
stagitdir="/git"
destdir="${htmldir}${stagitdir}"
cachefile=".htmlcache"
# /config

if ! test -d "${dir}"; then
	echo "${dir} does not exist" >&2
	exit 1
fi
cd "${dir}" || exit 1

# detect git push -f
force=0
while read -r old new ref; do
	test "${old}" = "0000000000000000000000000000000000000000" && continue
	test "${new}" = "0000000000000000000000000000000000000000" && continue

	hasrevs=$(git rev-list "${old}" "^${new}" | sed 1q)
	if test -n "${hasrevs}"; then
		force=1
		break
	fi
done

# strip .git suffix.
r=$(basename "${name}")
d=$(basename "${name}" ".git")
printf "[%s] stagit HTML pages... " "${d}"

mkdir -p "${destdir}/${d}"
cd "${destdir}/${d}" || exit 1

# remove commits and ${cachefile} on git push -f, this recreated later on.
if test "${force}" = "1"; then
	rm -f "${cachefile}"
	rm -rf "commit"
fi

# make index.
~/apps/stagit/stagit-index "${reposdir}/"*/ > "${destdir}/index.html"

# make pages.
~/apps/stagit/stagit -c "${cachefile}" "${reposdir}/${r}"

# fix umask issues
chmod -R og+rx "${destdir}"

echo "done"
