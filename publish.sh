#!/usr/bin/env bash

NOTE="$(notes.sh -l | fzf --tac --with-nth="2..-1" --preview "notes.sh -p {}" | cut -d " " -f 1)"

if [ ! -z "$NOTE" ]; then
	SLUG="$(notes.sh -E $NOTE | grep -m1 "^X-Slug: " | sed -n "s/^X-Slug: \(.*\)$/\1/p")"
	if [ -z "$SLUG" ]; then
		echo "X-Slug header expected"
		exit 1
	fi
	DIR="/home/aron/Repos/amadv/amadv.github.io/content/posts/$SLUG"
	mkdir -p "$DIR"
	notes.sh -E "$NOTE" > "$DIR/note.md"
fi
