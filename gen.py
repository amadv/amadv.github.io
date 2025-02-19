#!/usr/bin/env python3

import subprocess
import tempfile
import markdown
import re
import jinja2
import shutil
import datetime
import argparse
from email import utils # for RFC822 dates
from pathlib import Path

MARKDOWN_EXTENSIONS = ['fenced_code', 'sane_lists']

script_directory = Path(__file__).parent.resolve()
templates = script_directory / "templates"

def short_date(dt: str) -> str:
    parsed = datetime.datetime.fromisoformat(dt)
    return parsed.date().isoformat()

def rfc822_date(dt: str) -> str:
    parsed = datetime.datetime.fromisoformat(dt)
    return utils.format_datetime(parsed)

def split_header(md_text: str) -> tuple[dict[str, str], str]:
    # matches key-value pairs separated by ":"
    header_pattern = r'^\s*(?P<key>[a-zA-Z0-9-]+)\s*:\s*(?P<value>.+)\s*$'

    header: dict[str, str] = {}
    body = ""
    in_header = True

    for line in md_text.splitlines():
        if in_header:
            match = re.match(header_pattern, line)
            if not match:
                in_header = False
            else:
                header[match.group('key')] = match.group('value')
        else:
            body += line + "\n"

    return header, body.strip()

def post_to_html(input_file: Path):
    text = input_file.read_text()
    header, body = split_header(text)

    content_html = markdown.markdown(body, extensions=MARKDOWN_EXTENSIONS)

    env = jinja2.Environment(loader=jinja2.FileSystemLoader(str(templates)))

    template = env.get_template('post.html.j2')

    context = {"title": header["Subject"], "content": content_html}

    return template.render(context)

def make_page(input_file: Path, output_file: Path):
    text = input_file.read_text()
    header, body = split_header(text)

    page_template = input_file.parent / "note.html.j2"
    template = 'page.html.j2'
    if page_template.is_file():
        template = page_template.name

    content_html = markdown.markdown(body, extensions=MARKDOWN_EXTENSIONS)

    env = jinja2.Environment(loader=jinja2.FileSystemLoader([str(templates), input_file.parent]))

    template = env.get_template(template)

    context = {"title": header["Subject"], "content": content_html}

    html = template.render(context)

    _ = output_file.write_text(html)

def gen_post_index(posts: Path, output_file: Path):
    all_posts : list[dict[str, str]] = []
    for post_dir in posts.glob("*"):
        input_file = (post_dir / "note.md")
        text = input_file.read_text()
        header, _ = split_header(text)

        post: dict[str, str] = {}
        post["title"] = header["Subject"]
        post["date"] = short_date(header["X-Date"])
        post["datetime"] = header["X-Date"]
        post["url"] = "/posts/" + post_dir.name

        all_posts.append(post)

    context = {}
    context["posts"] = sorted(all_posts, key = lambda p: p["datetime"], reverse=True)

    env = jinja2.Environment(loader=jinja2.FileSystemLoader(str(templates)))
    template = env.get_template('posts.html.j2')

    html = template.render(context)

    _ = output_file.write_text(html)

def gen_rss(posts: Path, output_file: Path):
    all_posts : list[dict[str, str]] = []
    for post_dir in posts.glob("*"):
        input_file = (post_dir / "note.md")
        text = input_file.read_text()
        header, body = split_header(text)

        post_html = markdown.markdown(body, extensions=MARKDOWN_EXTENSIONS)

        post: dict[str, str] = {}
        post["title"] = header["Subject"]
        post["rfc822_date"] = rfc822_date(header["X-Date"])
        post["datetime"] = header["X-Date"]
        post["url"] = "/posts/" + post_dir.name
        post["guid"] = "https://amadv.github.com/posts/" + post_dir.name
        post["content"] = post_html

        all_posts.append(post)

    context = {}
    context["posts"] = sorted(all_posts, key = lambda p: p["datetime"])[-10:]
    context["rfc822_date"] = rfc822_date(datetime.datetime.now().isoformat())

    env = jinja2.Environment(loader=jinja2.FileSystemLoader(str(templates)))
    template = env.get_template('rss.xml.j2')

    html = template.render(context)

    _ = output_file.write_text(html)

def gen_feedback(output_file: Path):
    env = jinja2.Environment(loader=jinja2.FileSystemLoader(str(templates)))
    template = env.get_template('feedback.html.j2')

    html = template.render({})

    output_file.parent.mkdir(parents=True, exist_ok=True)
    _ = output_file.write_text(html)



def generate(output: Path):
    posts = script_directory / "content/posts"
    pages = script_directory / "content/pages"
    static = script_directory / "static"

    output.mkdir(parents=True, exist_ok=True)

    for post_dir in posts.glob("*"):
        if post_dir.is_dir():
            input_file = (post_dir / "note.md")

            output_dir = (output / "posts" / post_dir.name)
            output_file = output_dir / "index.html"

            output_dir.mkdir(parents=True, exist_ok=True)
            html = post_to_html(input_file)

            _ = output_file.write_text(html)

    for page_dir in pages.glob("*"):
        if page_dir.is_dir():
            input_file = (page_dir / "note.md")

            output_dir = (output / page_dir.name)
            output_file = output_dir / "index.html"

            output_dir.mkdir(parents=True, exist_ok=True)
            make_page(input_file, output_file)

    for static_file in static.glob("*"):
        if static_file.is_file():
            shutil.copy(static_file, output / static_file.name)

    input_index_file = script_directory / "content/index.md"
    output_index_file = output / "index.html"
    make_page(input_index_file, output_index_file)

    gen_post_index(posts, output / "posts/index.html")

    gen_rss(posts, output / "rss.xml")

    gen_feedback(output / "feedback/index.html")

    # gen_cv_pdf(pages / "cv/note.md", output / "cv.pdf")

def main():
    parser = argparse.ArgumentParser()
    _ = parser.add_argument("output", default = "docs", nargs="?")
    args = parser.parse_args()

    output = Path(args.output)
    generate(output)

if __name__ == "__main__":
    main()
