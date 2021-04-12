#./convertSFS_CODE sims_background_selection_50.txt --alignment F backgroud_sfs_code50_fasta.fa
#./convertSFS_CODE sims_background_selection_100.txt --alignment F backgroud_sfs_code100_fasta.fa
#./convertSFS_CODE sims_background_selection_500.txt --alignment F backgroud_sfs_code500_fasta.fa
for each in *.txt
do
echo ${each}
./convertSFS_CODE ${each} --alignment F ${each%.txt}.fa
done
