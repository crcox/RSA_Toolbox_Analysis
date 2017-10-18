#!/bin/bash
# ********************************************************************
# This script is intended for use with qsubx, which sets many relevant
# environment variables
# ********************************************************************

# -- SGE optoins (whose lines must begin with #$)

#$ -S /bin/bash # The jobscript is written for the bash shell
#$ -V # Inherit environment settings (e.g., from loaded modulefiles)
#$ -o ./logfiles
#$ -e ./logfiles
#$ -cwd # Run the job in the current directory

# -- the commands to be executed (programs to be run) on a compute node:

module load apps/binapps/matlab/R2015aSP1
export MATLABDIR="$(dirname $(dirname $(which matlab)))"

echo "Number of jobs: $NJOBS"
NDIGITS=${#NJOBS}
# Subdirectories will all have this common root (saves me some typing)

# Path to my executable
EXE=$EXP_BASE/shared/run_MovingWindow_MVPA_ECOG.sh
EXE_AP=$EXP_BASE/shared/run_MovingWindow_AccuracyProfile_MVPA_ECOG.sh

# Path to the root of the data directory tree
DATAROOT="${HOME}/scratch/data/ECOG/KyotoNaming/avg"

# Here comes some fancy bash: apparently when you combine two or more brace
# expansions, you get the cartesian product of the two. That is:
#    {A,B}{1,2}
# Will produce:
#    A1
#    A2
#    B1
#    B2
#
# N.B. The right-most brace will be the inner-most loop during the combined
# expansion (A1, A2, then B1, B2).
#
# If you add a space between the two brace expressions, a space will be be
# included between the outputs. Therefore:
#    {A,B}" "{1,2}
# Will produce:
#    A 1
#    A 2
#    B 1
#    B 2
#
# This is convenient, because the space is used to separate array elements.
#
# In the following, the outer parenthesis are critical. It makes sure the
# evalation happens before assignment, and it encodes the expanded output as an
# array. Each element in the array is a pair of values. To continue the example
# from above:
#
#    x=({A,B}" "{1,2})
# Will permit the following commands and results (which are a bit indented):
#    echo ${x[0]}
#      A 1
#    echo ${x[3]}
#      B 2
#    y=(${x[1]})
#    echo ${y[0]}
#      A
#    echo ${y[1]}
#      2
CONDITIONS=({audio,visual}" "{1..100})

echo "Number of jobs: $NJOBS"

# Remember that $SGE_TASK_ID will be 1, 2, 3, ... 200.
# BASH array indexing starts from zero so decrment.
TID=$[SGE_TASK_ID-1]

# Index in to the arrays of directory names to create a path
COND=(${CONDITIONS[$TID]})
MODALITY=${COND[0]}
RANDOMSEED=${COND[1]}

# Echo some info to the job output file
echo "Running SGE_TASK_ID $SGE_TASK_ID, Modality ${MODALITY} and RandomSeed ${RANDOMSEED}"

# Finally run my executable from the correct directory
$EXE "$MATLABDIR" "$MODALITY" "random_seeds" $RANDOMSEED "output_root" $EXP_BASE
