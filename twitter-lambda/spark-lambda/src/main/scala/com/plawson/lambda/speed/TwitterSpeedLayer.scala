package com.plawson.lambda.speed


import com.plawson.lambda.config.Settings
import com.plawson.lambda.utils.SparkUtils._
import org.apache.spark.SparkContext
import org.apache.spark.streaming.kafka010.KafkaUtils
import org.apache.spark.streaming.{Duration, Minutes, Seconds, StreamingContext}
import io.confluent.kafka.serializers.KafkaAvroDeserializer
import org.apache.kafka.common.serialization.StringDeserializer
import org.apache.spark.sql.SaveMode
import org.apache.spark.sql.functions._
import org.apache.spark.streaming.kafka010.LocationStrategies.PreferConsistent
import org.apache.spark.streaming.kafka010.ConsumerStrategies.Subscribe


/**
  * Created by Philippe Lawson on 14/01/2019
  */
object TwitterSpeedLayer {
  def main(args: Array[String]): Unit = {

    // Setup contexts
    val sc = getSparkContext("Twitter Speed Layer")
    val sqlContext = getSQLContext(sc)
    val spark = getSparkSession(sc)

    val batchDuration = Seconds(30)

    def speedLayer(sc: SparkContext, batchDuration: Duration): StreamingContext = {

      val ssc = new StreamingContext(sc, batchDuration)
      val lambdaConf = Settings.AppConfiguration
      val topic = lambdaConf.kafkaTopic

      val kafkaParams = Map[String, Object](
        "auto.offset.reset" -> "latest",
        "bootstrap.servers" -> lambdaConf.brokers,
        "schema.registry.url" -> lambdaConf.schemaRegistry,
        "group.id" -> lambdaConf.groupId,
        "key.deserializer" -> classOf[StringDeserializer],
        "value.deserializer" -> classOf[KafkaAvroDeserializer]
      )

      val topics = Array(topic)
      val records = KafkaUtils.createDirectStream[String, Object](ssc, PreferConsistent, Subscribe[String, Object](topics, kafkaParams))
      /*val tweets =*/ records.map(r => r.value.toString)
        .window(Minutes(60), Minutes(60)).foreachRDD(rdd => {
        val df = spark.read.json(rdd)
          .filter(size(col("entities.hashtags")) > 0)
          .select((unix_timestamp(date_trunc("hour", to_timestamp(col("created_at"), "yyyy-MM-dd'T'HH:mm:ss.SSSZ"))) * 1000)
            .as("date_hour"), explode(col("entities.hashtags.text")).as("hashtag"))

        df.createTempView("hashtags")

        val hashtagsCountByHourView = sqlContext.sql(
          """SELECT
            |date_hour, hashtag, count(hashtag) as count
            |FROM hashtags
            |GROUP BY date_hour, hashtag""".stripMargin)

        hashtagsCountByHourView
          .write
          .mode(SaveMode.Append)
          .format("org.apache.spark.sql.cassandra")
          .options(Map("keyspace" -> "speed_layer", "table" -> "speed_view_a"))
          .save()

        hashtagsCountByHourView
          .write
          .mode(SaveMode.Append)
          .format("org.apache.spark.sql.cassandra")
          .options(Map( "keyspace" -> "speed_layer", "table" -> "speed_view_b"))
          .save()
      })

      ssc
    }

    val ssc = getStreamingContext(speedLayer, sc, batchDuration)
    ssc.start()
    ssc.awaitTermination()
  }
}
