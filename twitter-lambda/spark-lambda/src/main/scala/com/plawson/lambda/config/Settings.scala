package com.plawson.lambda.config

import com.typesafe.config.ConfigFactory

/**
  * Created by Philippe Lawson on 10/01/2019
  */
object Settings {
  private val config = ConfigFactory.load()

  object AppConfiguration {
    private val appConfiguration = config.getConfig("lambdatwitter")

    lazy val kafkaTopic: String = appConfiguration.getString("kafka_topic")
    lazy val hdfsPath: String = appConfiguration.getString("hdfs_path")
    lazy val schemaRegistry: String = appConfiguration.getString("schema_registry")
    lazy val cassandraHosts: String = appConfiguration.getString("cassandra_host")
    lazy val devCheckpoint: String = appConfiguration.getString("dev_checkpoint")
    lazy val prodCheckpoint: String = appConfiguration.getString("prod_checkpoint")
    lazy val brokers: String = appConfiguration.getString("brokers")
    lazy val groupId: String = appConfiguration.getString("group_id")
  }
}
