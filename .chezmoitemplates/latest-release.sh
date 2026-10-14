# Print the tag of a GitHub repo's latest release (e.g. v0.74.5).
# usage: sh -c <this> sh <owner/repo>
#
# github.com/<repo>/releases/latest redirects to the tag's page: a plain web
# request, so no token and no API rate limit. The answer is cached for a week.
# If the lookup fails, use the cached answer however old; with none, print
# nothing, and the caller skips that download.
repo=$1
cache=${XDG_CACHE_HOME:-$HOME/.cache}/chezmoi-releases/$(echo "$repo" | tr / _)
if [ -s "$cache" ] && [ -z "$(find "$cache" -mtime +6)" ]; then
    cat "$cache"
    exit
fi
tag=$(curl -fsSI --max-time 10 -o /dev/null -w '%{redirect_url}' \
    "https://github.com/$repo/releases/latest" 2>/dev/null)
tag=${tag##*/releases/tag/}
case $tag in
    '' | */*) tag= ;;
esac
if [ -n "$tag" ]; then
    mkdir -p "${cache%/*}"
    echo "$tag" > "$cache"
    echo "$tag"
elif [ -s "$cache" ]; then
    echo "chezmoi: could not look up the latest $repo release, staying on $(cat "$cache")" >&2
    cat "$cache"
else
    echo "chezmoi: could not look up the latest $repo release, skipping it for now" >&2
fi
