up:
	perl generate_rss.pl && git add . && git commit -m "update" && git push

rss:
	perl generate_rss.pl
