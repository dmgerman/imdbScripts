#!/bin/bash
# actors and actresses

HOME=/opt2/imdb2014
OUT=/tmp/b

#gunzip -c ${HOME}/actors.list.gz | perl /home/dmg/git.dmg/hacking/imdb/insert-role.pl | sort -u | perl /home/dmg/git.dmg/hacking/imdb/nullify.pl  > $OUT/actorRoles.txt
#gunzip -c ${HOME}/actresses.list.gz | perl /home/dmg/git.dmg/hacking/imdb/insert-role.pl | sort -u | perl /home/dmg/git.dmg/hacking/imdb/nullify.pl > $OUT/actressRoles.txt
#gunzip -c ${HOME}/aka-titles.list.gz | perl /home/dmg/git.dmg/hacking/imdb/insert-aka.pl | sort -u | perl /home/dmg/git.dmg/hacking/imdb/nullify.pl > $OUT/aka.txt
#gunzip -c ${HOME}/color-info.list.gz | perl /home/dmg/git.dmg/hacking/imdb/insert-color.pl | sort -u | perl /home/dmg/git.dmg/hacking/imdb/nullify.pl > $OUT/color.txt
#gunzip -c ${HOME}/countries.list.gz | perl /home/dmg/git.dmg/hacking/imdb/insert-country.pl | sort -u | perl /home/dmg/git.dmg/hacking/imdb/nullify.pl > $OUT/countries.txt
#gunzip -c ${HOME}/directors.list.gz | perl /home/dmg/git.dmg/hacking/imdb/insert-directors.pl | sort -u | perl /home/dmg/git.dmg/hacking/imdb/nullify.pl > $OUT/directors.txt
#gunzip -c ${HOME}/genres.list.gz | perl /home/dmg/git.dmg/hacking/imdb/insert-genre.pl  | sort -u | perl /home/dmg/git.dmg/hacking/imdb/nullify.pl> $OUT/genres.txt
#gunzip -c ${HOME}/language.list.gz | perl /home/dmg/git.dmg/hacking/imdb/insert-language.pl | sort -u | perl /home/dmg/git.dmg/hacking/imdb/nullify.pl > $OUT/languages.txt
#gunzip -c ${HOME}/locations.list.gz  | perl /home/dmg/git.dmg/hacking/imdb/insert-location.pl | sort -u | perl /home/dmg/git.dmg/hacking/imdb/nullify.pl  > $OUT/locations.txt
#gunzip -c ${HOME}/movie-links.list.gz | perl /home/dmg/git.dmg/hacking/imdb/insert-link.pl | sort -u | perl /home/dmg/git.dmg/hacking/imdb/nullify.pl > $OUT/links.txt
#gunzip -c ${HOME}/movies.list.gz | perl /home/dmg/git.dmg/hacking/imdb/insert-movies.pl | sort -u | perl /home/dmg/git.dmg/hacking/imdb/nullify.pl > $OUT/movies.txt
#gunzip -c ${HOME}/ratings.list.gz  | perl /home/dmg/git.dmg/hacking/imdb/insert-imdb-rating.pl| sort -u | perl /home/dmg/git.dmg/hacking/imdb/nullify.pl > $OUT/ratings.txt

#gunzip -c ${HOME}/actors.list.gz | perl /home/dmg/git.dmg/hacking/imdb/insert-person.pl 0 | sort -u | perl /home/dmg/git.dmg/hacking/imdb/nullify.pl   > $OUT/actors.txt
#gunzip -c ${HOME}/actresses.list.gz | perl /home/dmg/git.dmg/hacking/imdb/insert-person.pl 1 | sort -u | perl /home/dmg/git.dmg/hacking/imdb/nullify.pl > $OUT/actress.txt
#gunzip -c ${HOME}/directors.list.gz | perl /home/dmg/git.dmg/hacking/imdb/insert-person.pl 2 | sort -u | perl /home/dmg/git.dmg/hacking/imdb/nullify.pl > $OUT/dirs-persons.txt

#perl /home/dmg/git.dmg/hacking/imdb/insert-episodes.pl| sort -u | perl /home/dmg/git.dmg/hacking/imdb/nullify.pl > $OUT/episodes.txt 
