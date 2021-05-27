This is a guidline for the reproduction of 1) the analysis for the inference of the demographic history of the population and 2) the selective sweep analysis.
<<<>>>><<<<>>>><<<<>>>><<<>>><<<<>>><<<>>>><<<>>>><<<>>><<<>>><<<>>><<<>>><<<>>><<<>>><<<>>><<<>>><<<>>><<<>>>><<<<>>>><<<<>>>><<<>>><<<<>>><<<>>>><<<>>>><<<>>><<<>>>

Inference of the demographic history based on the single nucleotide polymorphism of intergenic regions

Prior to the scan of selective sweeps along the C. beticola genome, we computed the site frequency spectrum (SFS) to infer the demographic history of the population of isolates showing DMI fungicide resistance. Our analysis was based on the fit of four demographic models to the observed frequency spectrum of derived alleles (Unfolded or derived Allele Frequency Spectrum (DAFS)). We extracted the DAFS from the VCF file obtained from the population genomic dataset and filtered the dataset to include only SNPs with at least 1 kb distance to predicted coding sequences and 0.15 kb distance from each other to minimize the effects of selection and linkage disequilibrium. 

```{bash}
#! bash
#obtain intergenic regions (the file "InterPlus.bed" was obtained by the annotation (gff) file. I used the annotation file to extract the coordinates of all predicted CDS regions and I have added 500 bp to bothe ends of each CDS. subsequently I have excluded these 500+CDS+500 regions from the vcf. That resulted in a VCF file that contained the intergenic regions)
vcftools --vcf ${VCF} --bed InterPlus.bed --recode --recode-INFO-all --out Intergenic_regions
## variables
INPUT_DIR=/home/taliadoros/Desktop/phd_projects/Cb/selection_fungicide_resistance/fastsimcoal26/intergenic_thin/
VCF=Intergenic_regions.vcf
OUTPUT_DIR=/home/taliadoros/Desktop/phd_projects/Cb/selection_fungicide_resistance/fastsimcoal26/intergenic_thin/
#thin intergenic file
cd ${INPUT_DIR}
vcftools --vcf ${VCF} --thin 150 --recode --recode-INFO-all --out ${VCF%.vcf}_thin_0.15kb
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
#create a file with the 80 individuals used for demography
vcftools --vcf Intergenic_regions_thin_0.3kb.recode.vcf --keep list_indiv.txt --recode --recode-INFO-all --out Chosen_80_indiv
reference=/home/taliadoros/Desktop/phd_projects/Cb/selection_fungicide_resistance/NCBI_Reference.fasta
vcf_file=Chosen_80_indiv.recode.vcf
/home/taliadoros/software/gatk-4.1.8.1/gatk SelectVariants \
 -R ${reference} \
 -V ${vcf_file} \
 --exclude-non-variants \
 --remove-unused-alternates \
 -O Chosen_80_indiv_filtered.recode.vcf
```



We used the software ART (Huang, et al. 2012) for in silico sequencing of the latest Cercospora cf. flagellaris assembly available on NCBI under the project PRJNA503907. 

```{bash}
/artbinmountrainier2016.06.05linux64/art_bin_MountRainier/art_illumina -i GCA_005356885.1_ASM535688v1_genomic.fna -p -l 150 -f 20 -m 300 -s 10 -o C_flagellaris_
```

Subsequently, we mapped the reads produced by ART to the C. beticola reference genome. The SNP ancestral states were assumed to be those present in the C. cf. flagellaris outgroup. The site frequency spectrum (SFS) was computed based on a total of 47,865 biallelic SNPs. We have estimated the observed folded and unfolded SFS using the sofware Arlequin (Excoffier and Lischer 2010)


To infer the demographic history of the C. beticola population, we used FastSIMCOAL2 (Excoffier, et al. 2013). FastSIMCOAL2 performs coalescent simulations to approximate the likelihood of the data given a certain demographic model and specific parameter values. Maximization of the likelihood was achieved using several Expectation Maximization iterations. To this end we generated: 1) 100,000 simulations to approximate the likelihood with high precision, 2) 40 cycles of the expectation maximization algorithm to ensure that the maximum was reached and 3) several independent replicate estimations to ensure that the global maximum likelihood was found. 

```{bash}
./fsc26 -t ${scenario}.tpl -n 100000 -e ${scenario}.est -M -L 40 -q -d
```

We compared a set of models with different population size change scenarios. The four demographic scenarios that we compared were: 1) a recent population expansion, 2) a recent population bottleneck, 3) a bottleneck followed by a population expansion and 4) a population bottleneck followed by a second recent bottleneck. 

To define the search range of the current effective population size, we estimated the present-day effective population size of the C. beticola population based on Watterson’s θ and a neutral mutation rate of 1×10-8 mutation per site per generation. As the neutral mutation rate of Cercospora spp. is unknown we additionally performed 100,000 simulations using the for each of the four demographic scenarios with four different mutation rates (5×10-7, 5×10-8, 3×10-8 ,1×10-8 mutation per site per generation) in 25 replicated runs per specified mutation rate (25 runs x 10,000 simulations x 40 cycles of EM simulations for each scenario for each mutation rate). For our final simulations, we choose the neutral mutation rate that showed the lowest difference between the expected maximum log-likelihood and the observed log-likelihood.
The maximum log-likelihood values were compared with the Akaike Information Criterion (AIC). Here we present the AIC value for each combination of scenario and mutation rate. as the AIC value decreases the goodness of fit of the model increases.

```{bash}
Mut. rate\Scenario 	    Bottleneck	    Expansion	    Bot-Bot	    Bot-Exp
5 x 10-7	            3326.02	    722.40          332507.58	    839.01
5 x 10-8	            727.55	    6169.044	    24384.99	    670.97
3 x 10-8	            656.69	    8494.53         11719.96	    679.18
1 x 10-8	            656.42	    13841.13	    1836.10	    675.03
```



For each demographic model, we performed 100,000 simulations, 40 cycles of the expectation maximization and 50 replicate runs from different random starting values. We recorded the maximum likelihood parameter estimates that were obtained across replicate runs. Finally, we calculated the Akaike Information Criterion (AIC) and selected the model with the lowest AIC as the demographic model that best fitted the data. Parameter values were inferred in a second step by performing 100,000 simulations, 40 iterations of the expectation maximization and 100 replicate runs from different random starting values. 

```{bash}
for i in $(seq 1 100); do
./fsc26 -t ${scenario}.tpl -n 100000 -e ${scenario}.est -M -L 40 -q -d
done
```

For the specific distribution of the current and ancestral population size as well as for the distribution for time of the event, the mutation rate and recombination rate please find the tamplate and estimation files provided in the directory "Inference of the demographic history/2.scripts for FastSIMCOAL"

An example of the estimation file for the scenario of two bottlenecks: 

```{bash}
// Priors and rules file
// *********************

[PARAMETERS]
//#isInt? #name #dist. #min #max
//all N are in number of haploid individuals
1 CNE unif 79391 86878 output bounded
1 TBOT1 unif 500 15000 output
1 RESNEB1 unif 10 100 output bounded
1 TBOT2 unif 20 500 output
1 RESNEB2 unif 10 100 output bounded
[RULES]
[COMPLEX PARAMETERS]
1 ANCSIZE2 = CNE*RESNEB2 output
1 ANCSIZE1 = ANCSIZE2*RESNEB1 output
#Were: CNE is the current effective population size
#RESNEB1 is the resize factor of Ne after the first bottleneck
#TBOT1 is the time of the first bottleneck
#TBOT2 is the time of the second bottleneck
#RESNEB2 is the resize factor after the second bottleneck
#ANCSIZE2 is the ancestral population size before the second bottleneck
#ANCSIZE1 is the ancestral population size before the first bottleneck
```



An example of the template file for the scenario of two bottlenecks:

```{bash}
//Number of population samples (demes)
1
//Population effective sizes (number of genes)
CNE
//Sample sizes
80
//Growth rates: negative growth implies population expansion
0
//Number of migration matrices : 0 implies no migration between demes
0
//historical event: time, source, sink, migrants, new size, new growth rate, migr.matrix
2 historical event
TBOT1 0 0 0 RESNEB1 0 0
TBOT2 0 0 0 RESNEB2 0 0
//Number of independent loci [chromosome]
1 0
//Per chromosome: Number of linkage blocks
1
//per Block: data type, num loci, rec. rate and mut rate + optional parameters
FREQ 1 0.00000074 0.00000001 OUTEXP
#Were: CNE is the current effective population size
#TBOT1 is the time of the first bottleneck
#RESNEB1 is the resize factor of Ne after the first bottleneck
#TBOT2 is the time of the second bottleneck
#RESNEB2 is the resize factor after the second bottleneck
#ANCSIZE1 is the ancestral population size before the first bottleneck
#ANCSIZE2 is the ancestral population size before the second bottleneck
```

Genome scans for selective sweeps

Genomic scans for selective sweeps were performed by two independent approaches with the programs 1) OmegaPlus v. 3.0.3 (Alachiotis, et al. 2012) and 2) RAiSD v 2.9 (Alachiotis and Pavlidis 2018). OmegaPlus is a scalable implementation of the ω statistic (Nielsen, et al. 2005) that can be applied to whole-genome data. It utilizes information on the linkage disequilibrium (LD) between SNPs. The selective sweep analysis by OmegaPlus was performed for each chromosome separately. The grid size (the number of positions for which the ω statistic is calculated) was equal to the number of variants that each chromosome contained (28,698 - 77,617 points). The minimum and maximum window sizes were set to 1,000 bp and 100,000 bp respectively. 

```{bash}
/home/taliadoros/software/omegaplus-master/OmegaPlus -name Chr1_selection -input CM008499.1_analysis.recode.vcf -grid 76324 -minwin 1000 -maxwin 100000 -all -seed 417790
/home/taliadoros/software/omegaplus-master/OmegaPlus -name Chr2_selection -input CM008500.1_analysis.recode.vcf -grid 77617 -minwin 1000 -maxwin 100000 -all -seed 417790
/home/taliadoros/software/omegaplus-master/OmegaPlus -name Chr3_selection -input CM008501.1_analysis.recode.vcf -grid 74465 -minwin 1000 -maxwin 100000 -all -seed 417790
/home/taliadoros/software/omegaplus-master/OmegaPlus -name Chr4_selection -input CM008502.1_analysis.recode.vcf -grid 66779 -minwin 1000 -maxwin 100000 -all -seed 417790
/home/taliadoros/software/omegaplus-master/OmegaPlus -name Chr5_selection -input CM008503.1_analysis.recode.vcf -grid 62174 -minwin 1000 -maxwin 100000 -all -seed 417790
/home/taliadoros/software/omegaplus-master/OmegaPlus -name Chr6_selection -input CM008504.1_analysis.recode.vcf -grid 60399 -minwin 1000 -maxwin 100000 -all -seed 417790
/home/taliadoros/software/omegaplus-master/OmegaPlus -name Chr7_selection -input CM008505.1_analysis.recode.vcf -grid 69823 -minwin 1000 -maxwin 100000 -all -seed 417790
/home/taliadoros/software/omegaplus-master/OmegaPlus -name Chr8_selection -input CM008506.1_analysis.recode.vcf -grid 50344 -minwin 1000 -maxwin 100000 -all -seed 417790
/home/taliadoros/software/omegaplus-master/OmegaPlus -name Chr9_selection -input CM008507.1_analysis.recode.vcf -grid 37683 -minwin 1000 -maxwin 100000 -all -seed 417790
/home/taliadoros/software/omegaplus-master/OmegaPlus -name Chr10_selection -input CM008508.1_analysis.recode.vcf -grid 28698 -minwin 1000 -maxwin 100000 -all -seed 417790
```


RAiSD computes the μ statistic, a composite evaluation test that scores genomic regions by quantifying changes in the SFS, the levels of LD, and the amount of genetic diversity along the chromosome (Alachiotis and Pavlidis 2018). We used RAiSD to detect outlier loci using VCF files of individual chromosomes providing further the length of the chromosome, the number of variant positions and a default window size of 50 kb. Background selection can highly influence RaisD  (Alachiotis and Pavlidis 2018).
To assess the false positive rate due to backgroung selection, we have createe 1,000 full genome length simulations with background selection and without selective sweeps, under the best inferred demographic scenario using the software SFS_CODE (Hernandez 2008). The whole genome was simulated as 37 fragments of 1Mb. Furthermore, population fitness (γ) was given as the product of the effective population size (Ne) and the selection coefficient (S). The parameter γ (NeS) was let to take the following values: 50, 75, 100, 200, 1000. We have used the scaled mutation rate and recombination rate were based on the best fitting model as inferred with FastSIMCOAL2 (please see section “Inference of demographic history”).  Subsequently, 1,000 simulation under the best neutral demographic model was used to estimate the top 5% cut-off. The FPR due to background selection was determined as the number of positions that were identified that have undergone a selective sweep divided be the total number of grid points. 

SFS_CODE for simulation with background selection, without selective sweeps

```{bash}
#parameter explanation
# -n number of samples 
# -t the scaled parameter θ = 2Neμ
# -P ploidy
# -L number of similated loci and length
# -Td sudden change of effective population size at time generations/2Ne
# -TE scaled time of generations between the event and the present (generations/2Ne)
# -r scaled recombination rate
# -W distribution (in this case a fixed value) and strength of negative selection (Ne X S). In this case, all non-synonymous mutations are considered to be negatively selected.
for i in $(seq 1 1000)
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
```


RaisD script

```{bash}
cd /home/taliadoros/software/raisd-master
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(pwd)/gsl/lib
cd /home/taliadoros/Desktop/phd_projects/Cb/selection_fungicide_resistance/resistant_only/RaisD
/home/taliadoros/software/raisd-master/RAiSD -I CM008499.1_analysis.recode.vcf -n Cb_Chr1.out -f -B 6188355 76324 -R -y 1 -k 0.053
/home/taliadoros/software/raisd-master/RAiSD -I CM008500.1_analysis.recode.vcf -n Cb_Chr2.out -f -B 4222505 77617 -R -y 1 -k 0.053
/home/taliadoros/software/raisd-master/RAiSD -I CM008501.1_analysis.recode.vcf -n Cb_Chr3.out -f -B 4196595 74465 -R -y 1 -k 0.053
/home/taliadoros/software/raisd-master/RAiSD -I CM008502.1_analysis.recode.vcf -n Cb_Chr4.out -f -B 4173231 66779 -R -y 1 -k 0.053
/home/taliadoros/software/raisd-master/RAiSD -I CM008503.1_analysis.recode.vcf -n Cb_Chr5.out -f -B 4165208 62174 -R -y 1 -k 0.053
/home/taliadoros/software/raisd-master/RAiSD -I CM008504.1_analysis.recode.vcf -n Cb_Chr6.out -f -B 2985383 60399 -R -y 1 -k 0.053
/home/taliadoros/software/raisd-master/RAiSD -I CM008505.1_analysis.recode.vcf -n Cb_Chr7.out -f -B 2967425 69823 -R -y 1 -k 0.053
/home/taliadoros/software/raisd-master/RAiSD -I CM008506.1_analysis.recode.vcf -n Cb_Chr8.out -f -B 2636389 50344 -R -y 1 -k 0.053
/home/taliadoros/software/raisd-master/RAiSD -I CM008507.1_analysis.recode.vcf -n Cb_Chr9.out -f -B 2174017 37683 -R -y 1 -k 0.053
/home/taliadoros/software/raisd-master/RAiSD -I CM008508.1_analysis.recode.vcf -n Cb_Chr10.out -f -B 1557915 28698 -R -y 1 -k 0.053
```


To determine the significance of the identified selective sweeps we computed the ω and μ statistics on 10,000 datasets simulated under the best neutral demographic scenario using the program ms (Hudson 2002). Setting a signiﬁcance threshold for the deviation of the ω and μ statistics based on simulated data sets under the best neutral demographic model allowed us to control for the effect of demographic history of the population on the SFS, LD and genetic diversity along the genome (Nielsen, et al. 2005; Pavlidis, et al. 2013). All scripts developed for this section can be found at the supplementary material.

```{bash}
# parameter explanation:
# -t The scaled mutation rate (θ=2Neμ) 
# -G Indicates an exponential contraction of the population. It is calculated as (-2Ne/gen)*log(current Ne/Ancestral Ne)
# -r The scaled recombination rate ρ=2Ner
# -eN set population change to 0 at time (generation/2Ne)
for i in $(seq 1 37)
do
/home/taliadoros/software/ms/msdir/ms 10 10000 -t 1604.48 -G -170.64 -r 0.12 1000000 -eN 0.02 39 > run_$i
done
```
