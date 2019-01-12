package com.plawson.lambda.batch

import com.plawson.lambda.config.Settings
import io.confluent.kafka.schemaregistry.client.CachedSchemaRegistryClient
import com.plawson.lambda.utils.SparkUtils.{getSQLContext, getSparkContext, getSparkSession}

import org.apache.spark.sql.functions._

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
    val inputDF = spark
      .read
      .format("avro")
      .option("avroSchema", schema)
      .load(lambdaConf.hdfsPath)
      .filter(size(col("entities.hashtags")) > 0)
      .select(unix_timestamp(date_trunc("hour", to_timestamp(col("created_at"), "yyyy-MM-dd'T'HH:mm:ss.000Z")))
        .as("timestamp_hour"), explode(col("entities.hashtags.text")).as("hashtag"))
      .persist

    inputDF.createTempView("hashtags")

    val hashtagsByHour = sqlContext.sql(
      """SELECT
        |timestamp_hour, hashtag, count(hashtag) as count
        |FROM hashtags
        |GROUP BY timestamp_hour, hashtag
        |ORDER BY count DESC""".stripMargin).persist

    hashtagsByHour.show


  }
}
