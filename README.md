# Project Templete to Kickoff Machine Learning Project

This project includes below libraries
+ Python >3.10, <3.13
+ Pytorch
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

## Install library dependencies
### With `poetry`
- Create, install, activate environment
```console
poetry install --with cpu # cpu
poetry install --with cu117 # cuda 11.7
poetry shell
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
- Create, install, activate environment
```console
conda env create -f environment.yml
conda activate ml-venv
```
- Need to Update environment
```console
conda env update --file binder/environment.yml --prune
```
- Export environment 
```console
conda env export --from-history -f binder/environment.yml
```
