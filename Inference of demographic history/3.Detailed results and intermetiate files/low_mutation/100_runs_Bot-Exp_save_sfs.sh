cat Exp_Bot/Exp_Bot_DAFpop0.txt > tables/SFS_Bot-Exp1.txt
for i in $(seq 1 25)
do
sh fastExp_Bot.sh
tail -n 1 Exp_Bot/Exp_Bot_DAFpop0.txt >> tables/SFS_Bot-Exp1.txt
done
