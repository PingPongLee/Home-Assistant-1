#!/bin/bash
rm -f tmp_file cover_file movies_file

first_line=1

curl $NAS_MOVIE_URL -o tmp_file
grep "i_file.gif" tmp_file | cut -d'>' -f9 | cut -d'.' -f1> movies_file

while read line; do
  file="$IMAGE_PATH$line.jpg"

  if [ ! -f "www/$file" ]; then
    curl -G \
      --silent \
      --data-urlencode "s=tt" \
      --data-urlencode "q=$line" \
      --data-urlencode "ttype=ft" \
      "https://www.imdb.com/find" -o cover_file

    cover_url=`grep "primary_photo" cover_file | cut -d'>' -f4 | cut -d'=' -f2 | cut -d'"' -f2 | sed -r 's/V1_.*_AL/V1_SY1000_SX640_AL/g'`
    if [ ${#cover_url} -le 5 ]; then
      cover_url="https://i.imgur.com/NUWSXfx.jpg"
    fi
    curl "$cover_url" -o "www/$file"
  fi
done < movies_file

rm -f tmp_file cover_file movies_file