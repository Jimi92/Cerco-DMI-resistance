for i in $(seq 51 75)
do
sh fast${wort}.sh
cut -f 4 -d "	" ${wort}/${wort}.bestlhoods >> MaxLhood_${wort}3.txt
done
