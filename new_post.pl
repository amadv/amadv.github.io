#!/usr/bin/env perl
# new_post.pl - Create a new blog post folder with a boilerplate index.html.
# Usage: perl new_post.pl "My Blog Post Title"
# Creates ./<slug>/index.html where <slug> is the kebab-cased title.
# Uses only core Perl modules (FindBin) - no CPAN packages required.

use strict;
use warnings;
use FindBin;

my $BLOG_TITLE = 'Dev.Madved';
my $BASE       = $FindBin::Bin;

sub slugify {
    my ($t) = @_;
    $t = lc $t;
    $t =~ s/[^\p{L}\p{N}]+/-/g;   # runs of non-letter/non-number -> hyphen
    $t =~ s/^-+|-+$//g;           # trim leading/trailing hyphens
    return $t;
}

sub escape_html {
    my ($s) = @_;
    $s =~ s/&/&amp;/g;
    $s =~ s/</&lt;/g;
    $s =~ s/>/&gt;/g;
    return $s;
}

sub prompt_title {
    print "Blog post title: ";
    my $title = <STDIN>;
    chomp $title;
    return $title;
}

sub template {
    my ($title_esc) = @_;
    my $html = <<'HTML';
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>__TITLE__ - __BLOG_TITLE__</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/default.min.css">
  <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js"></script>
  <link rel="stylesheet" href="/index.css">
  <script type="module">
  import { marked } from "https://cdn.jsdelivr.net/npm/marked/lib/marked.esm.js";
    document.body.innerHTML =
      marked.parse(document.body.innerHTML.replace(/&lt;+/g, '<').replace(/&gt;+/g, '>').replace(/&amp;+/g, '&'));
    hljs.highlightAll();
  </script>
</head>
<body>

[ ../ ](/)

# __TITLE__

</body>
</html>
HTML
    $html =~ s/__TITLE__/$title_esc/g;
    $html =~ s/__BLOG_TITLE__/$BLOG_TITLE/g;
    return $html;
}

sub main {
    my $title = shift @ARGV;
    $title = prompt_title() unless defined $title && length $title;
    $title =~ s/^\s+|\s+$//g;
    die "no title given\n" unless length $title;

    my $slug = slugify($title);
    die "could not create a folder name from \"$title\" (use at least one letter or number)\n" if $slug eq '';

    my $dir = "$BASE/$slug";
    die "folder already exists: $dir\n" if -e $dir;

    mkdir $dir or die "cannot create $dir: $!\n";

    my $html = template(escape_html($title));
    open my $fh, '>:encoding(UTF-8)', "$dir/index.html" or die "cannot write $dir/index.html: $!\n";
    print $fh $html;
    close $fh;

    print "Created $dir/index.html\n";
    print "Tip: add a post entry to the homepage index.html, then run `make rss` to regenerate the feed.\n";
}

main();
