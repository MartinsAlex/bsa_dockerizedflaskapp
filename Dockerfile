
# Use the official lightweight Python image.
# https://hub.docker.com/_/python
FROM python:3.9-slim

# Allow statements and log messages to immediately appear in the Knative logs
ENV PYTHONUNBUFFERED True

# Copy local code to the container image.
ENV APP_HOME /app
WORKDIR $APP_HOME
COPY . ./

ENV OWMKEY = "c6bbb95008347076780b7ce4a89f2224"
ENV CONVKEY = "pdf_live_ixdnbmrAOSzIKWHWDCJ8XmIsAFvki9oPEhxHdfbht6b"
#ENV GOOGLE_APPLICATION_CREDENTIALS = unilbigscaleanalytics-b72696310700.json

# Install production dependencies.
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --upgrade google-cloud-bigquery[bqstorage,pandas]

# Run the web service on container startup. Here we use the gunicorn
# webserver, with one worker process and 8 threads.
# For environments with multiple CPU cores, increase the number of workers
# to be equal to the cores available.
# Timeout is set to 0 to disable the timeouts of the workers to allow Cloud Run to handle instance scaling.
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 main:app
