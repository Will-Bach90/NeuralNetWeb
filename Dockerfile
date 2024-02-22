FROM python:3.10-slim as builder

# Set environment variables to reduce Python bytecode generation and unbuffered logging
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install build dependencies in a virtual environment to avoid polluting the final image
WORKDIR /code
COPY Pipfile Pipfile.lock /code/
RUN apt-get update && apt-get install -y --no-install-recommends gcc libpq-dev && \
    pip install --upgrade pip && \
    pip install pipenv && \
    pipenv install --system --deploy --ignore-pipfile

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