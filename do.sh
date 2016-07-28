#!/bin/bash
# actors and actresses

HOME=/home/dmg/git.w/imdbScripts
IMDB=/home/dmg/temp/imdb/
OUT=/tmp/b

gunzip -c ${IMDB}/aka-titles.list.gz | perl ${HOME}/insert-aka.pl | sort -u > $OUT/aka.txt
exit

gunzip -c ${IMDB}/actors.list.gz | perl ${HOME}/insert-role.pl | sort -u | perl ${HOME}/nullify.pl  > $OUT/actorRoles.txt
gunzip -c ${IMDB}/actresses.list.gz | perl ${HOME}/insert-role.pl | sort -u | perl ${HOME}/nullify.pl > $OUT/actressRoles.txt

gunzip -c ${IMDB}/color-info.list.gz | perl ${HOME}/insert-color.pl | sort -u | perl ${HOME}/nullify.pl > $OUT/color.txt
gunzip -c ${IMDB}/countries.list.gz | perl ${HOME}/insert-country.pl | sort -u | perl ${HOME}/nullify.pl > $OUT/countries.txt
gunzip -c ${IMDB}/directors.list.gz | perl ${HOME}/insert-directors.pl | sort -u | perl ${HOME}/nullify.pl > $OUT/directors.txt
gunzip -c ${IMDB}/genres.list.gz | perl ${HOME}/insert-genre.pl  | sort -u | perl ${HOME}/nullify.pl> $OUT/genres.txt
gunzip -c ${IMDB}/language.list.gz | perl ${HOME}/insert-language.pl | sort -u | perl ${HOME}/nullify.pl > $OUT/languages.txt
gunzip -c ${IMDB}/locations.list.gz  | perl ${HOME}/insert-location.pl | sort -u | perl ${HOME}/nullify.pl  > $OUT/locations.txt
gunzip -c ${IMDB}/movie-links.list.gz | perl ${HOME}/insert-link.pl | sort -u | perl ${HOME}/nullify.pl > $OUT/links.txt
gunzip -c ${IMDB}/movies.list.gz | perl ${HOME}/insert-movies.pl | sort -u | perl ${HOME}/nullify.pl > $OUT/movies.txt
gunzip -c ${IMDB}/ratings.list.gz  | perl ${HOME}/insert-imdb-rating.pl| sort -u | perl ${HOME}/nullify.pl > $OUT/ratings.txt

gunzip -c ${IMDB}/actors.list.gz | perl ${HOME}/insert-person.pl 0 | sort -u | perl ${HOME}/nullify.pl   > $OUT/actors.txt
gunzip -c ${IMDB}/actresses.list.gz | perl ${HOME}/insert-person.pl 1 | sort -u | perl ${HOME}/nullify.pl > $OUT/actress.txt
gunzip -c ${IMDB}/directors.list.gz | perl ${HOME}/insert-person.pl 2 | sort -u | perl ${HOME}/nullify.pl > $OUT/dirs-persons.txt

#perl ${HOME}/insert-episodes.pl| sort -u | perl ${HOME}/nullify.pl > $OUT/episodes.txt 
