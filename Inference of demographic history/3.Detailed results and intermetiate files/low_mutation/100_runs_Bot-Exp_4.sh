for i in $(seq 76 100)
do
sh fast${wort}.sh
cut -f 4 -d "	" ${wort}/${wort}.bestlhoods >> MaxLhood_${wort}4.txt
done
