#
# Dockerfile for Avocado Price Predictors
# Authors: Katie Birchard, Ryan Homer, Andrea Lee
#
# University of British Columbia, Master of Data Science Program
# Created: 2020-02-05
#
FROM rocker/tidyverse:3.6.2

RUN apt-get update

# install the anaconda distribution of python
RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-2019.10-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy && \
    /opt/conda/bin/conda update -n base -c defaults conda

# Install python packages
RUN /opt/conda/bin/conda install -y -c anaconda altair docopt numpy pandas pyarrow scikit-learn selenium

# Install chromedriver
RUN apt-get install -y chromium libnss3 && apt-get install unzip
RUN wget -q "https://chromedriver.storage.googleapis.com/79.0.3945.36/chromedriver_linux64.zip" -O /tmp/chromedriver.zip \
    && unzip /tmp/chromedriver.zip -d /usr/bin/ \
    && rm /tmp/chromedriver.zip && chown root:root /usr/bin/chromedriver && chmod +x /usr/bin/chromedriver

# Install R Packages
RUN Rscript -e "install.packages(c('broom', \
                                   'car', \
                                   'caret', \
                                   'docopt', \
                                   'feather', \
                                   'ggpubr', \
                                   'here', \
                                   'kableExtra', \
                                   'knitr', \
                                   'lubridate', \
                                   'magick', \
                                   'RCurl', \
                                   'reshape2'))"

# put anaconda python in path
ENV PATH="/opt/conda/bin:${PATH}"

# Start Docker container in bash shell (interactive mode)
CMD ["/bin/bash"]
