#!/bin/bash
echo Start
filename='tokenssounds.csv'
outfilename='GuildWars.ds.robot'
if [[ -f "$outfilename" ]]; then
    echo "deleting old output file"
    rm $outfilename
fi
linecount=0
while read line; do
    token=${line%%,*}
    sound=${line#*,}
    sound=${sound//[$'\t\r\n']}
    echo "Token: $token"
    echo "Sound: $sound"
    if [[ -z "$sound" ]]; then
        echo "No sound"
    else
        espeak-ng -v mb-en1 -s 150 -g 5 -w "$token.wav" "$sound"
        ffmpeg -y -i "$token.wav" -c:a mp3 -ac 2 "$token.mp3"
        rm "$token.wav"
        echo "$token:robotvoice/$token.mp3[0]" >> $outfilename
    fi
done < "$filename"
echo "Done!"
