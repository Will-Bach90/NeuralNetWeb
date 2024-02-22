FROM python:3.10-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set the working directory in the container
WORKDIR /code

COPY Pipfile Pipfile.lock /code/
RUN apt-get update && apt-get install -y --no-install-recommends gcc libpq-dev pkg-config default-libmysqlclient-dev \
    && pip install --upgrade pip \
    && pip install pipenv gunicorn tensorflow \
    && pipenv install --system --deploy --ignore-pipfile \
    && apt-get remove -y gcc pkg-config default-libmysqlclient-dev \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY . /code/
EXPOSE 8000
CMD ["sh", "-c", "cd neuralnetweb && gunicorn neuralnetweb.wsgi:application --bind 0.0.0.0:8000 --timeout 400"]


