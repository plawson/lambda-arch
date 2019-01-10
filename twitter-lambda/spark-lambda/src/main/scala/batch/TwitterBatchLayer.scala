package batch

import config.Settings
import utils.SparkUtils._

import io.confluent.kafka.schemaregistry.client.CachedSchemaRegistryClient

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
    val schema = schemaRegistry.getLatestSchemaMetadata("tweets").getSchema

    // Initialize an input DF
    val inpufDF = spark
      .read
      .format("com.databricks.spark.avro")
      .option("avroSchema", schema)
      .load(lambdaConf.hdfsPath)
  }
}
