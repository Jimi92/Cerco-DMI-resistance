cat Bot/Bot_DAFpop0.txt > tables/SFS_Bot1.txt
for i in $(seq 1 25)
do
sh fastBot.sh
tail -n 1 Bot/Bot_DAFpop0.txt >> tables/SFS_Bot1.txt
done
