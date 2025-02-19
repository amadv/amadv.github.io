# My personal website

This is source code for [amadv.github.com](https://amadv.github.io), my personal website.
It is written mostly in bash, and uses [markdown.awk from knazarov](https://git.knazarov.com/knazarov/markdown.awk) to convert
markdown posts and pages to HTML.

The site has very minimal CSS (about 110 lines) that should be enough to display fine in most browsers
including mobile..

I don't intend the code to be easily readable, but given that it's not much, you can probably figure
things out.

## Building

If you're on any Linux system, you can just type `make` in your terminal, and the result will be in the
`./output` directory. However, if you're on a Mac, you probably would need to use gnu awk/sed.


## License

The code is BSD licensed.
Content in Markdown files is [CC-BY](https://creativecommons.org/licenses/by-sa/4.0/).
