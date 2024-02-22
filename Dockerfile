FROM python:3.10-slim as builder

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /code

# Install TensorFlow first to catch any missing dependencies
RUN pip install --upgrade pip && \
    pip install tensorflow

# Then proceed with the rest of your dependencies
COPY Pipfile Pipfile.lock /code/
RUN pip install pipenv && \
    pipenv install --system --deploy --ignore-pipfile

WORKDIR /code
COPY . /code/

EXPOSE 8000

# Define the command to run the app
CMD ["sh", "-c", "cd neuralnetweb && gunicorn neuralnetweb.wsgi:application --bind 0.0.0.0:8000 --timeout 400"]