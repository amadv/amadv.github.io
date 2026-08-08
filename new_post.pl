#!/usr/bin/env perl
# new_post.pl - Create a new blog post or static page with a boilerplate index.html,
# and register it in the homepage index.html.
#
# Usage:
#   perl new_post.pl "My Blog Post Title"          # blog post (default, dated today)
#   perl new_post.pl --blog "My Blog Post Title"   # blog post
#   perl new_post.pl --page "My Page Title"        # static page under pages/
#   perl new_post.pl                               # interactive: asks blog vs page, then title
#
# Blog posts are created at blog/<slug>/index.html and linked from the homepage
# #post-list (inserted in date order, dated today). The RSS feed is then
# regenerated via `make rss`.
# Pages are created at pages/<slug>/index.html and linked from the homepage
# pages section.
#
# Uses only core Perl modules (FindBin, POSIX) - no CPAN packages required.

use strict;
use warnings;
use FindBin;
use POSIX qw(strftime);

my $BLOG_TITLE = 'Dev.Madved';
my $BASE       = $FindBin::Bin;
my $INDEX      = "$BASE/index.html";

sub read_utf8 {
    my ($path) = @_;
    open my $fh, '<:encoding(UTF-8)', $path or die "cannot read $path: $!\n";
    local $/;
    my $content = <$fh>;
    close $fh;
    return $content;
}

sub write_utf8 {
    my ($path, $content) = @_;
    open my $fh, '>:encoding(UTF-8)', $path or die "cannot write $path: $!\n";
    print $fh $content;
    close $fh;
}

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

sub prompt_type {
    print "Create (b)log post or (p)age? [b/p]: ";
    my $t = <STDIN>;
    chomp $t;
    return lc($t) =~ /^p/ ? 'page' : 'blog';
}

sub prompt_title {
    my ($type) = @_;
    my $label = $type eq 'page' ? 'Page' : 'Blog post';
    print "$label title: ";
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

# Insert a blog <li> into the homepage #post-list, keeping newest-first date order.
sub insert_blog_entry {
    my ($html, $date, $slug, $title_esc) = @_;

    # No leading indentation: chunks are joined with $sep, which supplies it.
    my $new_li = "<li data-date=\"$date:\">\n"
               . "            <a href=\"/blog/$slug/\">$title_esc</a>\n"
               . "          </li>";

    my ($pre, $list, $post) = $html =~ m{(.*?<ul\s+id="post-list"[^>]*>)(.*?)(</ul>.*)}is
        or die "cannot find #post-list in $INDEX\n";

    my ($trailing) = $list =~ m{(\s*)$};   # whitespace before </ul> (e.g. "\n        ")
    my $sep = "\n          ";              # separator used between <li> entries

    my @chunks;
    while ($list =~ m{(<li\s+data-date="([^"]*)"[^>]*>.*?</li>)}gis) {
        push @chunks, { raw => $1, date => $2 };
    }

    my $out  = '';
    my $done = 0;
    for my $c (@chunks) {
        if (!$done && $c->{date} lt $date) {   # existing entry older than new one -> insert here
            $out .= $sep . $new_li;
            $done = 1;
        }
        $out .= $sep . $c->{raw};
    }
    $out .= $sep . $new_li unless $done;       # newest date -> append at end

    return $pre . $out . $trailing . $post;
}

# Insert a page <li> into the homepage pages section (the <ul> containing pages/ links).
sub insert_page_entry {
    my ($html, $slug, $title_esc) = @_;

    # No leading indentation: inserted with $sep, which supplies it.
    my $new_li = "<li>\n"
               . "            <a href=\"pages/$slug\"> $title_esc </a>\n"
               . "          </li>";

    if ($html =~ m{(<ul>(?:(?!</ul>).)*?href="pages/[^"]*"[^>]*>(?:(?!</ul>).)*?</ul>)}is) {
        my $block = $1;
        my $new_block = $block;
        my $sep = "\n          ";   # li entries are indented with 10 spaces
        $new_block =~ s{(\s*)</ul>}{$sep . $new_li . $1 . '</ul>'}e;
        $html =~ s{\Q$block\E}{$new_block};
        return $html;
    }
    die "cannot find pages section in $INDEX\n";
}

sub main {
    my $type  = 'blog';
    my $title = undef;
    my $type_given = 0;

    while (@ARGV) {
        my $a = shift @ARGV;
        if ($a eq '--page' || $a eq '-p')        { $type = 'page'; $type_given = 1; }
        elsif ($a eq '--blog' || $a eq '-b')     { $type = 'blog'; $type_given = 1; }
        else                                     { $title = $a; }
    }

    # Fully interactive only when no title was given; a bare title defaults to a blog post.
    if (!defined $title || !length $title) {
        $type  = prompt_type() unless $type_given;
        $title = prompt_title($type);
    }
    $title =~ s/^\s+|\s+$//g;
    die "no title given\n" unless length $title;

    my $slug = slugify($title);
    die "could not create a folder name from \"$title\" (use at least one letter or number)\n" if $slug eq '';

    my $subdir = $type eq 'page' ? 'pages' : 'blog';
    my $dir = "$BASE/$subdir/$slug";
    die "folder already exists: $dir\n" if -e $dir;

    mkdir $dir or die "cannot create $dir: $!\n";

    my $html = template(escape_html($title));
    write_utf8("$dir/index.html", $html);

    my $index = read_utf8($INDEX);
    if ($type eq 'page') {
        $index = insert_page_entry($index, $slug, escape_html($title));
        write_utf8($INDEX, $index);
        print "Created $dir/index.html\n";
        print "Added page entry to $INDEX\n";
    } else {
        my $today = strftime('%Y-%m-%d', localtime);
        $index = insert_blog_entry($index, $today, $slug, escape_html($title));
        write_utf8($INDEX, $index);
        print "Created $dir/index.html\n";
        print "Added post entry to $INDEX (dated $today)\n";
        print "Regenerating RSS feed...\n";
        system('make', '-C', $BASE, 'rss') == 0
            or warn "warning: `make rss` failed - regenerate manually with `perl generate_rss.pl`\n";
    }
}

main();
