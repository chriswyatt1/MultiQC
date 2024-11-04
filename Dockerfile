FROM python:3.12-slim

LABEL author="Phil Ewels & Vlad Savelyev" \
      description="MultiQC" \
      maintainer="phil.ewels@seqera.io"

RUN mkdir /usr/src/multiqc

# Add the MultiQC source files to the container
COPY LICENSE README.md pyproject.toml MANIFEST.in setup.py /usr/src/multiqc/
COPY docs /usr/src/multiqc/docs
COPY multiqc /usr/src/multiqc/multiqc
COPY scripts /usr/src/multiqc/scripts
COPY tests /usr/src/multiqc/tests

# - Install `ps` for Nextflow
# - Install MultiQC through pip
# - Delete unnecessary Python files
# - Remove MultiQC source directory
# - Add custom group and user
RUN \
    echo "Docker build log: Run apt-get update" 1>&2 && \
    apt-get update -qq && \
    echo "Docker build log: Install procps" 1>&2 && \
    apt-get install -y --no-install-recommends procps && \
    echo "Docker build log: Clean apt cache" 1>&2 && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    echo "Docker build log: Upgrade pip and install multiqc" 1>&2 && \
    # Upgrade pip, setuptools, and wheel
    pip install --upgrade pip setuptools wheel && \
    # Install MultiQC in editable mode
    pip install --no-cache-dir -e /usr/src/multiqc && \
    echo "Docker build log: Delete python cache directories" 1>&2 && \
    # Add custom group and user
    find /usr/local/lib/python3.12 \( -iname '*.c' -o -iname '*.pxd' -o -iname '*.pyd' -o -iname '__pycache__' \) -printf "\"%p\" " | \
    xargs rm -rf {} && \
    echo "Docker build log: Add multiqc user and group" 1>&2 && \
    groupadd --gid 1000 multiqc && \
    useradd -ms /bin/bash --create-home --gid multiqc --uid 1000 multiqc

# Set user and working directory
USER multiqc
WORKDIR /home/multiqc

# Check if MultiQC is installed correctly
RUN echo "Docker build log: Testing multiqc" 1>&2 && \
    multiqc --help 

# Set default command
CMD multiqc --help