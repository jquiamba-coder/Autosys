<?php
declare(strict_types=1);
namespace GY\Common\Lib\Goodyear
{
  /**
   * Class StringFunctions
   * @package GY\Common\Lib\Goodyear
   */
  final class StringFunctions
  {
    /**
     * @param string $haystack
     * @param string $needle
     *
     * @return bool
     */
    static function Contains(string $haystack, string $needle): bool
    {
      return strpos($haystack, $needle) !== false;
    }

    /**
     * @param string $output
     * @param bool $addNewLine
     */
    public static function ScreenLineWriter($output = "", $addNewLine = false): void
    {
      $output = "\r" . str_pad($output, 80);
      echo $output;
      if ($addNewLine)
      {
        echo PHP_EOL;
      }
    }
  }
}
