FROM mambaorg/micromamba:jammy-cuda-12.1.0

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV ENV_NAME=diffusors SHELL=/bin/bash
ARG NEW_MAMBA_USER=$ENV_NAME
ARG NEW_MAMBA_USER_ID=5005
ARG NEW_MAMBA_USER_GID=5005
EXPOSE 8888

RUN micromamba install -y -n base -c conda-forge python=3.11 \
    && micromamba clean --all --yes

USER root
RUN apt update && apt install -y git tmux nvtop htop \
    && apt clean autoremove -y
RUN usermod "--login=${NEW_MAMBA_USER}" "--home=/home/${NEW_MAMBA_USER}" \
        --move-home "-u ${NEW_MAMBA_USER_ID}" "${MAMBA_USER}" && \
    groupmod "--new-name=${NEW_MAMBA_USER}" \
        "-g ${NEW_MAMBA_USER_GID}" "${MAMBA_USER}" && \
    # Update the expected value of MAMBA_USER for the
    # _entrypoint.sh consistency check.
    echo "${NEW_MAMBA_USER}" > "/etc/arg_mamba_user" && :
ENV MAMBA_USER=$NEW_MAMBA_USER

USER $MAMBA_USER
WORKDIR /workspace
# Install any needed packages specified in environment.yml
COPY environment.yml environment.yml
RUN micromamba create -n $ENV_NAME -f environment.yml -y \
    && micromamba clean --all --yes

CMD ["jupyter", "lab", "--ip=0.0.0.0", "--no-browser"]
