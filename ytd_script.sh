#!/usr/bin/env zsh

# time youtube-dl $1 \
# -f bestaudio --extract-audio --add-metadata \
# --xattrs --prefer-ffmpeg \
# --postprocessor-args "-metadata Album='Kochi Muziris' -metadata Genre='concert' -metadata Artist='TM Krishna' " 

parse_options()
 {
     # last_param = ${*: -1:1}
     o_url=(-y)
     o_title=(-t)
     o_album=(-a)
     o_singer=(-s)
     o_genre=(-g)
     zparseopts -K -- y:=o_url t:=o_title a:=o_album s:=o_singer g:=o_genre h=o_help 

     url=$o_url[2] 
     if [[ $? != 0 || "$o_help" != ""  ]]; then
           echo Usage: $(basename "$0") "[-y videourl] [-t title] [-a albumname] [-s singer] [-g genre]"
           exit 1
     elif  [ "$url" = "" ]; then
           echo Usage: $(basename "$0") "[-y videourl] [-t title] [-a albumname] [-s singer] [-g genre]"
           exit 1
     fi

     title=$o_title[2]
     album=$o_album[2]
     singer=$o_singer[2]
     genre=$o_genre[2]


    
 }
# now use the function:
# echo ${*: -1:1}
parse_options $*

# echo "url=$url ; title=$title ; album=$album ; singer=$singer ; genre=$genre"

# postproc="-metadata Title='$title' -metadata Album='$album' -metadata Genre='$genre' -metadata Artist='$singer'" 
postproc=""

if [ "$title" != "" ]; then
    postproc="$postproc -metadata Title='$title' "
fi    

if [ "$album" != "" ]; then
    postproc="$postproc -metadata Album='$album' "
fi    

if [ "$singer" != "" ]; then
    postproc="$postproc -metadata Artist='$singer' "
fi    

if [ "$genre" != "" ]; then
    postproc="$postproc  -metadata Genre='$genre' "
fi    

ytdl_command="youtube-dl $url -f bestaudio --extract-audio --add-metadata --xattrs --prefer-ffmpeg"

if [ "$postproc" != "" ]; then
    ytdl_command="$ytdl_command  --postprocessor-args \"$postproc\""
fi

echo $ytdl_command
eval $ytdl_command

for file in *\ *
do
  # echo $file
  new_fname=`echo $file | tr " " "_"`
  mv $file $new_fname
done
