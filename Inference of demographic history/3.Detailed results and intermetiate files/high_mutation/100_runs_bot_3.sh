for i in $(seq 51 75)
do
sh fastBot.sh
cut -f 5 -d "	" Bot/Bot.bestlhoods >> tables/MaxLhood_Bot3.txt
done
