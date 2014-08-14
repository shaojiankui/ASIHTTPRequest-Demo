<?php
date_default_timezone_set('HongKong');
ini_set("display_errors", 0);

$value = "my cookie value";
setcookie("TestCookie",$value);

$json_string = $_POST['jsonString'];
$json_string = utf8_encode($json_string);
//echo $json_string;
if(ini_get("magic_quotes_gpc")=="1")
{
    $json_string=stripslashes($json_string);
}
$obj = json_decode($json_string);
    
if($obj)    //对应IOS端    _sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
{
    if($obj->action =='userlist'){
        $user = array('a'=>1, 'b'=>2,'c'=>'I love you!','d'=>31343,'e'=>5);
        $post = json_encode($user);
        echo $post;
    }
}
else        //对应IOS端  _sharedClient.requestSerializer = [AFHTTPRequestSerializer serializer];
{
    $post = json_decode(file_get_contents('php://input'));
    if($post->action =='userlist'){
        $user = array('a'=>1, 'b'=>2,'c'=>'I love you!','d'=>31343,'e'=>5);
        $post = json_encode($user);
        echo $post;
    }
}
