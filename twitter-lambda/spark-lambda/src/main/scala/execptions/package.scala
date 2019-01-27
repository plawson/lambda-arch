/**
  * Created by plawson on 2019-01-27.
  *
  */
package object execptions {

  case class UnknownSpeedViewNameException(name: String) extends Exception(name)

  case class UpdateCurrentViewFailedException(name: String) extends Exception(name)

  case class PurgeCurrentViewFailedException(name: String) extends Exception(name)
}
