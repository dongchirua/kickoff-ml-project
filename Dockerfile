FROM mambaorg/micromamba:2.0 as micromamba
FROM nvcr.io/nvidia/pytorch:24.10-py3

ARG SSH_KEY

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV ENV_NAME=ml-venv
ENV MAMBA_USER=$ENV_NAME
ARG MAMBA_USER_ID=5005
ARG MAMBA_USER_GID=5005
ENV MAMBA_ROOT_PREFIX="/opt/conda"
ENV MAMBA_EXE="/bin/micromamba"
EXPOSE 8888

USER root

COPY --from=micromamba "$MAMBA_EXE" "$MAMBA_EXE"
COPY --from=micromamba /usr/local/bin/_activate_current_env.sh /usr/local/bin/_activate_current_env.sh
COPY --from=micromamba /usr/local/bin/_dockerfile_shell.sh /usr/local/bin/_dockerfile_shell.sh
COPY --from=micromamba /usr/local/bin/_entrypoint.sh /usr/local/bin/_entrypoint.sh
COPY --from=micromamba /usr/local/bin/_dockerfile_initialize_user_accounts.sh /usr/local/bin/_dockerfile_initialize_user_accounts.sh
COPY --from=micromamba /usr/local/bin/_dockerfile_setup_root_prefix.sh /usr/local/bin/_dockerfile_setup_root_prefix.sh

RUN /usr/local/bin/_dockerfile_initialize_user_accounts.sh && \
    /usr/local/bin/_dockerfile_setup_root_prefix.sh

RUN apt update && apt install -y git tmux nvtop htop \
    && apt clean autoremove -y

USER $MAMBA_USER

RUN mkdir -p ~/.ssh && \
    chmod 0700 ~/.ssh && \
    ssh-keyscan github.com > ~/.ssh/known_hosts && \
    echo "${SSH_KEY}" > ~/.ssh/id_rsa && \
    chmod 600 ~/.ssh/id_rsa

SHELL ["/usr/local/bin/_dockerfile_shell.sh"]
ENTRYPOINT ["/usr/local/bin/_entrypoint.sh"]

RUN micromamba install -y -n base -c conda-forge python=3.12 \
    && micromamba clean --all --yes

WORKDIR /tmp

# Install any needed packages specified in environment.yml
COPY environment.yml environment.yml
RUN micromamba create -n $ENV_NAME -f environment.yml -y \
    && micromamba clean --all --yes

WORKDIR /workspace
ENV SHELL=/bin/bash

CMD ["jupyter", "lab", "--ip=0.0.0.0", "--no-browser"]
