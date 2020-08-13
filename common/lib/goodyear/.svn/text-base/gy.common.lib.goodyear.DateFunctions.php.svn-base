<?php
namespace GY\Common\Lib\Goodyear
{

  use DateTime;
  use DateTimeZone;
  use GY\Core\Logic\ZendLogger;
  use GY\Core\Model\TimeZoneInfo;

  /**
   * Class DateFunctions
   * @package GY\Common\Lib\Goodyear
   */
  final class DateFunctions
  {
    /**
     * Default format for date time strings
     */
    const Format = "Y-m-d H:i:s";
    private static $timeZoneList = [];

    /**
     * strips unexpected formatting from date time strings
     *
     * @param string $dateTime
     *
     * @return string
     */
    static public function CleanDateTime(string $dateTime = ""): string
    {
      if (strlen(trim($dateTime)) > 0)
      {
        $pattern = "/[^\d\.\+\s:-]/i";
        $replace = " ";
        $dateTime = preg_replace($pattern, $replace, $dateTime);
      }

      return $dateTime;
    }

    /**
     * @param $datetime
     *
     * @return string
     */
    static public function DateOrNull(string $datetime): string
    {
      if ($datetime == null)
      {
        return "NULL";
      }

      return "'" . self::CleanDateTime($datetime) . "'";
    }

    /**
     * converts a verbose string timezone into the UTC offset
     *
     * @param string $timezone
     * @param ZendLogger $logger
     *
     * @return TimeZoneInfo
     */
    static public function GetTimeZoneInfo(string $timezone, ZendLogger $logger): TimeZoneInfo
    {
      $result = new TimeZoneInfo();
      $tz = new DateTimeZone($timezone);
      $transitions = $tz->getTransitions();
      if (is_array($transitions))
      {
        array_shift($transitions);
        $testDateTime = new DateTime();
        $testDateTime->add(new \DateInterval("P2Y"));
        foreach ($transitions as $transition)
        {
          if ($transition["isdst"])
          {
            if (new DateTime($transition["time"]) > $testDateTime)
            {
              $result->Dst = true;
            }
          }
          else
          {
            $result->UtcOffset = $transition ["offset"];
          }
          if ($result->UtcOffset !== null && $result->Dst !== null)
          {
            break;
          }
        }
        $result->UtcOffset = $result->UtcOffset / 60 / 60;
        $result->Dst = boolval($result->Dst);
      }
      else
      {
        $logger->LogInformation("$timezone is not a known time zone.");
      }
      return $result;
    }

    /**
     * @param string $date
     *
     * @return int
     */
    public static function GetWeekdayInt(string $date): int
    {
      MarkObject($date);
      return date("w", $date);
    }
  }
}