FROM python:3.9.0-buster
SHELL ["/bin/bash", "-o", "pipefail", "-o", "errexit", "-o", "nounset", "-o", "xtrace", "-c"]

ENV PATH=/opt/venv/bin:/opt/poetry/bin:${PATH} \
    VIRTUAL_ENV=/opt/venv \
    FLASK_APP=app.py

RUN python -m venv /opt/poetry ; \
    /opt/poetry/bin/pip install --progress-bar off --upgrade pip setuptools wheel ; \
    /opt/poetry/bin/pip install --progress-bar off poetry==1.1.4 ; \
    python -m venv /opt/venv ; \
    /opt/venv/bin/pip install --progress-bar off --upgrade pip setuptools wheel ; \
    rm -rf ~/.cache/pip

WORKDIR /code

COPY pyproject.toml poetry.lock /code/

RUN poetry install --no-dev --no-interaction ; \
    rm -rf ~/.cache/pypoetry ~/.cache/pip

COPY . /code

CMD ["flask", "run", "--host", "0.0.0.0", "--port", "8000"]
