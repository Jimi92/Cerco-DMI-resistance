> tables/MaxLhood_Bot1.txt
for i in $(seq 1 25)
do
sh fastBot.sh
tail -n 1 Bot/Bot.bestlhoods >> tables/MaxLhood_Bot1.txt
done
