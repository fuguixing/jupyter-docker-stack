# Copyright (c) Fugui Xing.
# Distributed under the terms of the MIT License.

FROM jupyter/all-spark-notebook:033056e6d164

# Create .jupyter and .ipython directory
RUN mkdir -p /home/jovyan/.jupyter && \
    mkdir -p /home/jovyan/.ipython/profile_default

USER root

# R pre-requisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    fonts-dejavu \
    tzdata \
    gfortran \
    gcc && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# R packages
RUN conda install --quiet --yes \
    'r-base=3.3.2' \
    'r-irkernel=0.7*' \
    'r-plyr=1.8*' \
    'r-devtools=1.12*' \
    'r-tidyverse=1.0*' \
    'r-shiny=0.14*' \
    'r-rmarkdown=1.2*' \
    'r-forecast=7.3*' \
    'r-rsqlite=1.1*' \
    'r-reshape2=1.4*' \
    'r-nycflights13=0.2*' \
    'r-caret=6.0*' \
    'r-rcurl=1.95*' \
    'r-crayon=1.3*' \
    'r-randomforest=4.6*' && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR

# Base Python 3 library
RUN /bin/bash -c "conda create -y -n conda_python3 python=3.6.3 anaconda && \
    source activate conda_python3 && \
    python -m pip install ipykernel==4.8.1 && \
    python -m ipykernel install --name 'conda_python3.6.3'  && \
    source deactivate conda_python3"

# Base Python 2 library
RUN /bin/bash -c "conda create -y -n conda_python2 python=2.7.14 anaconda && \
    source activate conda_python2 && \
    python -m pip install ipykernel==4.8.1 && \
    python -m ipykernel install --name 'conda_python2.7.14'  && \
    source deactivate conda_python2"

# Tensorflow packages for Python 3
RUN /bin/bash -c "conda create -y -n conda_tensorflow_cpu_python3 python=3.6.3 anaconda && \
    source activate conda_tensorflow_cpu_python3 && \
    python -m pip install ipykernel==4.8.1 && \
    python -m ipykernel install --name 'conda_tensorflow_cpu_python3'  && \
    pip install --upgrade  https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.4.0-cp36-cp36m-linux_x86_64.whl && \
    source deactivate conda_tensorflow_cpu_python3"

# Tensorflow packages for Python 2
RUN /bin/bash -c "conda create -y -n conda_tensorflow_cpu_python2 python=2.7.14 anaconda && \
    source activate conda_tensorflow_cpu_python2 && \
    python -m pip install ipykernel==4.8.1 && \
    python -m ipykernel install --name 'conda_tensorflow_cpu_python2'  && \
    pip install --upgrade  https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.4.0-cp27-none-linux_x86_64.whl && \
    source deactivate conda_tensorflow_cpu_python2"

USER $NB_USER

# The command will start server and disable the token
CMD /usr/local/bin/start-notebook.sh --NotebookApp.token=''