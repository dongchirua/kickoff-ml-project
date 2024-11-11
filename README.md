# Project Templete to Kickoff Machine Learning Project
> This template currently uses `Python 3.11`, `Python 3.12`, and either `conda`, `poetry`, or `conda` or `micromamba`

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

> Using `poetry` is highly recommended. If you are using `conda` or `micromamba`, make sure that you use package hashes to ensure package selection is reproducible via `conda-lock`.

## Isolate Environment with Docker
- This tutorial is for those who have NVIDIA GPU (hereafter GPU), and you must have `docker`
- Install Nvidia driver
- Then install [Nvidia docker container toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/index.html).

### Up and run (fast but not recommended)
- `docker run -v "$PWD:/workspace" --gpus all  --rm -it pytorch/pytorch:2.4.1-cuda12.4-cudnn9-runtime bash`
- `poetry install`
- `poetry shell`

### Using Conda-based environment
- Note: Docker will use `micromamba` instead of `miniconda`. Replace `conda` with `micromamba` in your usual commands
- Edit `.env` locates the same level with `run_docker.sh`, to add environment variables to the prospective docker container
- There is a file named `run_docker.sh`, allow to execute it by `chmod +x run_docker.sh` and run `run_docker.sh`
- Enjoy Jupyter lab at localhost:8888 as usual. Notebook token is shown after `run_docker.sh` runs successfully

## Isolate Environment without Docker
### With `poetry`
- `pip install poetry`
- Create, install, activate environment
```console
poetry install
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

## After installing libraries, verify

try this in `ipython`
```python
import torch
from torch_geometric.data import Data
from transformers import pipeline

print(torch.cuda.is_available())

edge_index = torch.tensor([[0, 1],
                           [1, 0],
                           [1, 2],
                           [2, 1]], dtype=torch.long)
x = torch.tensor([[-1], [0], [1]], dtype=torch.float)

data = Data(x=x, edge_index=edge_index.t().contiguous())
print(data)

classifier = pipeline("sentiment-analysis")
result = classifier("We are very happy to show you the 🤗 Transformers library.")
print(result)
```