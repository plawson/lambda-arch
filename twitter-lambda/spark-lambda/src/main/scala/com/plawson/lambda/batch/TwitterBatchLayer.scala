package com.plawson.lambda.batch

import com.plawson.lambda.config.Settings
import io.confluent.kafka.schemaregistry.client.CachedSchemaRegistryClient
import com.plawson.lambda.utils.SparkUtils.{getSQLContext, getSparkContext, getSparkSession}

/**
  * Created by Philippe Lawson on 10/01/2019
  */
object TwitterBatchLayer {
  def main(args: Array[String]): Unit = {

    // Spark Context
    val sc = getSparkContext("Twitter Lambda")
    val sqlContext = getSQLContext(sc)
    val spark = getSparkSession(sc)
    val lambdaConf = Settings.AppConfiguretion

    // Schema Registry
    val schemaRegistry = new CachedSchemaRegistryClient(lambdaConf.schemaRegistry, 10)
    val schema = schemaRegistry.getLatestSchemaMetadata("tweets-value").getSchema

    // Initialize an input DF
    val inpufDF = spark
      .read
      .format("avro")
      .option("avroSchema", schema)
      .load(lambdaConf.hdfsPath)
      .show()
  }
}
