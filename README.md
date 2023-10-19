# Project Templete to Kickoff Machine Learning Project
> This template currently uses `Python 3.11`, and either `conda`, `docker`, `poetry`, or `micromamba`

Template project aims to promote *versioning library*, *environment isolation* practice and help all ML practitioners quickly start a project. Using this template, practitioners will have below libraries
+ Pytorch
+ Torch-geometric
+ Transfomer
+ Pytorch-Lightning
+ Wandb
+ Pandas
+ Numpy
+ Scikit-Learn
+ Jupyter Notebook
+ Panel
+ Pytest
+ DVC

Those libraries of course aren't enough, but it's easy to update other libraries that support your project. 

> Using `poetry` is highly recommended. If you are using `conda` or `micromamba`, make sure that you use package hashes to ensure package selection is reproducible via `conda-lock` or `micromamba`

## Install library dependencies
### With `poetry`
- `pip install poetry`
- Create, install, activate environment
```console
poetry install --with cpu # cpu
poetry install --with cu117 # cuda 11.7
poetry shell
```
- Need to update environment after `poetry add a_lib`
``` console
poetry lock
```
Note: in case you have a problem, run 
``` console
export PYTHON_KEYRING_BACKEND=keyring.backends.null.Keyring
```
- Need to add source, e.g `pyg-cu117` 
```console
poetry source add pyg-cu117 https://data.pyg.org/whl/torch-2.0.0+cu117.html
```
supposing add `pyg_lib`, `torch_scatter`, ... to a group (`cu117`) in this project via the source
```console
poetry add -G cu117 pyg_lib torch_scatter torch_sparse torch_cluster torch_spline_conv --source pyg-cu117
```
### With `conda`
- Install Conda instruction: [conda.io](https://docs.conda.io/en/latest/miniconda.html)
- Create, install, activate environment
```console
conda env create -f environment.yml
conda activate ml-venv
```
- Need to update environment
```console
conda env update --file binder/environment.yml --prune
```
- Export environment 
```console
conda env export --from-history -f binder/environment.yml
```

### With `docker`
- This tutorial is for those who have NVIDIA GPU (hereafter GPU). For CPU case, this should be similar but need to adjust `Dockerfile` and `run_docker.sh`
- Note: Docker will use `micromamba` instead of `miniconda`. Replace `conda` with `micromamba` in your usual commands
- You need to install `docker`
- Install Nvidia driver (ignore if you don't have GPU)
- Then install [Nvidia docker container toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/index.html), ignore if you aim to use CPU.
- Edit `.env` locates the same level with `run_docker.sh`, to add environment variables to the prospective docker container
- There is a file named `run_docker.sh`, allow to execute it by `chmod +x run_docker.sh` and run `run_docker.sh`
- Enjoy Jupyter lab at localhost:8888 as usual. Notebook token is shown after `run_docker.sh` runs successfully

## After installing libraries, verify
try this in `ipython`
```python
import torch
from torch_geometric.data import Data

edge_index = torch.tensor([[0, 1],
                           [1, 0],
                           [1, 2],
                           [2, 1]], dtype=torch.long)
x = torch.tensor([[-1], [0], [1]], dtype=torch.float)

data = Data(x=x, edge_index=edge_index.t().contiguous())
```

## Q&A
### My default Python is not 3.11, how I can instruct `poetry` to use Python 3.11
Use `poetry env use` to select Python version, more details are at more details https://stackoverflow.com/questions/60580113/change-python-version-to-3-x
### I don't want to use Python 3.11, how to change configs and make it reproducible 
If you aim to use `poetry`, the steps are following
- edit file `pyproject.toml`
- select a Python version, then `poetry shell`
- generate new `poetry.lock` by run `poetry lock`

If you aim to follow `conda`
- edit file `environment.yml`
- create a new environment that has the version you want
- switch to that environment

## Current limitation
- `torch_geometric` with CPU version in `poetry` has a problem. I created a discussion at https://github.com/pyg-team/pytorch_geometric/discussions/7788
