for i in 1 2
do
echo "processing S=200"
./sfs_code 1 2 -n 89 -t 0.0017 -P 1 -L 1 1000000 -Td 0 0.026 -TE 0.0047 -r 0.063 -W 1 200.0  0.0 1.0 -o sfs_out/sims_background_selection_set${i}_200M.txt
./sfs_code 1 2 -n 89 -t 0.0017 -P 1 -L 1 1000000 -Td 0 0.026 -TE 0.0047  -r 0.063 -o sfs_out/sims_NO_selection_set${i}_82Kindv.txt
echo "processing S=100"
./sfs_code 1 2 -n 89 -t 0.0017 -P 1 -L 1 1000000 -Td 0 0.026 -TE 0.0047  -r 0.063 -W 1 100.0  0.0 1.0 -o sfs_out/sims_background_selection_set${i}_100M_82Kindv.txt
echo "processing S=75"
./sfs_code 1 2 -n 89 -t 0.0017 -P 1 -L 1 1000000 -Td 0 0.026 -TE 0.0047  -r 0.063 -W 1 75.0  0.0 1.0 -o sfs_out/sims_background_selection_set${i}_75M.txt
echo "processing S=50"
./sfs_code 1 2 -n 89 -t 0.0017 -P 1 -L 1 1000000 -Td 0 0.026 -TE 0.0047  -r 0.063 -W 1 50.0  0.0 1.0 -o sfs_out/sims_background_selection_set${i}_50M_82Kindv.txt
echo "processing S=1000"
./sfs_code 1 2 -n 89 -t 0.0017 -P 1 -L 1 1000000 -Td 0 0.026 -TE 0.0047  -r 0.063 -W 1 1000.0  0.0 1.0 -o sfs_out/sims_background_selection_set${i}_1000M_82Kindv.txt
done

#parameter explanation
# -n number of samples 
# -t the scaled parameter θ = 2Neμ
# -P ploidy
# -L number of similated loci and length
# -Td sudden change of effective population size at time generations/2Ne
# -TE scaled time of generations between the event and the present (generations/2Ne)
# -r scaled recombination rate
# -W distribution (in this case a fixed value) and strength of negative selection (Ne X S). In this case, all non-synonymous mutations are considered to be negatively selected.