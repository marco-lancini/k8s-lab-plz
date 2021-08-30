FROM python:3.9.5-slim-buster

# Setup app user
WORKDIR /src
RUN addgroup --gid 27100 --system app
RUN adduser --shell /bin/false --uid 27100 --ingroup app --system app
RUN chown -R app:app /src

# Install dependencies
COPY /requirements.txt /src
RUN python -m pip install --upgrade pip
RUN pip3 install --upgrade -r /src/requirements.txt

# Add libraries
COPY /queries.json /neo4j_connector.py /elastic_connector.py /elastic_ingestor.py /

# Entrypoint
USER app
CMD ["python", "/elastic_ingestor.py"]
