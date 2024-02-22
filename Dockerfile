FROM python:3.10-slim as builder

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /code

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install pipenv
RUN pip install --upgrade pip && \
    pip install pipenv

# Install Python dependencies
COPY Pipfile Pipfile.lock /code/
RUN pipenv install --system --deploy --ignore-pipfile

RUN pip install tensorflow

FROM python:3.10-slim

# Copy installed packages from builder
COPY --from=builder /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Copy the rest of the application code
WORKDIR /code
COPY . /code/

# Expose the port the app runs on
EXPOSE 8000

# Define the command to run the app
CMD ["sh", "-c", "cd neuralnetweb && gunicorn neuralnetweb.wsgi:application --bind 0.0.0.0:8000 --timeout 400"]