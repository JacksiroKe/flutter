<?php

require_once 'flutterme.php';

$flutterme = new FlutterMe();

if ($_SERVER['REQUEST_METHOD'] == 'POST')
{
  $data = json_decode(file_get_contents("php://input"));

  if(isset($data->operation)){
  	$operation = $data->operation;

  	if(!empty($operation)){

  		if($operation == 'register'){
  			if(isset($data->user ) && !empty($data->user) && isset($data->user->name) && isset($data->user->email) && isset($data->user->password))
        {
  				$user = $data->user;
  				$name = $user->name;
  				$email = $user->email;
  				$password = $user->password;

          if ($flutterme->isEmailValid($email)) 
            echo $flutterme->registerUser($name, $email, $password);
          else 
            echo $flutterme->getMsgInvalidEmail();
        } 
        else 
          echo $flutterme->getMsgInvalidParam();
      }
      else if ($operation == 'login') 
      {
        if(isset($data->user ) && !empty($data->user) && isset($data->user->email) && isset($data->user->password))
        {
          $user = $data->user;
          $email = $user->email;
          $password = $user->password;
          echo $flutterme->loginUser($email, $password);
        } 
        else 
          echo $flutterme->getMsgInvalidParam();
      } 
      else if ($operation == 'chgPass') {
        if(isset($data->user ) && !empty($data->user) && isset($data->user->email) && isset($data->user->old_password) && isset($data->user->new_password))
        {
          $user = $data->user;
          $email = $user->email;
          $old_password = $user->old_password;
          $new_password = $user->new_password;

          echo $flutterme->changePassword($email, $old_password, $new_password);
        }
        else 
          echo $flutterme->getMsgInvalidParam();
      }
    }
    else 
      echo $flutterme->getMsgParamNotEmpty();
  } 
  else 
    echo $flutterme->getMsgInvalidParam();
} 
else if ($_SERVER['REQUEST_METHOD'] == 'GET')
  echo "Flutter Me API";
