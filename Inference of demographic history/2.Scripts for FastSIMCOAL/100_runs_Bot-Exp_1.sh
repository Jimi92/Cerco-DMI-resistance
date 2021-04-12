> tables/MaxLhood_Exp_Bot1.txt
for i in $(seq 1 25)
do
sh fastExp_Bot.sh
tail -n 1 Exp_Bot/Exp_Bot.bestlhoods >> tables/MaxLhood_Exp_Bot1.txt
done
