for i in $(seq 26 50)
do
sh fastBot.sh
cut -f 5 -d "	" Bot/Bot.bestlhoods >> tables/MaxLhood_Bot2.txt
done
