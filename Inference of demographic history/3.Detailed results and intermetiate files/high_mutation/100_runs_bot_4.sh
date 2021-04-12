for i in $(seq 76 100)
do
sh fastBot.sh
cut -f 5 -d "	" Bot/Bot.bestlhoods >> tables/MaxLhood_Bot4.txt
done
