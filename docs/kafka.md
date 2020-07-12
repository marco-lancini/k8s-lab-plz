# Kafka Setup


## Deploy Kafka/Zookeeper
```bash
❯ plz run //components/kafka:deploy
```
* Creates `kafka` namespace
* Deploys the Kafka Operator
* Deploys the Kafka cluster (Kafka, Zookeeper, KafkaExporter, Entity Operator)

Verify pods are healthy:
```bash
❯ kubectl -n kafka get pods
NAME                                            READY   STATUS    RESTARTS   AGE
kafka-cluster-entity-operator-77b9f56dd-625m7   3/3     Running   0          22s
kafka-cluster-kafka-0                           2/2     Running   0          47s
kafka-cluster-kafka-exporter-795f5ccb5b-2hlff   1/1     Running   0          74s
kafka-cluster-zookeeper-0                       1/1     Running   0          2m59s
strimzi-cluster-operator-54565f8c56-nf24m       1/1     Running   0          5m46s
```


## Interact with the brokers
Once the cluster is running, you can run a simple producer to interact with Kafka
and produce/consumer messages to/from a topic.

* List topics:
```bash
❯ plz run //components/kafka:list-topics
[+] Starting container...
If you don't see a command prompt, try pressing enter.
__consumer_offsets
my-topic
test-topic
test.topic
pod "kafka-interact-list" deleted
```

* Send messages:
```bash
❯ plz run //components/kafka:produce-topic -- test-topic
[+] Starting container...
If you don't see a command prompt, try pressing enter.
>1
>2
>3
>4
>5
>^C
```

* Receive messages:
```bash
❯ plz run //components/kafka:consume-topic -- test-topic
[+] Starting container...
If you don't see a command prompt, try pressing enter.
1
2
3
4
5
Processed a total of 5 messages
```


## References
* [Kafka Operator](https://github.com/strimzi/strimzi-kafka-operator)
* [Strimzi Overview guide](https://strimzi.io/docs/operators/latest/overview.html)
* [Using Strimzi](https://strimzi.io/docs/operators/latest/using.html)
