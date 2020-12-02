#! bash

#obtain intergenic regions (the file "InterPlus.bed" was obtained by the annotation (gff) file. I used the annotation file to extract the coordinates of all predicted CDS regions and I have added 500 bp to bothe ends of each CDS. subsequently I have excluded these 500+CDS+500 regions from the vcf. That resulted in a VCF file that contained the intergenic regions)
vcftools --vcf ${VCF} --bed InterPlus.bed --recode --recode-INFO-all --out Intergenic_regions

## variables
INPUT_DIR=/home/taliadoros/Desktop/phd_projects/Cb/selection_fungicide_resistance/fastsimcoal26/intergenic_thin/
VCF=Intergenic_regions.vcf
OUTPUT_DIR=/home/taliadoros/Desktop/phd_projects/Cb/selection_fungicide_resistance/fastsimcoal26/intergenic_thin/

#thin intergenic file
cd ${INPUT_DIR}
vcftools --vcf ${VCF} --thin 300 --recode --recode-INFO-all --out ${VCF%.vcf}_thin_0.3kb

#create a table with the level of missingness per isolate
> reg_track.txt
i=1
while read p
do
echo reg${i} | tr "\n" "	" >> reg_track.txt
echo $p >> reg_track.txt
echo "#Chr	start	end" > tmp.bed
echo "${p}" >> tmp.bed
sed -i "s/ /	/g" tmp.bed
vcftools --vcf /home/taliadoros/Desktop/phd_projects/Cb/selection_fungicide_resistance/fastsimcoal26/Intergenic_regions_thin_0.3kb.recode.vcf --bed tmp.bed --missing-indv \
--out /home/taliadoros/Desktop/phd_projects/Cb/selection_fungicide_resistance/fastsimcoal26/short_DNA_regs/missingness_per_region/reg${i}
i=$((i+1))
done < short_regions.bed

cd /home/taliadoros/Desktop/phd_projects/Cb/selection_fungicide_resistance/fastsimcoal26/short_DNA_regs/missingness_per_region/
> miss_table.txt
for each in *.imiss
do
echo ${each%.lmiss} | tr "\n" "	" >> miss_table.txt
cat ${each} | datamash -H mean 4 | tr "\n" "	" > temp.txt
cut -f 2 -d "	" temp.txt >> miss_table.txt
done
