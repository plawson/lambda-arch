package com.plawson.lambda.tools

import com.datastax.driver.core._
import com.plawson.lambda.config.Settings
import execptions._

/**
  * Created by plawson on 2019-01-27.
  *
  */
object SpeedLayerViewSwitcher {

  def main(args: Array[String]): Unit = {

    val lambdaConf = Settings.AppConfiguration

    val session: Session = new Cluster
    .Builder()
      .addContactPoint(lambdaConf.cassandraHosts)
      .build()
      .connect()

    try {
      // Get the latest batch layer the last hashtag date time processed minus 1 hour.
      val latestDateRowRS = session.execute("SELECT * FROM serving_layer.serving_last_date_hour")
      val oneDateRow = latestDateRowRS.one()
      val latestDate = oneDateRow.getTimestamp("date_hour").getTime

      // Get the current speed layer view name
      val currentSpeedViewRS = session.execute("SELECT * FROM speed_layer.current_view")
      val oneViewRow = currentSpeedViewRS.one()
      val currentSpeedViewName = oneViewRow.getString("view_name")

      // Set the next speed view name
      val nextSpeedViewName = currentSpeedViewName match {
        case "speed_view_a" => "speed_view_b"
        case "speed_view_b" => "speed_view_a"
        case whatever => throw UnknownSpeedViewNameException(whatever)
      }

      // Register the new current view name
      session.execute("INSERT INTO speed_layer.current_view (id, view_name) VALUES('current', '" + nextSpeedViewName + "')")

      // Purge obsolete records from the former view
          val keysToDeleteRS = session.execute("select distinct date_hour from speed_layer.speed_view_a where date_hour < " + latestDate + " ALLOW FILTERING")
          while (!keysToDeleteRS.isExhausted) {
            session.execute("DELETE FROM speed_layer." + currentSpeedViewName + " WHERE date_hour = " + keysToDeleteRS.one().getTimestamp("date_hour").getTime)
          }
    }
    catch {
        case e: Throwable => e.printStackTrace()
          System.exit(1)
    } finally {
      session.close()
    }

    System.exit(0)
  }
}


