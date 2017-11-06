<?php
//    session_start();

    $usn        = "yourUserName";
    $pwd        = "yourPassword";
    $host       = "usually is localhost";
    $db         = "yourDataBaseName";
    $mainDB     = "yourDataBaseName";

    try {
        $dsn    = "mysql:host = $host; dbname = $db";
        $conn = new PDO($dsn, $usn, $pwd);
        
        // configured to expect UTF-8 encoding
        $conn->query("set names 'utf8'");
        $conn->query("use $mainDB");
    } catch (PDOException $pe){
        die('Could not connect to the database because: ' .
            $pe->getMessage());
    }
    

    // teacher set this part in class_session
      
//if(!$connection){
//    echo "Connection failed";
//}else{
//    echo "success";
//}

    function showHeader($title){

?>

  <html>
        <head>
            <title><?=htmlspecialchars($title)?></title>
        </head>
        <body>
            <h1> <?=htmlspecialchars($title)?> </h1>
<?php
                               }
    function showFooter(){
        
?>
        </body>
    </html>

<?php
    }
?>


