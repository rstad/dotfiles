# Print the public SSH keys of the given GitHub users, one per line, each with
# the account name as its comment.
# usage: sh -c <this> sh <existing-file> <line-prefix> "<user> <user>..."
#
# Reads https://github.com/<user>.keys, which needs no token and has no API
# rate limit. If GitHub can't be reached, or answers with nothing, print the
# existing file unchanged instead, so an apply never fails or drops keys.
existing=$1 prefix=$2 users=$3
keys= failed=
for user in $users; do
    fetched=$(curl -fsS --max-time 10 "https://github.com/$user.keys" 2>/dev/null)
    if [ -z "$fetched" ]; then
        failed=$user
        break
    fi
    keys="$keys$(printf '%s\n' "$fetched" | sed "s/^/$prefix/; s/\$/ $user/")
"
done
if [ -z "$failed" ]; then
    printf '%s' "$keys"
elif [ -s "$existing" ]; then
    echo "chezmoi: could not fetch GitHub keys for $failed, keeping $existing as it is" >&2
    cat "$existing"
else
    echo "chezmoi: could not fetch GitHub keys for $failed, and there is no $existing to keep" >&2
    exit 1
fi
