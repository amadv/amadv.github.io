#!/usr/bin/env perl
# generate_rss.pl - Perl equivalent of generate_rss.py
# Builds rss.xml from the homepage index.html #post-list.
# Uses only core Perl modules (POSIX, FindBin) - no CPAN packages required.

use strict;
use warnings;
use POSIX qw(strftime);
use FindBin;

my $BLOG_URL         = 'https://amadved.com';
my $BLOG_TITLE       = 'A.Madved';
my $BLOG_DESCRIPTION = 'Personal blog of Aaron Madved - doing loops';
my $AUTHOR_EMAIL     = 'aaronmadved@gmail.com';
my $BASE             = $FindBin::Bin;
my $OUT_PATH         = "$BASE/rss.xml";

sub read_utf8 {
    my ($path) = @_;
    open my $fh, '<:encoding(UTF-8)', $path or die "cannot read $path: $!";
    local $/;
    my $content = <$fh>;
    close $fh;
    return $content;
}

sub unescape_entities {
    my ($s) = @_;
    my %named = (
        amp    => '&',
        lt     => '<',
        gt     => '>',
        quot   => '"',
        apos   => "'",
        nbsp   => ' ',
        ndash  => "\x{2013}",
        mdash  => "\x{2014}",
        hellip => "\x{2026}",
        lsquo  => "\x{2018}",
        rsquo  => "\x{2019}",
        ldquo  => "\x{201C}",
        rdquo  => "\x{201D}",
        copy   => "\x{A9}",
        reg    => "\x{AE}",
        trade  => "\x{2122}",
    );
    $s =~ s{&(#x([0-9a-fA-F]{1,6})|#([0-9]{1,7})|([a-zA-Z][a-zA-Z0-9]*));}{
        my ($hex, $dec, $name) = ($2, $3, $4);
        if (defined $hex) {
            my $n = hex($hex);
            $n <= 0x10FFFF ? chr($n) : "&#x$hex;";
        } elsif (defined $dec) {
            my $n = $dec + 0;
            $n <= 0x10FFFF ? chr($n) : "&#$dec;";
        } elsif (exists $named{$name}) {
            $named{$name};
        } else {
            $&;
        }
    }ge;
    return $s;
}

# Extract blog posts from the main index.html file.
sub extract_posts_from_index {
    my $html = read_utf8("$BASE/index.html");
    my ($list) = $html =~ m{<ul\s+id="post-list"[^>]*>(.*?)</ul>}is;
    return () unless defined $list;

    my @posts;
    while ($list =~ m{<li\s+data-date="([^"]*)"[^>]*>\s*<a\s+href="([^"]+)">(.*?)</a>}gis) {
        my ($date, $href, $title) = ($1, $2, $3);
        $date =~ s/:\s*$//;
        $title =~ s{<[^>]*>}{}g;
        $title = unescape_entities($title);
        $title =~ s/^\s+|\s+$//g;
        my $url  = $href =~ m{^/} ? $BLOG_URL . $href : $href;
        my $path = $href =~ m{^/} ? substr($href, 1) : $href;
        push @posts, { date => $date, title => $title, url => $url, path => $path, idx => scalar(@posts) };
    }
    # Sort by date (newest first); ties keep homepage order (stable, like Python's sort).
    @posts = sort { $b->{date} cmp $a->{date} || $a->{idx} <=> $b->{idx} } @posts;
    return @posts;
}

# Extract a text excerpt from a blog post HTML file.
sub extract_content_from_post {
    my ($post_path) = @_;
    my $file = "$BASE/$post_path/index.html";
    return '' unless -f $file;

    my $html = read_utf8($file);
    my ($body) = $html =~ m{<body[^>]*>(.*?)</body>}is;
    return '' unless defined $body;

    $body =~ s{<script\b.*?</script>}{}gis;
    $body =~ s{<style\b.*?</style>}{}gis;
    $body =~ s{<[^>]+>}{}g;
    $body = unescape_entities($body);

    my @lines = grep { length } map { my $l = $_; $l =~ s/^\s+|\s+$//g; $l } split /\n/, $body;

    my $content_start = 0;
    for my $i (0 .. $#lines) {
        if ($lines[$i] =~ m{^#} || $lines[$i] =~ m{home}i) {
            $content_start = $i + 1;
            last;
        }
    }

    my $content = $content_start < @lines
        ? join(' ', @lines[$content_start .. $#lines])
        : join(' ', @lines);

    if (length($content) > 500) {
        $content = substr($content, 0, 500) . '...';
    }
    return $content;
}

# RFC-822 publish date from an ISO-8601 date (e.g. 2026-09-06).
sub rfc822_date {
    my ($date) = @_;
    my ($y, $m, $d) = $date =~ m{^(\d{4})-(\d{2})-(\d{2})$} or return '';
    return strftime('%a, %d %b %Y %H:%M:%S +0000', 0, 0, 0, $d, $m - 1, $y - 1900);
}

sub generate_rss_item {
    my ($post) = @_;
    my $content = extract_content_from_post($post->{path});
    my $description = length($content) ? $content : $post->{title};
    my $pub_date = rfc822_date($post->{date});

    return "    <item>\n"
        . "      <title><![CDATA[$post->{title}]]></title>\n"
        . "      <link>$post->{url}</link>\n"
        . "      <guid>$post->{url}</guid>\n"
        . "      <pubDate>$pub_date</pubDate>\n"
        . "      <description><![CDATA[$description]]></description>\n"
        . "    </item>";
}

sub generate_rss_feed {
    my (@posts) = @_;
    my $last_build_date = strftime('%a, %d %b %Y %H:%M:%S +0000', localtime(time));
    my @top = @posts > 20 ? @posts[0 .. 19] : @posts;
    my $items = join("\n", map { generate_rss_item($_) } @top);

    my $feed = <<"RSS";
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
  <channel>
    <title>$BLOG_TITLE</title>
    <link>$BLOG_URL</link>
    <description>$BLOG_DESCRIPTION</description>
    <language>en-us</language>
    <lastBuildDate>$last_build_date</lastBuildDate>
    <atom:link href="$BLOG_URL/rss.xml" rel="self" type="application/rss+xml" />
    <managingEditor>$AUTHOR_EMAIL (Amadv)</managingEditor>
    <webMaster>$AUTHOR_EMAIL (Amadv)</webMaster>
$items
  </channel>
</rss>
RSS
    chomp $feed;   # match Python output (no trailing newline)
    return $feed;
}

sub main {
    print "Generating RSS feed...\n";

    my @posts = extract_posts_from_index();
    print "Found " . scalar(@posts) . " posts\n";

    if (!@posts) {
        print "No posts found, skipping RSS generation\n";
        return;
    }

    my $rss_content = generate_rss_feed(@posts);

    open my $fh, '>:encoding(UTF-8)', $OUT_PATH or die "cannot write $OUT_PATH: $!";
    print $fh $rss_content;
    close $fh;

    print "RSS feed generated: $OUT_PATH\n";
    print "Latest post: $posts[0]{title} ($posts[0]{date})\n";
}

main();
