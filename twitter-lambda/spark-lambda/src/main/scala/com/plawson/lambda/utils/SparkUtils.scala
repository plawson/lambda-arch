package com.plawson.lambda.utils

import java.lang.management.ManagementFactory

import com.plawson.lambda.config.Settings
import org.apache.spark.sql.{SQLContext, SparkSession}
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
    val lambdaConf = Settings.AppConfiguretion

    // Get the Spark Config
    val conf = new SparkConf()
      .setAppName(appName)
      .set("spark.cassandra.connection.host", lambdaConf.cassandraHosts)

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
}
