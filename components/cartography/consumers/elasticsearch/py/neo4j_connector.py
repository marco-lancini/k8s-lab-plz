import os
import json
import logging
from neo4j import GraphDatabase
from datetime import datetime, timedelta

logging.basicConfig()
logger = logging.getLogger("neo4j_connector")
logger.setLevel(logging.DEBUG)

NEO4J_QUERIES_FILES = [
    'queries.json',
]


class NeoDB(object):
    """
    Neo4j Wrapper around `neo4j.GraphDatabase`,
    which is in charge of instaurating a connection with
    the backend Neo4j database.
    This should never be instantiated directly.
    """

    def __init__(self):
        self._parse_config()
        self._connect()

    def _parse_config(self):
        """
        uri: The URI of Neo4j (e.g., bolt://neo4j-bolt-service:7687)
        username: Username for Neo4j
        password: Password for Neo4j

        If no config has been passed to __init__,
        fetch the connection string from environment variables
        """
        self._neo4j_uri = os.environ['NEO4J_URI']
        self._neo4j_user = os.environ['NEO4J_USER']
        self._neo4j_password = os.environ['NEO4J_SECRETS_PASSWORD']

    def _connect(self):
        """
        Instantiate the Neo4j python driver
        """
        self._driver = GraphDatabase.driver(self._neo4j_uri,
                                            auth=(self._neo4j_user, self._neo4j_password))
        logger.info('Neo4J Client instantiated: {}'.format(self._neo4j_uri))

    @staticmethod
    def _exec_query(tx, query, kwargs):
        if kwargs:
            result = tx.run(query, **kwargs)
        else:
            result = tx.run(query)
        return result

    def query(self, q, kwargs=None):
        with self._driver.session() as session:
            return session.read_transaction(self._exec_query, q, kwargs)

    def close(self):
        self._driver.close()


class Neo4jConnector(object):
    """
    Main connector which abstract over the actual execution of queries,
    and provide an interface to run queries and obtain results
    """

    def __init__(self):
        # Initialize DB
        self.db = NeoDB()
        # Load the queries file into memory
        self._load_queries()

    def _load_queries(self):
        extracted = []
        for fname in NEO4J_QUERIES_FILES:
            path = os.path.join("/", fname)
            if not os.path.isfile(path):
                logger.warning('File "{}" not found. Skipping...'.format(path))
                continue
            with open(path, 'r') as fp:
                logger.debug('Loading queries file: {}'.format(path))
                body = fp.read()
                temp = body.strip()[1:-1]
                extracted.append(temp)
        queries_str = "[%s]" % (",".join(extracted))
        self.QUERIES = json.loads(queries_str)

    #
    # UTILS
    #
    @staticmethod
    def _n_recent_days(N):
        return (datetime.utcnow() - timedelta(days=N))

    def _parse_dynamic_params(self, q):
        params = q.get('params', '')
        kwargs = ""
        if params:
            # Iterate through the parameters and verify if one matches the supported types
            for p in params.keys():
                kwargs = {}
                # The query has a parameter specifying to
                # retrieve the assets for the N most recent days
                if p == "n_recent_days":
                    kwargs[params[p]["param_name"]] = \
                        str(self._n_recent_days(params[p]["param_value"]))
        return kwargs

    #
    # FILTERS
    #
    def _filter_by_tags(self, queries, tags):
        """
        Returns all the queries which contain *all* the tags provided
        (it is an AND)
        """
        if type(tags) is not list:
            tags = list(tags)
        return [q for q in queries if all(elem in q['tags'] for elem in tags)]

    def _filter_by_account(self, cypher, account):
        if account:
            if 'WHERE' in cypher:
                cypher = cypher.replace(
                    ' WHERE ', ' WHERE a.name = "{}" and '.format(account))
            else:
                cypher = cypher.replace(
                    ' RETURN ', ' WHERE a.name = "{}" RETURN '.format(account))
        return cypher

    #
    # EXECUTE QUERIES
    #
    def query_raw(self, cypher):
        logger.info("Executing a raw query: {}".format(cypher))
        return self.db.query(cypher)

    def _execute_queries(self, queries, account):
        queries_result = []
        for q in queries:
            # Parse optional dynamic parameters
            kwargs = self._parse_dynamic_params(q)
            # If an account is provided, inject a WHERE clause to filter by account
            cypher = self._filter_by_account(q['query'], account)
            # Execute the query and parse results as dictionaries
            cypher = "{} {}".format(cypher, q['return'])
            records = [x.data() for x in self.db.query(cypher, kwargs)]
            # Add records to result list
            temp = {}
            temp['name'] = q['name']
            temp['description'] = q['description']
            temp['headers'] = q['result_headers']
            temp['result'] = records
            queries_result.append(temp)
        return queries_result

    def query_by_tag(self, tags, account=None):
        logger.info("Executing queries by tag: {}".format(tags))
        # Filter queries
        selected_queries = self._filter_by_tags(self.QUERIES, tags)
        # Run queries
        return self._execute_queries(selected_queries, account)


if __name__ == '__main__':
    Neo4jConnector()
