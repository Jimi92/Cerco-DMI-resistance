import numpy as np
from numpy import genfromtxt
from collections import Counter

# enter number of individuals in pop
num_of_indv = 80 

vcf_mat = genfromtxt("/home/taliadoros/Desktop/phd_projects/Cb/Jscripts/SFStable.txt", delimiter= "\t")
site_spectrum = []
data = vcf_mat[1:, :]

outgroups = np.zeros(data.shape)
for i, _ in enumerate(outgroups):
	outgroups[i] = vcf_mat[0, : ]
comparison = outgroups == data
sum_of_trues = np.sum(comparison, axis=0)
sum_of_different = num_of_indv - sum_of_trues
site_freq_spectrum = Counter(sum_of_different)
#print(site_freq_spectrum)

New_SFS = dict(sorted(site_freq_spectrum.items(), key=lambda item: item[1]))
print(New_SFS)
