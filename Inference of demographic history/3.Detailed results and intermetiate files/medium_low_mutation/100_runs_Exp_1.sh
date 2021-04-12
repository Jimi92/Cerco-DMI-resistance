> tables/MaxLhood_Exp1.txt
for i in $(seq 1 25)
do
sh fastExp.sh
tail -n 1 Exp/Exp.bestlhoods >> tables/MaxLhood_Exp1.txt
done
