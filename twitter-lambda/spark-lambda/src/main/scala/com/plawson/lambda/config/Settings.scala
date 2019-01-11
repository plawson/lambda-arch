package com.plawson.lambda.config

import com.typesafe.config.ConfigFactory

/**
  * Created by Philippe Lawson on 10/01/2019
  */
object Settings {
  private val config = ConfigFactory.load()

  object AppConfiguretion {
    private val appConfiguretion = config.getConfig("lambdatwitter")

    lazy val kafkaTopic = appConfiguretion.getString("kafka_topic")
    lazy val hdfsPath = appConfiguretion.getString("hdfs_path")
    lazy val schemaRegistry = appConfiguretion.getString("schema_registry")
    lazy val cassandraHosts = appConfiguretion.getString("cassandra_host")
    lazy val devCheckpoint = appConfiguretion.getString("dev_checkpoint")
    lazy val prodCheckpoint = appConfiguretion.getString("prod_checkpoint")
  }
}
