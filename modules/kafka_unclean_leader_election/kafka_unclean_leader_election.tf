resource "shoreline_notebook" "kafka_unclean_leader_election" {
  name       = "kafka_unclean_leader_election"
  data       = file("${path.module}/data/kafka_unclean_leader_election.json")
  depends_on = [shoreline_action.invoke_replica_increase,shoreline_action.invoke_kafka_config_update]
}

resource "shoreline_file" "replica_increase" {
  name             = "replica_increase"
  input_file       = "${path.module}/data/replica_increase.sh"
  md5              = filemd5("${path.module}/data/replica_increase.sh")
  description      = "Increase the number of replicas for partition."
  destination_path = "/tmp/replica_increase.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "kafka_config_update" {
  name             = "kafka_config_update"
  input_file       = "${path.module}/data/kafka_config_update.sh"
  md5              = filemd5("${path.module}/data/kafka_config_update.sh")
  description      = "Check the Kafka configuration file on each broker to ensure that the "
  destination_path = "/tmp/kafka_config_update.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_replica_increase" {
  name        = "invoke_replica_increase"
  description = "Increase the number of replicas for partition."
  command     = "`chmod +x /tmp/replica_increase.sh && /tmp/replica_increase.sh`"
  params      = ["TOPIC_NAME","NEW_REPLICA_COUNT","PARTITION_NUMBER"]
  file_deps   = ["replica_increase"]
  enabled     = true
  depends_on  = [shoreline_file.replica_increase]
}

resource "shoreline_action" "invoke_kafka_config_update" {
  name        = "invoke_kafka_config_update"
  description = "Check the Kafka configuration file on each broker to ensure that the "
  command     = "`chmod +x /tmp/kafka_config_update.sh && /tmp/kafka_config_update.sh`"
  params      = ["LIST_OF_BROKER_IPS","KAFKA_CONFIGURATION_FILE"]
  file_deps   = ["kafka_config_update"]
  enabled     = true
  depends_on  = [shoreline_file.kafka_config_update]
}

