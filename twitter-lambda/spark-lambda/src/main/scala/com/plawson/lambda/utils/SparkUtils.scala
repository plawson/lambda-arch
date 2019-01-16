package com.plawson.lambda.utils

import java.lang.management.ManagementFactory

import com.plawson.lambda.config.Settings
import org.apache.spark.sql.{SQLContext, SparkSession}
import org.apache.spark.streaming.{Duration, StreamingContext}
import org.apache.spark.{SparkConf, SparkContext}

/**
  * Created by Philippe Lawson on 10/01/2019
  */
object SparkUtils {
  val isIDE: Boolean = {
    ManagementFactory.getRuntimeMXBean.getInputArguments.toString.contains("IDEA")
  }

  def getSparkContext(appName: String): SparkContext = {
    var checkpointDirectory = ""

    // Configuration
    val lambdaConf = Settings.AppConfiguration

    // Get the Spark Config
    val conf = new SparkConf()
      .setAppName(appName)
      .set("spark.cassandra.connection.host", lambdaConf.cassandraHosts)
      // Avro classes are not Serializable. This is fixed in Arvo 1.8 but Confluent
      // still uses 1.7.7. To workaround this, use kryo serializer as it doesn't rely
      // java.io.Serializable.
      .set("spark.serializer", "org.apache.spark.serializer.KryoSerializer")
      .registerKryoClasses(Array(classOf[org.apache.avro.generic.GenericData.Record]))

    if (isIDE) {
      System.setProperty("hadoop.home.dir", "C:\\work\\dev\\pluralsight\\Libraries\\WinUtils")
      conf.setMaster("local[*]")
      checkpointDirectory = lambdaConf.devCheckpoint
    } else {
      checkpointDirectory = lambdaConf.prodCheckpoint
    }
    val sc = SparkContext.getOrCreate(conf)
    sc.setCheckpointDir(checkpointDirectory)
    sc
  }

  def getSQLContext(sc: SparkContext): SQLContext = {
    val sparkSession = SparkSession.builder.config(sc.getConf).getOrCreate()
    sparkSession.sqlContext
  }

  def getSparkSession(sc: SparkContext): SparkSession = {
    SparkSession.builder.config(sc.getConf).getOrCreate()
  }

  def getStreamingContext(speedLayer: (SparkContext, Duration) => StreamingContext, sc: SparkContext, batchDuration: Duration): StreamingContext = {
    val creatingFunc = () => speedLayer(sc, batchDuration)
    val ssc = sc.getCheckpointDir match {
      case Some(checkpointDir) => StreamingContext.getActiveOrCreate(checkpointDir, creatingFunc, sc.hadoopConfiguration, createOnError = true)
      case None => StreamingContext.getActiveOrCreate(creatingFunc)
    }
    sc.getCheckpointDir.foreach(checkpoint => ssc.checkpoint(checkpoint))
    ssc
  }
}
