default: 

DIR=/home/dmg/temp/imdb

genres.schema:
	sh doSchema.sh genres

genres.done:	genres.schema
	gunzip -c ${DIR}/genres.list.gz | perl /home/dmg/git.dmg/hacking/imdb/insert-genre.pl 
	echo "Done genres" | tee genres.done



