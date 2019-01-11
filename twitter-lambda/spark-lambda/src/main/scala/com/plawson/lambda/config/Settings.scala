package com.plawson.lambda.config

import com.typesafe.config.ConfigFactory

/**
  * Created by Philippe Lawson on 10/01/2019
  */
object Settings {
  private val config = ConfigFactory.load()

  object AppConfiguretion {
    private val appConfiguretion = config.getConfig("lambdatwitter")

    lazy val kafkaTopic: String = appConfiguretion.getString("kafka_topic")
    lazy val hdfsPath: String = appConfiguretion.getString("hdfs_path")
    lazy val schemaRegistry: String = appConfiguretion.getString("schema_registry")
    lazy val cassandraHosts: String = appConfiguretion.getString("cassandra_host")
    lazy val devCheckpoint: String = appConfiguretion.getString("dev_checkpoint")
    lazy val prodCheckpoint: String = appConfiguretion.getString("prod_checkpoint")
  }
}
