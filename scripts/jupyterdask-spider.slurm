#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=06:00:00
#SBATCH --partition=normal
#SBATCH --output=JobOut/%x-%j.out
#SBATCH --reservation=lidarac

APPTAINER_IMAGE="oras://ghcr.io/shiyifang/ahn4_on_spider:latest"

# Bind all paths from host system within the container
_DIRS=`/usr/bin/ls -1 / | /usr/bin/awk '!/dev/' | /usr/bin/sed 's/^/\//g' `
export APPTAINER_BIND=`echo ${_DIRS} | /usr/bin/sed 's/ /,/g' `

# Use Python interpreter from the container image
PYTHON="apptainer run ${APPTAINER_IMAGE} python"

# Print message with instructions to set up port forwarding
PORT=` shuf -i 8400-9400 -n 1 `
echo "Run the following on your local machine: "
echo "ssh -i /path/to/private/ssh/key -N -L 8889:` hostname -s `:${PORT} ${USER}@spider.surf.nl"

# Configure default Dask cluster settings
export DASK_DISTRIBUTED__DASHBOARD__LINK="/proxy/{port}/status"
export DASK_LABEXTENSION__FACTORY__MODULE="dask_jobqueue"
export DASK_LABEXTENSION__FACTORY__CLASS="SLURMCluster"
export DASK_JOBQUEUE__SLURM__DEATH_TIMEOUT=60
export DASK_JOBQUEUE__SLURM__PYTHON=${PYTHON}
export DASK_JOBQUEUE__SLURM__JOB_EXTRA_DIRECTIVES="['--output', 'JobOut/%x-%j.out', '--reservation', 'lidarac']"
export DASK_JOBQUEUE__SLURM__PROCESSES=4
export DASK_JOBQUEUE__SLURM__CORES=4
export DASK_JOBQUEUE__SLURM__MEMORY="48GiB"
export DASK_JOBQUEUE__SLURM__WALLTIME="06:00:00"
export DASK_JOBQUEUE__SLURM__QUEUE="normal"
export DASK_JOBQUEUE__SLURM__LOCAL_DIRECTORY="\$TMPDIR"

# Start the Jupyter server
${PYTHON} \
  -m jupyterlab \
  --no-browser \
  --port=${PORT} \
  --ip=0.0.0.0
