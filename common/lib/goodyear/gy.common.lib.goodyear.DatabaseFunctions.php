<?php
namespace GY\Common\Lib\Goodyear
{

  /**
   * Class DatabaseFunctions
   * @package GY\Common\Lib\Goodyear
   */
  final class DatabaseFunctions
  {
    /**
     * Returns either a quoted string or NULL
     * @param string $string
     *
     * @return string
     */
    static public function QuoteOrNull(string $string = ""): string
    {
      if (strlen($string) > 0)
      {
        return "'$string'";
      }
      return "NULL";
    }
  }
}