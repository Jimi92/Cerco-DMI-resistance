#!/bin/bash
#
# submit by  sbatch FastBot.sh
#
#  specify the job name
#SBATCH --job-name=FastBot1
#  how many cpus are requested
#SBATCH --ntasks=4
#  run on one node, importand if you have more than 1 ntasks
#SBATCH --nodes=1
#  maximum walltime, here 10min
#SBATCH --time=312:00:00
#  maximum requested memory
#SBATCH --mem=100G
#  write std out and std error to these files
#SBATCH --error=fast.%J.err
#SBATCH --output=fast.%J.out
#  send a mail for job start, end, fail, etc.
#  which partition?
#  there are global,testing,highmem,standard,fast
#SBATCH --partition=global



/home/taliadoros/Desktop/phd_projects/Cb/selection_fungicide_resistance/fastsimcoal26/short_DNA_regs/chosen/sfs/model_choice/fsc26 -t Bot_Bot.tpl -n 100000 -e Bot_Bot.est -M -L 40 -q -d
