FROM python:3.9-slim as base

ARG WORKDIR=/opt/mama.ai
ARG UID=2112
ARG COMPILE_TO_PYC

ENV VENV="$WORKDIR/.venv" \
    # stacktrace into logs on failure
    PYTHONFAULTHANDLER=1 \
    # no buffered output to stdout
    PYTHONUNBUFFERED=1
	
WORKDIR ${WORKDIR}
USER root

# prepare a base layer
RUN true \
    # remove clutter from the python image
    && rm -rf /tmp/* \
    # a few basic debugging utils
    && apt-get update \
    && apt-get install -y --no-install-recommends --fix-missing procps make libsndfile1 mc pip sudo wget tar xz-utils gcc g++ git \
	&& apt install -y jupyter-notebook \
    && rm -rf /var/lib/apt/lists/*

# create the mama user and WORKDIR
RUN true \
    && groupadd -g "$UID" mama \
    && useradd -rm -s /bin/bash -g mama -G sudo -u "$UID" mama \
    && mkdir -p "$WORKDIR" \
    && mkdir -p "$VENV/bin" \
    && chown -R mama "$WORKDIR" \
    && true
	
####################################
FROM base as build
ENV PIP_DEFAULT_TIMEOUT=100 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    POETRY_VERSION=1.3.1

# install poetry "system-wide"
RUN pip install "poetry==$POETRY_VERSION"

# python cache files go here not to be copied
ENV PYTHONPYCACHEPREFIX=/tmp/__pycache__

# create virtualenv, remove cache files
RUN python -m venv --upgrade-deps "$VENV"

# install requirements into $VENV
COPY pyproject.toml poetry.lock ./
RUN poetry install


ENV PATH="$VENV/bin:$PATH"

####################################
FROM base as final

USER mama 


COPY --from=build --chown=mama "$VENV" "$VENV"
COPY --chown=mama notebook notebook

EXPOSE 8888

ENV PATH="$VENV/bin:$PATH"