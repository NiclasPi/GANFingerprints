#!/bin/bash

#SBATCH --partition=A40devel
#SBATCH --time=00:02:00
#SBATCH --nodes=1
#SBATCH --gpus=1
#SBATCH --ntasks=2
#SBATCH -e out/%j.err
#SBATCH -o out/%j.out

module load Miniforge3/24.1.2-0 CUDA/11.3.1 cuDNN/8.2.1.32-CUDA-11.3.1
source ~/.bashrc
conda activate GANFingerprints

srun -n1 --gres="gpu:0" --overlap python test.py &
srun -n1 --gres="gpu:0" --overlap python test.py &
wait
