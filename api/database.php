<?php

class Database
{
	 private $host = 'host';
	 private $user = 'username';
	 private $db = 'database';
	 private $pass = 'password';
	 private $conn;

    public function __construct() 
    {
        $this->conn = new PDO("mysql:host=" . $this->host . ";dbname=" . $this->db, $this->user, $this->pass);
    }

    public function insertUserData($name, $email, $password)
    {
        $hash = $this->getHash($password);
        $password = $hash["encrypted"];
        $salt = $hash["salt"];

        $sql = 'INSERT INTO users SET name=:name, email=:email, password=:password, salt=:salt, created_at=NOW()';

        $query = $this->conn ->prepare($sql);
        $query->execute(array(':name' => $name, ':email' => $email, ':password' => $password, ':salt' => $salt));

        if ($query) 
            return true;
        else 
            return false;
    }

    public function checkLogin($email, $password) 
    {
        $sql = 'SELECT * FROM users WHERE email=:email';
        $query = $this->conn->prepare($sql);
        $query->execute(array(':email' => $email));
        $data = $query->fetchObject();
        $salt = $data->salt;
        $db_password = $data->password;

        if ($this->verifyHash($password.$salt, $db_password) ) 
        {
            $user["id"] = $data->id;
            $user["name"] = $data->name;
            $user["email"] = $data->email;
            return $user;
        } 
        else 
            return false;
    }

    public function changePassword($email, $password)
    {
        $hash = $this->getHash($password);
        $password = $hash["encrypted"];
        $salt = $hash["salt"];

        $sql = 'UPDATE users SET password=:password, salt=:salt WHERE email=:email';
        $query = $this->conn->prepare($sql);
        $query->execute(array(':email' => $email, ':password' => $password, ':salt' => $salt));

        if ($query) 
            return true;
        else 
            return false;
    }

    public function checkUserExist($email)
    {
        $sql = 'SELECT COUNT(*) from users WHERE email=:email';
        $query = $this->conn->prepare($sql);
        $query->execute(array('email' => $email));

        if($query)
        {
            $row_count = $query->fetchColumn();
            if ($row_count == 0) 
                return false;
            else 
                return true;
        } 
        else 
            return false;
    }

    public function getHash($password) 
    {
        $salt = sha1(rand());
        $salt = substr($salt, 0, 10);
        $encrypted = password_hash($password.$salt, PASSWORD_DEFAULT);
        $hash = array("salt" => $salt, "encrypted" => $encrypted);
        return $hash;
    }

    public function verifyHash($password, $hash) 
    {
        return password_verify ($password, $hash);
    }
}
