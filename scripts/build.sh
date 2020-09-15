#!/usr/bin/env bash
set -x

mkdir -p build/images build/css build/fonts build/blog

cp source/*.html build
cp source/*.html.en build
cp source/*.html.de build
cp source/blog/*.html build/blog/
cp source/blog/*.html.en build/blog/
cp source/blog/*.html.de build/blog/
cp source/*.xml build
cp source/.htaccess build
cp source/robots.txt build
# cp source/images/*.ico build
cp source/css/* build/css
cp source/images/*.png build/images
cp source/images/*.jpg build/images
cp source/images/*.svg build/images
cp source/fonts/* build/fonts

# optimize png files

for filename in build/images/*.png; do
  mogrify \
    -depth 24 \
    -define png:compression-filter=2 \
    -define png:compression-level=9 \
    -define png:compression-strategy=1 \
    -resize 75% \
    $filename
done

# optimize html files

for filename in build/*.html build/*.html.en build/*.html.de build/blog/*.html build/blog/*.html.en build/blog/*.html.de; do
  html-minifier \
    --collapse-whitespace \
    --remove-comments \
    --remove-redundant-attributes \
    --remove-script-type-attributes \
    --use-short-doctype \
    --minify-css true \
    --minify-js true \
    --output $filename \
    $filename
done

#favicon
convert source/images/SCS-Logo-832x832.png -define icon:auto-resize=64,48,32,16 build/favicon.ico
convert source/images/SCS-Logo-832x832.png -resize 32x32 build/images/favicon-32x32.png
convert source/images/SCS-Logo-832x832.png -resize 96x96 build/images/favicon-96x96.png
convert source/images/SCS-Logo-832x832.png -resize 180x180 build/images/apple-icon-180x180.png


# optimize css files

for filename in build/css/*.css; do
  cleancss -o $filename $filename
done
