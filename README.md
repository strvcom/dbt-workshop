# dbt Workshop

## How to update jupyter book

1. clone the repository, make your changes, commit and push as usual
2. build your book by running `jupyter-book build .`
3. install *ghp-import* `pip install ghp-import`
4. run `ghp-import -n -p -f _build/html` which should push the newly built HTML to the gh-pages branch