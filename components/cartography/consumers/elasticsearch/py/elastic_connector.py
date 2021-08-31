import os
import json
import logging
from datetime import date
import logging
import certifi
import elasticsearch

logging.basicConfig()
logger = logging.getLogger("elastic_connector")
logger.setLevel(logging.DEBUG)


class ElasticClient:
    """Wrapper around Elasticsearch client"""

    def __init__(self, url, ca, dry_run=False):
        """
        url: URL of Elasticsearch cluster to connect to
        ca: CA certificate for Elasticsearch
        dry_run: if True, it will not push to Elasticsearch
        """
        if not url:
            raise Exception('Elasticsearch URL must be specified')
        self.dry_run = dry_run
        self.es = elasticsearch.Elasticsearch([url], ca_certs=ca)

    def send(self, index, doc_type, data):
        """Send data to Elasticsearch.

        index: Elasticsearch index to send to
        doc_type: Elasticsearch document type
        data: Data (dictionary) to send to Elasticsearch.
        """
        if self.dry_run:
            logger.info('Dry-run: index=%s doc_type=%s data=%s',
                        index, doc_type, data)
            return
        res = self.es.index(index=index, doc_type=doc_type, body=data)
        if not (res.get('created') or res.get('result') == 'created'):
            raise Exception('Failed to submit to Elasticsearch: created:{} result:{}'.format(
                res.get('created'), res.get('result')))


class ElasticsearchConsumer(object):
    """
    Main consumer which abstracts over the Elasticsearch APIs,
    which provides 2 functionalities:

    create_index: create an ES index for today's data
    send_to_es: push data to the index specified
    """
    DOC_TYPE = '_doc'

    def __init__(self, url, index, dry_run, elastic_user, elastic_password):
        self._parse_config(url, index, dry_run, elastic_user, elastic_password)
        self._connect()

    def _parse_config(self, url, index, dry_run, elastic_user, elastic_password):
        """
        url: The domain name (no protocol, no port) of the Elasticsearch instance to send the results to
        index: The Elasticsearch index to use
        dry_run: If set, will not upload any data to Elasticsearch
        """
        self.url = url
        self.index = index
        self.dry_run = dry_run
        self._elatic_user = elastic_user
        self._elatic_password = elastic_password

        # Validate url and index have been specified
        if not self.url or not self.index:
            raise Exception("Elasticsearch config is incomplete")

        # Append current date to index: indexname-YYYY.MM.DD
        self.index = "{}-{}".format(self.index,
                                    date.today().strftime("%Y.%m.%d"))
        # Dry run comes from env vars, so it is a string
        self.dry_run = True if self.dry_run == 'True' else False

    def _connect(self):
        self.es_location = "https://{}:{}@{}:443".format(
            self._elatic_user,
            self._elatic_password,
            self.url
        )
        self.es_client = ElasticClient(url=self.es_location,
                                       ca=certifi.where(),
                                       dry_run=self.dry_run)
        logger.info(
            'ElasticSearch Client instantiated: {} / {}'.format(self.url, self.index))

    def create_index(self, data):
        logger.info('Creating index for: {}'.format(self.index))
        self.es_client.es.indices.create(
            index=self.index,
            body=data,
            ignore=400  # ignore 400 already exists code
        )

    def send_to_es(self, query_name, data):
        logger.info('Sending data to ES: {}'.format(query_name))
        self.es_client.send(index=self.index,
                            doc_type=self.DOC_TYPE,
                            data=data)
