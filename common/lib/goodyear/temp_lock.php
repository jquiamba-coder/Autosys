<?php
namespace GY\Core\Logic
{

  /**
   * Class Lock
   * this file is only here to make sure the lib stuff can find it on the linux systems where the folders are all over the place instead of matching the layout in the repository.
   * Once that problem is fixed, then this version of the file can be deleted and the fle in the correct namespace location can be retained.
   *
   * @package GY\Common\Lib\Goodyear
   */
  class Lock
  {
    const WINDOWS = 0;
    const LINUX = 1;
    private $_os = 0; // this means windows

    public function __construct()
    {
      $this->_os = strtolower(substr(PHP_OS, 0, 3)) == "win" ? self::WINDOWS : self::LINUX;
    }

    /**
     * @param string $search
     * @param int $minutes
     *
     * @throws \Exception
     */
    function killOldProcesses($search, $minutes)
    {
      //echo __FILE__ . ":" . __LINE__ . PHP_EOL;
      $result = $this->getProcesses($search);
      //echo __FILE__ . ":" . __LINE__ . PHP_EOL;
      //print_r($result);
      //echo PHP_EOL;

      foreach ($result as $pid => $age) {
        //echo __FILE__ . ":" . __LINE__ . PHP_EOL;
        //echo "$pid => $age" . PHP_EOL;
        if ($age >= $minutes) {
          $this->killProcess($pid);
        }
      }
    }

    /**
     * @param $search
     *
     * @return array
     * @throws \Exception
     */
    public function getProcesses($search)
    {
      switch ($this->_os) {
        case self::WINDOWS:
          $result = $this->getWindowsProcesses($search);
          break;
        case self::LINUX:
          $result = $this->getLinuxProcesses($search);
          break;
      }
      return $result;
    }

    /**
     * @param string $search
     *
     * @return array
     * @throws \Exception
     */
    private function getWindowsProcesses($search)
    {
      $date = "CreationDate";
      $pid = "ProcessId";
      $cmd = "wmic process where (Caption = \"php.exe\" AND CommandLine like \"%$search%\") get $date, $pid";
      exec($cmd, $output, $returnVal2);

      $result = [];
      if (count($output) > 0) {
        //print_r($output);
        //echo PHP_EOL;
        // line 1 is the headers, so pull out the length of each chunk from it
        $header = array_shift($output);
        $indexCreationDate = stripos($header, $date);
        $indexProcessId = stripos($header, $pid);

        $compare = new \DateTime(gmdate('c'));
        foreach ($output as $item) {
          if (trim($item)) {
            $pid = trim(substr($item, $indexProcessId));
            $age = $this->getWindowsProcessMinutes(trim(substr($item, $indexCreationDate, $indexProcessId - $indexCreationDate)), $compare);
            $result[$pid] = $age;
          }
        }
      }
      return $result;
    }

    /**
     * @param string $winString
     * @param \DateTime $compare
     *
     * @return float|int
     * @throws \Exception
     */
    private function getWindowsProcessMinutes($winString, $compare)
    {
      $subtract = true;
      if (strpos($winString, "-")) {
        $time = explode("-", $winString);
        $subtract = false;
      } elseif (strpos($winString, "+")) {
        $time = explode("+", $winString);
      } else {
        $time = [$winString, 0];
      }

      $date = \DateTime::createFromFormat("YmdHis.u", $time[0], new \DateTimeZone("+00:00"));
      $interval = new \DateInterval("PT" . $time[1] . "M");
      if ($subtract) {
        $date->sub($interval);
      } else {
        $date->add($interval);
      }

      $diff = $compare->getTimestamp() - $date->getTimestamp();
      return $diff / 60;
    }

    /**
     * @param $search
     *
     * @return array
     * @throws \Exception
     */
    private function getLinuxProcesses($search)
    {
      $cmd = "ps -o pid,etime,command -C \"php\" --no-heading";
      //echo __FILE__ . ":" . __LINE__ . PHP_EOL;
      //echo $cmd . PHP_EOL;
      //echo __FILE__ . ":" . __LINE__ . PHP_EOL;
      exec($cmd, $output, $returnVal);
      //echo __FILE__ . ":" . __LINE__ . PHP_EOL;
      //print_r($output);
      //echo PHP_EOL;

      if ($returnVal !== 0) {
        throw new \RuntimeException('Command "' . $cmd . '" did not execute successfully');
      }

      $result = [];
      if (count($output) > 0) {
        //print_r($output);
        //echo PHP_EOL;

        foreach ($output as $item) {
          if (trim($item)) {
            $info = array_filter(explode(" ", $item));
            $pid = array_shift($info);
            $age = $this->getLinuxProcessMinutes(array_shift($info));
            $command = implode(" ", $info);
            //print $command . PHP_EOL;
            if (stripos($command, $search)) {
              $result[$pid] = $age;
            }
          }
        }
      }
      //echo __FILE__ . ":" . __LINE__ . PHP_EOL;
      //print_r($result);
      //echo PHP_EOL;
      return $result;
    }

    /**
     * @param string $winString
     * @param \DateTime $compare
     *
     * @return float|int
     * @throws \Exception
     */
    private function getLinuxProcessMinutes($linString)
    {
      $time = array_reverse(preg_split("/[-:]/", $linString));
      $hours = 0;
      $hours += abs(count($time) > 0 ? array_shift($time) : 0) / 60;
      $hours += abs(count($time) > 0 ? array_shift($time) : 0);
      $hours += abs(count($time) > 0 ? array_shift($time) : 0) * 60;
      $hours += abs(count($time) > 0 ? array_shift($time) : 0) * 24 * 60;
      return $hours;
    }

    /**
     * @param $pid
     *
     * @return bool
     */
    public function killProcess($pid)
    {
      if ($pid === false) {
        return false;
      }

      if ($this->_os == self::WINDOWS) {
        $cmd = 'taskkill /PID ' . $pid;
      } elseif ($this->_os == self::LINUX) {
        $cmd = 'kill -9 ' . $pid . ' 2>&1';
      }

      exec($cmd, $output, $returnVal);

      if ($returnVal !== 0) {
        throw new \RuntimeException('Command `' . $cmd . ' did not execute successfully');
      }

      return true;
    }

  }
}