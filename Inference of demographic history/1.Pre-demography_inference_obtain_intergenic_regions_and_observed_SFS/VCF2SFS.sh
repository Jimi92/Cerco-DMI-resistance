#! bash
#! To be used with VCF_table2.py
#! The first isolate should always be the outgroup

#cut off the heders from the VCF file 

tail -n +284 Intergenic_o,3.vcf > vcf_table
# create a matrix with values (0,1,2,3) that represent the state of each SNP in comparison to the reference (please see VCF documentation)

> SFStable.txt
> tmp3.txt
> tmp2.txt
> tmp1.txt

head -n 1 test.txt > tmp1.txt
sed -i "s/	/\n/g" tmp1.txt
cut -c 1 tmp1.txt > tmp2.txt
cat tmp2.txt > SFStable.txt

for i in $(seq 1 25602);
do head -n $i test.txt | tail -n 1 > tmp1.txt; 
sed -i "s/	/\n/g" tmp1.txt; 
cut -c 1 tmp1.txt > tmp2.txt 
paste -d "	" tmp2.txt SFStable.txt > tmp3.txt
cat tmp3.txt > SFStable.txt
done

python3 VCF_table2.py
