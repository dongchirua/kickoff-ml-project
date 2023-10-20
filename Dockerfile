FROM mambaorg/micromamba:1.5.1 as micromamba
FROM nvcr.io/nvidia/pytorch:23.09-py3

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

SHELL ["/usr/local/bin/_dockerfile_shell.sh"]
ENTRYPOINT ["/usr/local/bin/_entrypoint.sh"]

RUN micromamba install -y -n base -c conda-forge python=3.11 \
    && micromamba clean --all --yes

WORKDIR /tmp
# Install any needed packages specified in environment.yml
COPY environment.yml environment.yml
RUN micromamba create -n $ENV_NAME -f environment.yml -y \
    && micromamba clean --all --yes

WORKDIR /workspace
ENV SHELL=/bin/bash

CMD ["jupyter", "lab", "--ip=0.0.0.0", "--no-browser"]
