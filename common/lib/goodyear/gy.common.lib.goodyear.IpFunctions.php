<?php
namespace GY\Common\Lib\Goodyear
{

  use GY\Core\Logic\ScreenColors;
  use GY\Core\Logic\ZendLogger;
  use GY\Core\Model\IpRangeIterator;

  /**
   * Class IpFunctions
   * @package GY\Common\Lib\Goodyear
   */
  final class IpFunctions
  {
    /**
     * dtr_pton
     * Converts a printable IP into an unpacked binary string
     * @author Mike Mackintosh - mike@bakeryphp.com
     *
     * @param string $ip
     *
     * @return string $bin
     
     */
    static public function dtr_pton($ip)
    {
      if (filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_IPV4))
      {
        return current(unpack("a4", inet_pton($ip)));
      }
      elseif (filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_IPV6))
      {
        return current(unpack("a16", inet_pton($ip)));
      }
      MarkObject($ip, true, ScreenColors::RED);
      throw new \Exception("Please supply a valid IPv4 or IPv6 address");
    }

    /**
     * dtr_ntop
     * Converts an unpacked binary string into a printable IP
     * @author Mike Mackintosh - mike@bakeryphp.com
     *
     * @param string $str
     *
     * @return string $ip
     
     */
    static public function dtr_ntop($str)
    {
      if (strlen($str) == 16 OR strlen($str) == 4)
      {
        return inet_ntop(pack("a" . strlen($str), $str));
      }
      MarkObject($ip, true, ScreenColors::RED);
      throw new \Exception("Please provide a 4 or 16 byte string");
    }

    /**
     * @param string $needle
     * @param string $haystack
     * @param bool $debug
     *
     * @return bool
     
     */
    static public function Contains(string $needle, string $haystack, bool $debug = false): bool
    {
      $needleArray = explode("-", $needle);
      $haystackArray = explode("-", $haystack);
      if ($debug)
      {
        MarkLine(__FUNCTION__);
        print_r($needleArray);
        echo PHP_EOL;
        print_r($haystackArray);
        echo PHP_EOL;
      }
      if (count($needleArray) == 2 && count($haystackArray) == 2)
      {
        return self::RangeInRange($needleArray, $haystackArray, $debug);
      }
      if (count($needleArray) == 1 && count($haystackArray) == 2)
      {
        return self::IpInRange($needleArray[0], $haystackArray, $debug);
      }
      if (count($needleArray) == 1 && count($haystackArray) == 1)
      {
        return self::IpIsIp($needleArray[0], $haystackArray[0], $debug);
      }
      if (count($needleArray) == 2 && count($haystackArray) == 1)
      {
        return false;
      }

      if ($debug)
      {
        MarkLine(__FUNCTION__);
        print_r($needle);
        echo PHP_EOL;
        print_r($haystack);
        echo PHP_EOL;
      }
      throw new \Exception("Something wrong the IP/IP Ranges entered.");
    }

    /**
     * @param array $needleArray
     * @param array $haystackArray
     * @param bool $debug
     *
     * @return bool
     
     */
    static public function RangeInRange(array $needleArray, array $haystackArray, bool $debug = false): bool
    {
      $lowNeedle = IpFunctions::dtr_pton($needleArray[0]);
      $highNeedle = IpFunctions::dtr_pton($needleArray[1]);
      $lowHaystack = IpFunctions::dtr_pton($haystackArray[0]);
      $highHaystack = IpFunctions::dtr_pton($haystackArray[1]);
      $lowLow = strcmp($lowNeedle, $lowHaystack) >= 0;
      $highLow = strcmp($highNeedle, $lowHaystack) >= 0;
      $lowHigh = strcmp($lowNeedle, $highHaystack) <= 0;
      $highHigh = strcmp($highNeedle, $highHaystack) <= 0;
      $result = $lowLow && $lowHigh && $highLow && $highHigh;
      if ($debug)
      {
        MarkLine(__FUNCTION__);
        echo "Low needle, low haystack: " . (int)$lowLow . PHP_EOL;
        echo "High needle, low haystack: " . (int)$highLow . PHP_EOL;
        echo "Low needle, High haystack: " . (int)$lowHigh . PHP_EOL;
        echo "High needle, High haystack: " . (int)$highHigh . PHP_EOL;
      }

      return $result;
    }

    /**
     * @param string $needle
     * @param array $haystackArray
     * @param bool $debug
     *
     * @return bool
     
     */
    static public function IpInRange(string $needle, array $haystackArray, bool $debug = false): bool
    {
      $needle = IpFunctions::dtr_pton($needle);
      $lowHaystack = IpFunctions::dtr_pton($haystackArray[0]);
      $highHaystack = IpFunctions::dtr_pton($haystackArray[1]);
      $low = strcmp($needle, $lowHaystack) >= 0;
      $high = strcmp($needle, $highHaystack) <= 0;
      if ($debug)
      {
        MarkLine(__FUNCTION__);
        MarkLine(IpFunctions::dtr_ntop($needle));
        MarkLine(IpFunctions::dtr_ntop($lowHaystack));
        MarkLine(IpFunctions::dtr_ntop($highHaystack));
        echo "Needle, low haystack: " . (int)$low . PHP_EOL;
        echo "Needle, High haystack: " . (int)$high . PHP_EOL;
      }

      return $low && $high;
    }

    /**
     * @param string $needle
     * @param string $haystack
     * @param bool $debug
     *
     * @return bool
     
     */
    static public function IpIsIp(string $needle, string $haystack, bool $debug = false): bool
    {
      $needle = IpFunctions::dtr_pton($needle);
      $haystack = IpFunctions::dtr_pton($haystack);

      $result = strcmp($needle, $haystack) == 0;
      if ($debug)
      {
        MarkLine(__FUNCTION__);
        MarkLine(IpFunctions::dtr_ntop($needle));
        MarkLine(IpFunctions::dtr_ntop($haystack));
        echo "Needle, Haystack: " . (int)$result . PHP_EOL;
      }

      return $result;
    }

    /**
     * @param array $ipRanges
     * @param string $separator
     * @param bool $debug
     *
     * @return null|string
     
     */
    static public function GetIpRangeString(array $ipRanges, string $separator = ";", $debug = false)
    {
      if (count($ipRanges) == 0)
      {
        return null;
      }

      if ($debug)
      {
        MarkObject($ipRanges);
      }
      $compressedIps = is_array($ipRanges[0]) ? self::CompressIpRange($ipRanges, $debug) : $ipRanges;

      if ($debug)
      {
        MarkObject($compressedIps);
      }
      $ranges = [];
      foreach ($compressedIps as $range)
      {
        $ranges[] = is_array($range) ? implode("-", $range) : $range;
      }
      if ($debug)
      {
        MarkObject($ranges);
      }
      return implode($separator, $ranges);
    }

    /**
     * @param array $ipRanges
     * @param bool $debug
     *
     * @return array
     
     */
    static public function CompressIpRange(array $ipRanges, bool $debug = false, ZendLogger $logger = null): array
    {
      //TODO convert this to use an IpRangeIterator instead of array
      $currentStartBinary = "";
      $currentEndBinary = "";
      $nextStartBinary = "";
      $result = [];
      $counter = 0;
      $max = count($ipRanges);

      foreach ($ipRanges as $ipRange)
      {
        if($debug || ($logger && $logger->IsDebug))
        {
          MarkObject($ipRange);
        }
        $counter++;

        if ($counter == 1)
        {
          if($debug || ($logger && $logger->IsDebug))
          {
            MarkLine("Begin process", false);
          }
          $currentStartBinary = self::dtr_pton($ipRange[0]);
          $currentEndBinary = self::dtr_pton(isset($ipRange[1]) ? $ipRange[1] : $ipRange[0]);
          $nextStartBinary = $currentStartBinary; // marks this as an interior range to be compressed
        }

        if($debug || ($logger && $logger->IsDebug))
        {
          MarkLine("interior set", false);
        }
        $checkStartBinary = self::dtr_pton($ipRange[0]);
        if ($checkStartBinary != $nextStartBinary)
        {
          if($debug || ($logger && $logger->IsDebug))
          {
            MarkLine("non-contiguous range found", false);
          }
          $result[] = self::AddRange($currentStartBinary, $currentEndBinary);
          $currentStartBinary = self::dtr_pton($ipRange[0]);
        }
        elseif($debug || ($logger && $logger->IsDebug))
        {
          MarkLine("contiguous range found", false);
        }
        $currentEndBinary = self::dtr_pton(isset($ipRange[1]) ? $ipRange[1] : $ipRange[0]);
        $nextStartBinary = self::BinaryIncrement($currentEndBinary);
        if($debug || ($logger && $logger->IsDebug))
        {
          MarkLine("current end: " . self::dtr_ntop($currentEndBinary), false);
          MarkLine("next start: " . self::dtr_ntop($nextStartBinary), false);
        }

        if ($counter == $max)
        {
          if($debug || ($logger && $logger->IsDebug))
          {
            MarkLine("final set", false);
          }
          $currentEndBinary = self::dtr_pton(isset($ipRange[1]) ? $ipRange[1] : $ipRange[0]);
          $result[] = self::AddRange($currentStartBinary, $currentEndBinary);
        }

        if($debug || ($logger && $logger->IsDebug))
        {
          MarkObject($result, false);
        }
      }
      if($debug || ($logger && $logger->IsDebug))
      {
        MarkLine("All done!");
      }

      return $result;
    }

    /**
     * @param $currentStartBinary
     * @param $currentEndBinary
     *
     * @return array
     
     */
    static private function AddRange($currentStartBinary, $currentEndBinary): array
    {
      $currentStart = self::dtr_ntop($currentStartBinary);
      $currentEnd = self::dtr_ntop($currentEndBinary);
      switch (strcmp($currentStartBinary, $currentEndBinary))
      {
        case -1:
          return [$currentStart, $currentEnd];
        case 0:
          return [$currentStart];
        case 1:
        default:
          $errorText = "Unexpected string comparison value";
          MarkLine($errorText);
          MarkLine($currentStart, false);
          MarkLine($currentEnd, false);
          throw new \Exception($errorText);
      }
    }

    /**
     * Increments a binary string (default by 1)
     *
     * @param string $binaryIp
     * @param int $increment
     *
     * @return string
     */
    static private function BinaryIncrement(string $binaryIp, int $increment = 1)
    {
      $binaryIpArrayIn = str_split($binaryIp);
      $binaryIpArrayOut = [];
      $carry = $increment;
      foreach (array_reverse($binaryIpArrayIn) as $binaryByte)
      {
        $decIp = hexdec(bin2hex($binaryByte));
        $tempValue = $decIp + $carry;
        $tempValueHex = dechex($tempValue);
        if (strlen($tempValueHex) > 2)
        {
          $carryHex = str_pad(substr($tempValueHex, 0, 1), 2, '0', STR_PAD_LEFT);
          $tempResultHex = str_pad(substr($tempValueHex, 1, 2), 2, '0', STR_PAD_LEFT);
          $carry = hexdec($carryHex);
        }
        else
        {
          $carry = 0;
          $tempResultHex = str_pad($tempValueHex, 2, '0', STR_PAD_LEFT);
        }
        $binaryIpArrayOut[] = hex2bin($tempResultHex);
      }
      $binaryIpOut = implode(array_reverse($binaryIpArrayOut));

      return $binaryIpOut;
    }

    /**
     * Assumes that all ranges in the remove are subsets of the keep ranges
     * @param IpRangeIterator $ipKeep
     * @param IpRangeIterator $ipRemove
     * @param bool $debug
     * @param ZendLogger|null $logger
     *
     * @return IpRangeIterator
     
     */
    public static function RemoveRanges(IpRangeIterator $ipKeep, IpRangeIterator $ipRemove, bool $debug = false, ZendLogger $logger = null): IpRangeIterator
    {
      foreach ($ipKeep->GetSingleArray() as $ip)
      {
        $keep[] = self::dtr_pton($ip);
      }
      foreach ($ipRemove->GetSingleArray() as $ip)
      {
        $keep[] = self::dtr_pton($ip);
      }
      asort($keep);
      foreach ($keep as $ip)
      {
        $result[] = self::dtr_ntop($ip);
      }
      $output = IpRangeIterator::SingleArrayFactory($result, $debug, $logger);
      return $output;
    }

  }
}