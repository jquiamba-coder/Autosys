<?php
namespace GY\Common\Lib\Goodyear
{

  /**
   * Class XmlFunctions
   *
   * @package GY\Common\Lib\Goodyear
   */
  final class XmlFunctions
  {
    /**
     * Cleans XML to remove CDATA info and return that actual value(s)
     *
     * @param string $string
     *
     * @return string
     */
    static function ExposeCdata(string $string) : string
    {
      $pattern = "/\<!\[CDATA\[([^\]]*)\]\]\>/im";
      $replace = "$1";

      return preg_replace_callback($pattern, function($matches) use ($pattern, $replace)
      {
        $item = $matches[0];
        $item = preg_replace($pattern, $replace, $item);
        $item = self::ChangeAmpersands($item);
        return $item;
      }, $string);
    }

    /**
     * Remove XML tags leaving only the value(s).
     *
     * @param string $string
     * @param string $tagName
     *
     * @return mixed
     */
    public static function RemoveTag(string $string, string $tagName)
    {
      $pattern = "/\<\/{0,1}" . $tagName . "[^\>]*\>/im";
      $replace = "";

      return preg_replace($pattern, $replace, $string);
    }

    /**
     * Recursively walks through the array and builds the XML element from it.
     * NOTE -- This will not work for creating XML tags with attributes
     *
     * @param \SimpleXMLElement $xml
     * @param array $arrName
     *
     * @return \SimpleXMLElement
     */
    static public function ArrayToXML(\SimpleXMLElement $xml, array $arrName) : \SimpleXMLElement
    {
      foreach ($arrName as $key => $value) {
        if (is_array($value)) {
          $child = $xml->addChild($key);
          self::ArrayToXML($child, $value);
        } else {
          $xml->addChild($key, $value);
        }
      }
      return $xml;
    }

    /**
     * converts "& " to "&amp; " within the value of an XML tag
     *
     * @param $response
     *
     * @return null|string|string[]
     */
    public static function ChangeAmpersands($response)
    {
      $response = preg_replace("/\&(?!amp;)/", "&amp;", $response);
      MarkLine($response);
      if (StringFunctions::Contains($response, "&")) {
        exit;
      }
      return $response;
    }

  }
}