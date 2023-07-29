FROM ubuntu:22.04

ENV PATH="/root/miniconda3/bin:${PATH}"

RUN apt-get -qq update \
  && apt-get -qq install wget python3

ARG MINICONDA_VERSION=py311_23.5.2-0
ARG MINICONDA_SH=Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh
ARG MINICONDA_URL=https://repo.anaconda.com/miniconda/${MINICONDA_SH}

RUN wget ${MINICONDA_URL} \
  && mkdir /root/.conda \
  && bash ${MINICONDA_SH} -b \
  && rm -f ${MINICONDA_SH}

RUN conda init bash && conda --version

RUN conda config --set auto_update_conda False \
 && conda config --set show_channel_urls True \
 && conda config --add channels defaults \
 && conda config --set channel_priority strict \
 && conda config --add channels conda-forge \
 && conda config --add channels bioconda \
 && conda config --add channels r \
 && conda config --add channels anaconda

RUN conda create -n sci-r -y

RUN conda install -n sci-r -y -c conda-forge \
    python=3.11 \
    r-base=4.3.1 \
    r-essentials=4.3 \
    r-devtools=2.4.5 \
    r-ggpubr=0.6.0

RUN conda run -n sci-r R --quiet -e 'devtools::install_github("stephenturner/annotables")' \
 && conda run -n sci-r R --quiet -e 'devtools::install_github("alyssafrazee/RSkittleBrewer")'

#ENTRYPOINT ["conda", "run", "-n", "sci-r", "R", "--save"]
