for i in $(seq 26 50)
do
sh fast${wort}.sh
cut -f 4 -d "	" ${wort}/${wort}.bestlhoods >> MaxLhood_${wort}2.txt
done
