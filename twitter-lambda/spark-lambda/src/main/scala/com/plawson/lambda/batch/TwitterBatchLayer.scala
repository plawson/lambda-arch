package com.plawson.lambda.batch

import com.plawson.lambda.config.Settings
import com.plawson.lambda.utils.SparkUtils.{getSQLContext, getSparkContext, getSparkSession}
import io.confluent.kafka.schemaregistry.client.CachedSchemaRegistryClient
import org.apache.spark.sql.SaveMode
import org.apache.spark.sql.functions._

/**
  * Created by Philippe Lawson on 10/01/2019
  */
object TwitterBatchLayer {
  def main(args: Array[String]): Unit = {

    // Spark Context
    val sc = getSparkContext("Twitter Batch Layer")
    val sqlContext = getSQLContext(sc)
    val spark = getSparkSession(sc)
    val lambdaConf = Settings.AppConfiguration

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
      .select((unix_timestamp(date_trunc("hour", to_timestamp(col("created_at"), "yyyy-MM-dd'T'HH:mm:ss.SSSZ"))) * 1000)
        .as("date_hour"), explode(col("entities.hashtags.text")).as("hashtag"))
      .persist

    inputDF.createOrReplaceTempView("batch_hashtags")

    val hashtagsCountByHour = sqlContext.sql(
      """SELECT
        |date_hour, hashtag, count(hashtag) as count
        |FROM batch_hashtags
        |GROUP BY date_hour, hashtag""".stripMargin).persist

    inputDF.unpersist

    val lastDataHour = sqlContext.sql(
      """SELECT 'latest' as id,
        |max(date_hour) as date_hour
        |FROM batch_hashtags
      """.stripMargin)

    hashtagsCountByHour
      .write
      .mode(SaveMode.Append)
      .format("org.apache.spark.sql.cassandra")
      .options(Map( "keyspace" -> "serving_layer", "table" -> "serving_view"))
      .save()

    lastDataHour
      .write
      .mode(SaveMode.Append)
      .format("org.apache.spark.sql.cassandra")
      .options(Map("keyspace" -> "serving_layer", "table" -> "serving_last_date_hour"))
      .save()
  }
}
