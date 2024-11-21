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

cd ProGAN
export PYTHONPATH=$PYTHONPATH:$(pwd)

srun -n1 --gres="gpu:0" --overlap --kill-on-bad-exit=0 --wait=0 --output=../out/%j-%s.out --error=../out/%j-%s.err python run.py --app gen --model_path models/celeba_align_png_cropped.pkl --out_image_dir gen/celeba --num_pngs 150000 --gen_seed 42 &
srun -n1 --gres="gpu:0" --overlap --kill-on-bad-exit=0 --wait=0 --output=../out/%j-%s.out --error=../out/%j-%s.err python run.py --app gen --model_path models/lsun_bedroom_200k_png.pkl --out_image_dir gen/lsun --num_pngs 150000 --gen_seed 42 &
wait

echo "SBATCH completed"
