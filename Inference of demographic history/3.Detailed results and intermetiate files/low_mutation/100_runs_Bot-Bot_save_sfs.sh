cat Bot_Bot/Bot_Bot_DAFpop0.txt > tables/SFS_Bot-Bot1.txt
for i in $(seq 1 25)
do
sh fastBot_Bot.sh
tail -n 1 Bot_Bot/Bot_Bot_DAFpop0.txt >> tables/SFS_Bot-Bot1.txt
done
