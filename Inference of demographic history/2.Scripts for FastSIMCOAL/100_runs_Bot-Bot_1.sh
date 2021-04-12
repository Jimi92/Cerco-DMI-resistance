> tables/MaxLhood_Bot_Bot1.txt
for i in $(seq 1 25)
do
sh fastBot_Bot.sh
tail -n 1 Bot_Bot/Bot_Bot.bestlhoods >> tables/MaxLhood_Bot_Bot1.txt
done
