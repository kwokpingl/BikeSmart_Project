<?php
    include 'Bike_Php/data.php';
    
    // Types include : UBike (includs IBike), KBike, PBike, TBike, EBike
    
    // $data = > ("type"=>(KBike, UBike, ...))

    $data       = $HTTP_RAW_POST_DATA;      //This feature was DEPRECATED in PHP 5.6.0, and REMOVED as of PHP 7.0.0.
    $array      = json_decode($data, true);
    $dataArray  = $array["data"];
    $types      = $dataArray['types'];
    $result     = array();
    $succKey    = "isSuccess";
    $rsltKey    = "data";
    $errKey     = "error";


    if ($data != null and count($types) > 0) {
        
        $finalData = array();
        
        foreach ($types as $type) { 
        
            $q      = $conn->query("SELECT * FROM $type");

            /*
            PDO::query() returns a PDOStatement object, or FALSE on failure.

            If you do not fetch all of the data in a result set before issuing your next call to PDO::query(), your call may fail. Call PDOStatement::closeCursor() to release the database resources associated with the PDOStatement object before issuing your next call to PDO::query().
            */

            if (!$q) {

                $ei = $conn->errorInfo();
                
                $result["$succKey"] = false;
                $result["$rsltKey"] = array();
                $result["$errKey"]  = "$ei[2]";
                
                echo json_encode($result);
//                die("Could not execute query because: " . $ei[2]);

            }
//
            $data               = $q->fetchAll(PDO::FETCH_ASSOC);
            $finalData["$type"]    = $data;
        }
        
        $result["$succKey"] = true;
        $result["$rsltKey"] = $finalData;
        
        echo json_encode($result);
        
    } elseif ($data != null and count($types) <= 0) {
        
        $result["$succKey"] = false;
        $result["$rsltKey"] = array();
        $result["$errKey"]  = "ERROR: Empty Input";

        echo json_encode($result);
    } else {
//        showHeader("It's Not Me, It's You");
//        showFooter();
        
    }
    
    
    
?>