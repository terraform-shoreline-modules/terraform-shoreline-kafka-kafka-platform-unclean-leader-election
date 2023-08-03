resource "shoreline_notebook" "kafka_unclean_leader_election" {
  name       = "kafka_unclean_leader_election"
  data       = file("${path.module}/data/kafka_unclean_leader_election.json")
  depends_on = [shoreline_action.invoke_network_check,shoreline_action.invoke_disable_unclean_leader_election,shoreline_action.invoke_kafka_config_review]
}

resource "shoreline_file" "network_check" {
  name             = "network_check"
  input_file       = "${path.module}/data/network_check.sh"
  md5              = filemd5("${path.module}/data/network_check.sh")
  description      = "An issue with the network connection between the Kafka broker and the ZooKeeper ensemble."
  destination_path = "/agent/scripts/network_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "disable_unclean_leader_election" {
  name             = "disable_unclean_leader_election"
  input_file       = "${path.module}/data/disable_unclean_leader_election.sh"
  md5              = filemd5("${path.module}/data/disable_unclean_leader_election.sh")
  description      = "Disable unclean leader election in the Broker settings to prevent future occurrences."
  destination_path = "/agent/scripts/disable_unclean_leader_election.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "kafka_config_review" {
  name             = "kafka_config_review"
  input_file       = "${path.module}/data/kafka_config_review.sh"
  md5              = filemd5("${path.module}/data/kafka_config_review.sh")
  description      = "Review the Kafka configuration and adjust it if necessary to prevent similar incidents from occurring in the future."
  destination_path = "/agent/scripts/kafka_config_review.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_network_check" {
  name        = "invoke_network_check"
  description = "An issue with the network connection between the Kafka broker and the ZooKeeper ensemble."
  command     = "`chmod +x /agent/scripts/network_check.sh && /agent/scripts/network_check.sh`"
  params      = []
  file_deps   = ["network_check"]
  enabled     = true
  depends_on  = [shoreline_file.network_check]
}

resource "shoreline_action" "invoke_disable_unclean_leader_election" {
  name        = "invoke_disable_unclean_leader_election"
  description = "Disable unclean leader election in the Broker settings to prevent future occurrences."
  command     = "`chmod +x /agent/scripts/disable_unclean_leader_election.sh && /agent/scripts/disable_unclean_leader_election.sh`"
  params      = ["BROKER_SETTINGS"]
  file_deps   = ["disable_unclean_leader_election"]
  enabled     = true
  depends_on  = [shoreline_file.disable_unclean_leader_election]
}

resource "shoreline_action" "invoke_kafka_config_review" {
  name        = "invoke_kafka_config_review"
  description = "Review the Kafka configuration and adjust it if necessary to prevent similar incidents from occurring in the future."
  command     = "`chmod +x /agent/scripts/kafka_config_review.sh && /agent/scripts/kafka_config_review.sh`"
  params      = []
  file_deps   = ["kafka_config_review"]
  enabled     = true
  depends_on  = [shoreline_file.kafka_config_review]
}

