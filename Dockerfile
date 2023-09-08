FROM ubuntu:20.04

ARG DEFAUL_TZ=America/Los_Angeles
ENV DEFAULT_TZ=$DEFAULT_TZ

RUN apt-get update \
   && DEBIAN_FRONTEND=noninteractive $DEFAULT_TZ apt-get install -y \
   tzdata \
   vim \
   sudo \
   curl \ 
   python3 \
   pip \
   && python3 -m pip install \
         jupyterlab \
         ipykernel \
         matplotlib \
         ipywidgets         

RUN curl -fsSL https://repo.anaconda.com/miniconda/Miniconda3-py38_23.5.2-0-Linux-x86_64.sh > /tmp/miniconda.sh \
       && chmod +x /tmp/miniconda.sh \
       && /tmp/miniconda.sh -b -p /opt/conda

ARG AUTH_KEY=DEFAULT_KEY
ENV AUTH_KEY=$AUTH_KEY

RUN curl https://get.modular.com | MODULAR_AUTH=$AUTH_KEY sh - \
    && modular install mojo

ARG MODULAR_HOME="/root/.modular"
ENV MODULAR_HOME=$MODULAR_HOME
ENV PATH="$PATH:/opt/conda/bin:$MODULAR_HOME/pkg/packages.modular.com_mojo/bin"

RUN conda init 
RUN jupyter labextension disable "@jupyterlab/apputils-extension:announcements"
CMD ["jupyter", "lab", "--ip='*'", "--NotebookApp.token=''", "--NotebookApp.password=''","--allow-root"]
