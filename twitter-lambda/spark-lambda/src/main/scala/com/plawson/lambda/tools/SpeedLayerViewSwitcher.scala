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

    // Get the latest batch layer the last hashtag date time processed minus 1 hour.
    val latestDateRowRS = session.execute("SELECT * FROM serving_layer.serving_last_date_hour")
    val oneDateRow = latestDateRowRS.one()
    val latestDate = oneDateRow.getTimestamp("date_hour").getTime - (60 * 60 * 1000)

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
    val nextSpeedViewNameRS = session.execute("INSERT INTO speed_layer.current_view (id, view_name) VALUES('current', '" + nextSpeedViewName + "'")
    if (!nextSpeedViewNameRS.wasApplied()) {

      throw UpdateCurrentViewFailedException(nextSpeedViewName)
    }

    // Purge obsolete records from the former view
    val purgeRS = session.execute("DELETE FROM speed_layer." + currentSpeedViewName + " WHERE date_hour >=" + latestDate)
    if (!purgeRS.wasApplied()) {
      throw PurgeCurrentViewFailedException(currentSpeedViewName)
    }

    session.close()

  }
}


