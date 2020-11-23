#!/usr/bin/env python

"""Resolve relative links in an HTML blob according to a base"""

from BeautifulSoup import BeautifulSoup
import sys
import urlparse

# source: http://stackoverflow.com/questions/2725156/complete-list-of-html-tag-attributes-which-have-a-url-value
# TODO: "These aren't necessarily simple URLs ..."
targets = [
    ('a', 'href'), ('applet', 'codebase'), ('area', 'href'), ('base', 'href'),
    ('blockquote', 'cite'), ('body', 'background'), ('del', 'cite'),
    ('form', 'action'), ('frame', 'longdesc'), ('frame', 'src'),
    ('head', 'profile'), ('iframe', 'longdesc'), ('iframe', 'src'),
    ('img', 'longdesc'), ('img', 'src'), ('img', 'usemap'), ('input', 'src'),
    ('input', 'usemap'), ('ins', 'cite'), ('link', 'href'),
    ('object', 'classid'), ('object', 'codebase'), ('object', 'data'),
    ('object', 'usemap'), ('q', 'cite'), ('script', 'src'), ('audio', 'src'),
    ('button', 'formaction'), ('command', 'icon'), ('embed', 'src'),
    ('html', 'manifest'), ('input', 'formaction'), ('source', 'src'),
    ('video', 'poster'), ('video', 'src'),
]

def rebase_one(base, url):
    """Rebase one url according to base"""

    parsed = urlparse.urlparse(url)
    if parsed.scheme == parsed.netloc == '':
        return urlparse.urljoin(base, url)
    else:
        return url

def rebase(base, data):
    """Rebase the HTML blob data according to base"""

    soup = BeautifulSoup(data)

    for (tag, attr) in targets:
        for link in soup.findAll(tag):
            try:
                url = link[attr]
            except KeyError:
                pass
            else:
                link[attr] = rebase_one(base, url)
    return unicode(soup)


if __name__ == '__main__':
    try:
        base = sys.argv[1]
    except IndexError:
        print >> sys.stderr, "Usage: %s BASEURL" % sys.argv[0]
        sys.exit(1)

    data = sys.stdin.read()
    print rebase(base, data)

