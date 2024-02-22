FROM python:3.10-slim as builder

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /code

COPY Pipfile Pipfile.lock /code/
RUN pip3 install pipenv && pipenv install --system && pip install tensorflow

FROM python:3.10-slim

# Copy installed packages from builder
COPY --from=builder /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

WORKDIR /code
COPY . /code/

EXPOSE 8000

# Define the command to run the app
CMD ["sh", "-c", "cd neuralnetweb && gunicorn neuralnetweb.wsgi:application --bind 0.0.0.0:8000 --timeout 400"]