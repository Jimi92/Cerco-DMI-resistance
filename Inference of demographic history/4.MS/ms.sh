for i in $(seq 1 37)
do
/home/taliadoros/software/ms/msdir/ms 10 10000 -t 1604.48 -G -170.64 -r 0.12 1000000 -eN 0.02 39 > run_$i
done

# parameter explanation:
# -t The scaled mutation rate (θ=2Neμ) 
# -G Indicates an expotential contraction of the population. It is calculated as (-2Ne/gen)*log(current Ne/Ancestral Ne)
# -r The scaled recombination rate ρ=2Ner
# -eN set population change to 0 at time (generation/2Ne)