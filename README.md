# Poster Gallery

Academic posters from any field, published so anyone can look at them.

When I was creating my first poster, I had little idea on how to make it look and what it
should cover. I noticed there are not many posters published online and you have to go to a
conference to see them. This is my attempt to fix that.

Every poster opens as a PDF, and many come with the source they were made from, so you can
see both the result and how it was built.

**Browse:** https://asmarcz.github.io/poster-gallery/

## Add your poster

Presented a poster? Add it with a pull request. All you need is the title and the PDF;
the source and details like authors and conference are welcome.

You don't have to read the instructions yourself: point your coding agent at
[CONTRIBUTING.md](CONTRIBUTING.md) and your poster, e.g.

> Add my poster `~/talks/poster.pdf` to github.com/asmarcz/poster-gallery following its CONTRIBUTING.md.

## How it works

Each poster is a folder in `posters/` with a `poster.yml`, the PDF, and optionally its source
and extended abstract.
Pull requests are checked by CI and reviewed by hand ([REVIEWING.md](REVIEWING.md)).
Merging to `main` publishes the site on GitHub Pages.

Research fields follow the ACM Computing Classification System, arXiv's categories and
Springer Nature's subjects (Product Market Codes, Springer Nature SciGraph, CC BY-NC 4.0),
generated into `taxonomy/` by the scripts in `scripts/`.

To run it locally you need Node.js 22+ and `pdftoppm`:

```sh
npm ci
npm run dev
```
