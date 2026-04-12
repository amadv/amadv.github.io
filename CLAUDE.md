# Site System

A personal site run by Claude. No special software — just HTML files and an LLM. The system is **organic** — it grows as needs evolve.

## Structure

```
posts/                    — Public blog posts (posts/slug/index.html), numbered 00–27
files/
  code/                   — Dotfiles and packages (dots/, pkgsrc/, scrots/)
  images/                 — art/, moments/
  people/                 — blogroll.txt
  uses/                   — equipment.txt, hardware.txt, software.txt
  whoami/                 — bio.txt, interests.txt, values.txt
info/index.html           — About page
now/index.html            — Now page
brutalist.css             — Shared stylesheet (root)
index.html                — Homepage with numbered post list
CLAUDE.md                 — This file
```

## Content Routing

When the user writes something, Claude decides where it goes:

| What the user writes | Where it goes |
|---|---|
| Reflection, essay, thought piece | `posts/snake_case_slug/index.html` (new numbered post) |
| What I'm doing now, current activities | `now/index.html` |
| Bio, personal background | `files/whoami/bio.txt` |
| Personal values | `files/whoami/values.txt` |
| Interests, hobbies | `files/whoami/interests.txt` |
| Equipment, hardware | `files/uses/equipment.txt` or `hardware.txt` |
| Software I use | `files/uses/software.txt` |
| People / blogs worth reading | `files/people/blogroll.txt` |
| Code, dotfiles | `files/code/` |
| Photos / images | `files/images/art/` or `files/images/moments/` |
| About page (public-facing intro) | `info/index.html` |

If routing is ambiguous, propose and confirm before writing.

## HTML Conventions

### Posts (`posts/snake_case_slug/index.html`)

Use a full inline `<style>` block (copy from an existing post). Post slugs are snake_case.

```html
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width,initial-scale=1">
	<title>Post Title</title>
<style>
/* full brutalist CSS inline — copy from an existing post */
</style>
</head>
<body>
	<main>
		<h1>Post Title</h1>
		<p>-</p>
		<p>Content here.</p>
		<time>YYYY-MM-DD</time>
	</main>
	<footer>
		<p><a href="../"><i>../</i></a></p>
	</footer>
</body>
</html>
```

### Pages (`info/`, `now/`)

Link to the root stylesheet using an absolute path.

```html
<link rel="stylesheet" href="/brutalist.css">
```

Footer nav for `now/`: `<a href="/info/"><i>../</i></a>`
Footer nav for `info/`: `<a href="/"><i>../</i></a>`

### Text files (`files/whoami/`, `files/uses/`, `files/people/`)

Plain text. No HTML wrapper. Append or edit in place.

## Session Start

1. Run `date` — never assume the date
2. Read `now/index.html` — understand current state
3. Note anything that looks stale (e.g. `now/` last updated over a month ago)

## After Adding a New Post

1. Create `posts/slug/index.html`
2. Prepend entry to `index.html` homepage (numbered list, increment count)
3. Prepend entry to `posts/index.html` (full listing)

## Working Style

- **Batch parallel** — write multiple files at once when possible
- **Confirm briefly** — short summary of what was written and where
- **Voice input** — interpret intent, don't flag obvious transcription errors
- **Sensitive content** — mark as `<!-- private -->` in HTML if the user flags it

## Push Code

When the user says "push code" (or similar), Claude will:
1. `git add` all changed files appropriately (no secrets, no junk)
2. Write a short, accurate commit message based on what changed
3. `git push`

Confirm briefly what was committed and pushed.

## Evolving the System

If content doesn't fit an existing section, propose a new folder with rationale before creating it. If approved: create it and update this CLAUDE.md.
