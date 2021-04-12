cat Exp/Exp_DAFpop0.txt > tables/SFS_Exp1.txt
for i in $(seq 1 25)
do
sh fastExp.sh
tail -n 1 Exp/Exp_DAFpop0.txt >> tables/SFS_Exp1.txt
done
