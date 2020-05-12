<?php 


// $tempDoc = new DOMDocument();
// $tempDoc->loadHTML($myStrinWithHTML);
// $p = $tempDoc->getElementsByTagName('p');
// $value =  $p[0]->nodeValue;

class RssReader {
    private static $endPointsRss = [
        "primitiva"=>"https://www.loteriasyapuestas.es/es/la-primitiva/botes/.formatoRSS",
        "euromillon"=>"https://www.loteriasyapuestas.es/es/euromillones/botes/.formatoRSS",
        "bonoloto"=>"https://www.loteriasyapuestas.es/es/bonoloto/botes/.formatoRSS",
        "quiniela"=>"https://www.loteriasyapuestas.es/es/la%2Dquiniela/botes/.formatoRSS",
        "quinigol"=>"https://www.loteriasyapuestas.es/es/el%2Dquinigol/botes/.formatoRSS",
        "lototurf"=>"https://www.loteriasyapuestas.es/es/lototurf/botes/.formatoRSS",
    ];
    
    public static $output = [
        "primitiva"=>[],
        "euromillon"=>[],
        "bonoloto"=>[],
        "quiniela"=>[],
        "quinigol"=>[],
        "lototurf"=>[],
    ];

    public static function readXML (){
        foreach (self::$endPointsRss as $key => $url) {
            $document = new DOMDocument();
            $document->load($url);
            $newBono = $document->getElementsByTagName("item");
        
            foreach ($newBono as $item) {
                $new = [];
                $new["title"]= $item->getElementsByTagName("title")[0]->nodeValue;
                $new["url"]= $item->getElementsByTagName("link")[0]->nodeValue;
                $new["pubDate"]= $item->getElementsByTagName("pubDate")[0]->nodeValue;
                $new["description"]= $item->getElementsByTagName("description")[0]->nodeValue;
        
                array_push(self::$output[$key], $new);
            }
        }
    }

    public static function setNewUrl ($key, $new){
        $key =  strval($key);
        $new =  urlencode(strval($new));
        self::$endPointsRss[$key] = $new;
    }

    public static function setDefaultURL (){
        self::$endPointsRss = [
            "primitiva"=>"https://www.loteriasyapuestas.es/es/la-primitiva/botes/.formatoRSS",
            "euromillon"=>"https://www.loteriasyapuestas.es/es/euromillones/botes/.formatoRSS",
            "bonoloto"=>"https://www.loteriasyapuestas.es/es/bonoloto/botes/.formatoRSS",
            "quiniela"=>"https://www.loteriasyapuestas.es/es/la%2Dquiniela/botes/.formatoRSS",
            "quinigol"=>"https://www.loteriasyapuestas.es/es/el%2Dquinigol/botes/.formatoRSS",
            "lototurf"=>"https://www.loteriasyapuestas.es/es/lototurf/botes/.formatoRSS",
        ];
    }

    public static function removeUrl ($key){
        unset(self::$endPointsRss[$key]);
    }

    public static function getXML (){
        return self::$output;
    }

}
