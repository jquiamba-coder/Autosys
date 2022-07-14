<?php
declare(strict_types=1);
namespace GY\Common\Lib\Goodyear
{

  use GY\Core\Logic\ZendLogger;

  /**
   * Class OopFunctions
   * @package GY\Common\Lib\Goodyear
   */
  final class OopFunctions
  {
    /**
     * @param object $from
     * @param object $to
     * @param ZendLogger $logger
     *
     * @return bool|object
     */
    static function Cast($from, $to, $logger)
    {
      $logger->LogDebug($from);
      $fromSerialized = serialize($from);
      $fromName = get_class($from);
      $toName = get_class($to);
      $toSerialized = str_replace($fromName, $toName, $fromSerialized);
      $toSerialized = preg_replace("/O:\d*:\"([^\"]*)/", "O:" . strlen($toName) . ":\"$1", $toSerialized);
      $toSerialized = preg_replace_callback(
        "/s:\d*:\"[^\"]*\"/", function ($matches)
      {
        $arr = explode(":", $matches[0]);
        $arr[1] = mb_strlen($arr[2]) - 2;
        return implode(":", $arr);
      }, $toSerialized
      );

      $to = unserialize($toSerialized);
      $logger->LogDebug($to);
      return $to;
    }
  }
}
