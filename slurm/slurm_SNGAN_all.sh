#!/bin/bash

#SBATCH --partition=A40short
#SBATCH --time=04:00:00
#SBATCH --nodes=1
#SBATCH --gpus=1
#SBATCH --ntasks=2
#SBATCH -e out/%j.err
#SBATCH -o out/%j.out

module load Miniforge3/24.1.2-0 CUDA/11.3.1 cuDNN/8.2.1.32-CUDA-11.3.1
source ~/.bashrc
conda activate GANFingerprints

cd SNGAN
export PYTHONPATH=$PYTHONPATH:$(pwd)

# https://docs.cupy.dev/en/latest/install.html#cupy-always-raises-cupy-cuda-compiler-compileexception
export CUDA_PATH=/software/easybuild-INTEL_A40/software/CUDA/11.3.1
export LD_LIBRARY_PATH=$CUDA_PATH/lib64:$LD_LIBRARY_PATH

srun -n1 --gres="gpu:0" --overlap --kill-on-bad-exit=0 --wait=0 --output=../out/%j-%s.out --error=../out/%j-%s.err python evaluations/gen_images.py --config configs/sn_projection_celeba.yml --snapshot models/celeba_align_png_cropped.npz --results_dir gen/celeba --num_pngs 150000 --seed 42 &
srun -n1 --gres="gpu:0" --overlap --kill-on-bad-exit=0 --wait=0 --output=../out/%j-%s.out --error=../out/%j-%s.err python evaluations/gen_images.py --config configs/sn_projection_lsun_bedroom_200k.yml --snapshot models/lsun_bedroom_200k_png.npz --results_dir gen/lsun --num_pngs 150000 --seed 42 &
wait

echo "SBATCH completed"
