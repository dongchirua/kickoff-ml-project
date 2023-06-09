# Project Templete to Kickoff Machine Learning Project
Are you rushing or don't want to install libraries on your machine, click [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/dongchirua/kickoff-ml-project/main) to launch from [Binder](https://jupyter.org/binder)

This project includes below libraries
+ Python 3.11
+ Pytorch 2.0.1
+ Transfomer
+ Pytorch-Lightning
+ Wandb
+ Pandas
+ Numpy
+ Scikit-Learn
+ Jupyter Notebook
+ Panel
+ Pytest

## Install library dependencies
```console
conda env create -f binder/environment.yml
conda activate ml-venv
```
## Need to Update environment
```console
conda env update --file binder/environment.yml --prune
```
## Export environment
```console
conda env export --from-history -f binder/environment.yml
```
