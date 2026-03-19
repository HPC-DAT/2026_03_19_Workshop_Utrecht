# High performance computing with Python and RS-DAT
Workshop at SURF Utrecht on 19th March 2026

## Introduction

This repository hosts the material the workshop entitled "High Performance Computing With Python and RS-DAT" taught at the SURF Utrecht on 19-03-2026 in the context of the HPC-DAT project funded by NWO through TDCC-NES. 

This workshop will acquaint participants with the use of the RS-DAT framework to deploy [Jupyter](https://docs.jupyter.org/en/latest/) on an HPC system, as well as with the fundamentals of the use of the [Dask](https://docs.dask.org/en/stable/index.html) and Xarray libraries in the Python ecosystem. 

The workshop will:

* Introduce the RS-DAT framework used to start Jupyter on a HPC system, with specific attention to SURF's systems
* Introduce how to connect to the dCache mass storage system at SURF
* Run through a short introduction to Dask and Xarray
* Present, motivate and discuss best practices in the use of Dask and Xarray on HPC
* Present a number of use-cases: participants will be able to choose from and study in detail a number of real-world scaled-up scientific use-cases

The workshop will make use of the [Spider](https://doc.spider.surfsara.nl/en/latest/Pages/about.html) cluster, a high-throuput data processing platform hosted by [SURF](https://www.surf.nl/).

## Repository structure

* [`environment.yml`](./environment.yml) is the environment file that define all the project dependencies.
* [`.github/`](./github) contains the scripts that take care of building and publishing a container image with the required dependencies.
* [`scripts/`](./scripts/) contains the batch job script to start a Jupyter session on Spider.
* [`notebooks/`](./notebooks/) contains the Jupyter notebooks which we will run in the training.

## Setup

In order to follow along with the instructor, you will need a laptop with the following software installed:

* OpenSSH client: should already be installed on macOS/Linux, it can be installed from Windows Apps on Windows 10+. Installation instructions can also be found [here](https://www.sshhandbook.com/installing-ssh/). Verify it works by typing the following command in a terminal window (it should return the OpenSSH version):
  ```shell
  ssh -V
  ```

* Python: Any recent Python version (3.10+) should work. It can be installed from [python.org](https://www.python.org/downloads/). Verify it works by typing the following command in a terminal window (it should return the Python version):
  ```shell
  python --version
  ```

Once this software is installed, follow the following setup steps:

1. Create a Python virtual environment. You can use any environment manager you are comfortable with (`venv`, `virtualenv`, `conda`, ...). Using `venv`, you can create the "myenv" environment with the following commands:
   ```shell
   python -m venv myenv
   source myenv/bin/activate
   ```

2. Install the Python tool hosted in [this repository](https://github.com/RS-DAT/JupyterDaskOnSLURM/tree/main/tools/jupyterdask):
   ```shell
   pip install "git+https://github.com/RS-DAT/JupyterDaskOnSLURM.git#egg=jupyterdask&subdirectory=tools/jupyterdask"
   jupyterdask --version  # check the command line tool is correctly installed
   ```

3. Download the following batch job script and save it to a known path (e.g. on your Desktop): [jupyterdask-spider.slurm](https://github.com/HPC-DAT/2026_03_19_Workshop_Utrecht/blob/f8cc1ae3cc8c3ff733794d0ed2efd71317fc17cc/scripts/jupyterdask-spider.slurm)

4. Pick a Spider user account from [this document](https://nlesc-my.sharepoint.com/:w:/g/personal/m_grootes_esciencecenter_nl/EShepbH_bv1FskW2SIM_EBwBawh1ydjRsluF0zlkGWAnPQ?e=1WjykL) (the password to access the document will be given at the workshop). Add your name to the "Name" column, then download the private SSH key required to authenticate and save it to a known path (e.g. on your Desktop).

## Run

Start the Jupyter session on Spider with the following command:

```shell
jupyterdask -i /path/to/ssh/key --template /path/to/jupyterdask-spider.slurm --run <YOUR_USERNAME>@spider.surf.nl
```
