#prior to this script, use trimmomatic to trim reads, and find paired reads (discard unpaired reads)
#this script takes paired Illumina reads for each isolate, aligns to reference genome, and identifies any variants (SNPs or small indels). The output is a variant call file (vcf) containing variants for each isolate compared to the reference genome.
#!/bin/bash

read -p "Enter name of reference : " reference
echo

read -p "Name of project : " project
echo

#bwa index reference genome that all reads will be aligned to, then align paired reads from each isolate to the reference genome 

bwa index ${reference}.fasta

for sample in *_1.fq.gz
        
   				 do
    				echo $sample
    				describer=$(echo ${sample} | sed 's/_1.fq.gz//')
    				echo $describer

echo "Paired reads 1: " ${describer}_1.fq.gz
echo "Paired reads 2: " ${describer}_2.fq.gz
bwa mem -R "@RG\tID:$describer\tSM:$describer\tPL:ILLUMINA" ${reference}.fasta ${describer}_1.fq.gz ${describer}_2.fq.gz > ${describer}.sam

done

#Convert to BAM
ls *.sam | parallel "samtools view -S -b {} > {}.bam " 

rename s/sam.bam/bam/ *.bam 

for sample in *.bam
        
   				 do
				echo $sample
    				describer=$(echo ${sample} | sed 's/.bam//')
    				echo $describer

samtools sort ${describer}.bam > ${describer}.sorted.bam

samtools index ${describer}.sorted.bam

done
	
#Create indices for reference genome

samtools faidx ${reference}.fasta | java -jar /home/bspanner/picard.jar CreateSequenceDictionary R=${reference}.fasta O=${reference}.dict

#For variant calling

ls *sorted.bam | parallel --eta -j 10 "/home/bspanner/gatk-4.0.8.1/gatk --java-options "-Xmx4g" HaplotypeCaller -R ${reference}.fasta -I {} --sample-ploidy 1 --standard-min-confidence-threshold-for-calling 50 -O {.}.g.vcf.gz -ERC GVCF"

#now have g.vcf files for all individuals... need to genotype all and output as one vcf....

ls *sorted.g.vcf.gz | /home/bspanner/gatk-4.0.8.1/gatk --java-options "-Xmx4g" GenotypeGVCFs -R ${reference}.fasta -V {.}.g.vcf.gz -O genotypes.vcf.gz

#Use vcftools to filter based on read depth and genotype quality 

vcftools --vcf genotypes.vcf.gz --minGQ 10 --minDP 3 --recode --out ${project}
