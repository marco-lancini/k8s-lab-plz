import sys
import os
import time
import datetime
import logging

from elastic_connector import ElasticsearchConsumer
from neo4j_connector import Neo4jConnector

logging.basicConfig()
logger = logging.getLogger("elastic_ingestor")
logger.setLevel(logging.INFO)


class Ingestor(object):
    def __init__(self):
        logger.info("Initialising ingestor")

        # Parse env vars
        self.elastic_url = os.environ['ELASTIC_URL']
        self.elastic_user = os.environ['ELASTICSEARCH_USER']
        self.elastic_password = os.environ['ELASTICSEARCH_PASSWORD']
        self.elastic_index_spec = os.environ['ELASTIC_INDEX_SPEC']
        self.elastic_dry_run = os.environ['ELASTIC_DRY_RUN']
        self.elastic_tls_enabled = os.environ['ELASTIC_TLS_ENABLED']
        self.index_standard = os.environ['ELASTIC_INDEX']

        # Compute tag to identify this run
        now = datetime.datetime.now()
        self.run_tag = now.strftime("%Y-%m-%d %H:%M:%S")

        # Define indexes
        self.index_short_term = f"short-term-{self.index_standard}"

        # Instantiate clients
        logger.info("Instantiating clients")
        self.db = Neo4jConnector()
        self._es_init_clients()

    # ===================================================================
    # ES INTEGRATION
    # ===================================================================
    def _es_init_clients(self):
        """
        Instantiate one ES client for each index to be used:
            cartography-<date>
            short-term-cartography-<date>
        """
        self.es_clients = []
        for index in [self.index_standard, self.index_short_term]:
            c = ElasticsearchConsumer(
                self.elastic_url,
                index,
                self.elastic_dry_run,
                self.elastic_user,
                self.elastic_password,
                self.elastic_tls_enabled
            )
            self.es_clients.append(c)

    def _es_push_indexes(self, content):
        """
        For each ES client, create an index for today's ingestion
        """
        for c in self.es_clients:
            c.create_index(content)

    def _es_push_results(self, query_name, records):
        """
        For each ES client, push the records provided
        """
        logger.debug(f"Pushing {query_name}: {records}")
        for c in self.es_clients:
            c.send_to_es(query_name, records)

    # ===================================================================
    # RECORD MANIPULATION
    # ===================================================================
    def _sanitise_fields(self, record):
        """
        ElasticSearch doesn't like parenthesis in the field names,
        so we have to replace them before ingesting the records.
        """
        sanitised = {}
        for k, v in record.items():
            new_key = k.replace('(', '_').replace(')', '_')
            sanitised[new_key] = v
        return sanitised

    def _enrich_results(self, record, query):
        """
        Enrich results from Neo4j with metadata needed by ES
        """
        record['metadata.query_name'] = query['name']
        record['metadata.query_id'] = '{}_{}'.format(
            query['name'], self.run_tag)
        record['metadata.query_description'] = query['description']
        record['metadata.query_headers'] = query['headers']
        record['@timestamp'] = int(round(time.time() * 1000))
        return record

    # ===================================================================
    # EXPOSED OPERATIONS
    # ===================================================================
    def push_indexes(self):
        with open(self.elastic_index_spec) as fp:
            content = fp.read()
            self._es_push_indexes(content)

    def query_by_tag(self, tags):
        logger.info("Querying Neo4J by tags: {}".format(tags))
        return self.db.query_by_tag(tags)

    def push_results(self, queries_results):
        logger.info("Pushing query results to ES")
        for query in queries_results:
            # query = {
            #   'name': 'gcp_project_list',
            #   'description': 'Full list of GCPProjects',
            #   'headers': ['project_id', ...],
            #   'result': [ {...}, ]
            logger.debug(f"Processing query: {query}")
            for r in query['result']:
                # Sanitise fields
                sanitised = self._sanitise_fields(r)
                # Enrich data
                enriched = self._enrich_results(sanitised, query)
                # Send to elastic
                self._es_push_results(query['name'], enriched)


def main():
    # Instantiate ingestor
    ingestor = Ingestor()

    # Define index
    logger.info("Pushing Elasticsearch indexes...")
    ingestor.push_indexes()

    logger.info("Starting ingesting data from Neo4j...")

    # Queries - AWS
    queries_results = ingestor.query_by_tag(['aws'])
    ingestor.push_results(queries_results)

    # Queries - GCP
    queries_results = ingestor.query_by_tag(['gcp'])
    ingestor.push_results(queries_results)

    logger.info("Ingestion completed successfully")


if __name__ == '__main__':
    main()
