#!/bin/bash

source /config/shell_secrets.txt

rm -f tmp_file movie_urls_file movies_file
movie_url_query=""
movie_query=""

curl $NAS_MOVIE_URL -o tmp_file
grep "i_file.gif" tmp_file | cut -d'>' -f9 | cut -d'<' -f1> movie_urls_file
grep "i_file.gif" tmp_file | cut -d'>' -f9 | cut -d'.' -f1> movies_file

movie_url_query="{\"entity_id\":\"input_select.movie_url\",\"options\":[\"$(head -n 1 movie_urls_file)\""
while read line; do
	movie_url_query="$movie_url_query,\"$line\""
done < <(sed 1d movie_urls_file)
movie_url_query="$movie_url_query]}"

movie_query="{\"entity_id\":\"input_select.movie\",\"options\":[\"$(head -n 1 movies_file)\""
while read line; do
        movie_query="$movie_query,\"$line\""
done < <(sed 1d movies_file)
movie_query="$movie_query]}"

curl -X POST \
-H "Accept: application/json" \
-H "Authorization: Bearer $APITOKEN" \
-H "Content-Type: application/json" \
-d "$movie_url_query" \
$BASE_URL$API_PATH$INPUT_SELECT

curl -X POST \
-H "Accept: application/json" \
-H "Authorization: Bearer $APITOKEN=" \
-H "Content-Type: application/json" \
-d "$movie_query" \
$BASE_URL$API_PATH$INPUT_SELECT

rm -f tmp_file movie_urls_file movies_file