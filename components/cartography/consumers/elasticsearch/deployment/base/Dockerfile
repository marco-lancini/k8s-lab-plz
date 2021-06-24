FROM python:3.9.5-slim-buster

RUN pip3 install neo4j

COPY /queries.json /neo4j_connector.py /elastic_ingestor.py /

CMD ["python", "/elastic_ingestor.py"]
