FROM python:3.9.5-slim-buster

# Setup app user
WORKDIR /app/
RUN addgroup --gid 27100 --system app
RUN adduser --shell /bin/false --uid 27100 --ingroup app --system app

# Install dependencies
COPY /requirements.txt /app/
RUN python -m pip install --upgrade pip
RUN pip3 install --upgrade -r /app/requirements.txt

# Add libraries
COPY /queries.json /
COPY /neo4j_connector.py /elastic_connector.py /elastic_ingestor.py /app/
RUN chmod +x /app/neo4j_connector.py /app/elastic_connector.py /app/elastic_ingestor.py

# Entrypoint
RUN chown -R app:app /app/
USER app
CMD ["python3", "/elastic_ingestor.py"]
