<?php
$config_file = __DIR__ . "/webHosts.conf";
$host_file = "C:/Windows/System32/drivers/etc/hosts";
$ngnix_conf_dir = "C:/nginx/conf/vhost";
$end_tag = "\r\n";

$key = $argv[1];

switch($key) {
    case "-l":
        listHosts($config_file);
        break;
    case "create":
        if(!$argv[2] || !$argv[3]) {
            echo "missing host name or dir!" . $end_tag;
            exit;
        }
        createHost($config_file, $argv[2], $argv[3]);
        break;
    case "-d":
        if(!$argv[2]) {
            echo "missing host name" . $end_tag;
            exit;
        }
        delHost($config_file, $argv[2]);
        break;
    default:
        help();
}

function help() {
    global $end_tag;
    echo $end_tag;
    echo "-l list all created hosts!" . $end_tag;
    echo "create DOMAIN_NAME WEB_DIR" . $end_tag;
    echo "   create new host" . $end_tag;
    echo "-d DOMAIN_NAME" . $end_tag;
    echo "   delete a host" . $end_tag;
}
function listHosts($config_file) {
    global $end_tag;
    if(file_exists($config_file)) {
        $handle = @fopen($config_file, "r");
        echo "Current available hosts are:" . $end_tag;
        if ($handle) {
            while (!feof($handle)) {
                $buffer = fgets($handle, 4096);
                $str_arr = explode(" ", $buffer);
                echo $str_arr[0] . $end_tag;
            }
            fclose($handle);
        }
    }
}

function createHost($config_file, $host, $dir) {
    global $end_tag, $host_file, $ngnix_conf_dir;
    $host_arr = explode(":", $host);

    if(!file_exists($config_file)) {
        echo "config file is not exists!" . $end_tag;
        exit;
    }

    if(!file_exists($host_file)) {
        echo "host file is not exists!" . $end_tag;
        exit;
    }

    if(!file_exists(__DIR__ . "/template_file/host_temp.conf")) {
        echo "vhost template file is not find!" . $end_tag;
        exit;
    }

    $str = file_get_contents($config_file);
    if(!(stripos($str, $host_arr[0]) === false)) {
        echo "the host already created!";
        exit;
    }

    $str = file_get_contents(__DIR__ . "/template_file/host_temp.conf");
    $port = ($host_arr[1])?$host_arr[1]:80;
    $dir = str_replace("\\", "/", $dir);

    $str = str_replace("{port}", $port, $str);
    $str = str_replace("{domain}", $host_arr[0], $str);
    $str = str_replace("{dir}", $dir, $str);

    try{
        $fp = @fopen($ngnix_conf_dir . "/" .$host_arr[0].".conf", "w");
        fwrite($fp, $str);
        fclose($fp);
    }catch(Exception $e) {
        echo "ngnix vhost dir can't create new file!". $end_tag;
        exit;
    }

    try{
        $handle = @fopen($host_file, "r");
        if ($handle) {
            while (!feof($handle)) {
                $b_t = trim(fgets($handle, 4096));
                if(!$b_t)
                    continue;
                $buffer[] = $b_t;
            }
            fclose($handle);
        }
        $fp = @fopen($host_file, "w");
        $buffer[] = "127.0.0.1 " . $host_arr[0];
        foreach($buffer as $v) {
            fwrite($fp, $v . $end_tag);
        }
        fclose($fp);
    }catch(Exception $e) {
        echo "the host file can write!". $end_tag;
        @unlink($ngnix_conf_dir . "/" .$host_arr[0].".conf");
        exit;
    }

    $handle = @fopen($config_file, "r");
    if ($handle) {
        while (!feof($handle)) {
            $b_t = trim(fgets($handle, 4096));
            if(!$b_t)
                continue;
            $buffer_c[] = $b_t;
        }
        fclose($handle);
    }
    $fp = @fopen($config_file, "w");
    $buffer_c[] = $host_arr[0] . " " . $dir;
    foreach($buffer_c as $v) {
        fwrite($fp, $v . $end_tag);
    }
    fclose($fp);

    echo "create local host " . $host_arr[0] . " success!" . $end_tag;
}

function delHost($config_file, $host) {
    global $end_tag, $host_file, $ngnix_conf_dir;

    if(!file_exists($config_file)) {
        echo "config file is not exists!" . $end_tag;
        exit;
    }

    if(!file_exists($host_file)) {
        echo "host file is not exists!" . $end_tag;
        exit;
    }

    try{
        $handle = @fopen($config_file, "r");
        $host_exists = false;
        if ($handle) {
            while (!feof($handle)) {
                $buffer = trim(fgets($handle, 4096));
                $buffer_arr = explode(" ", $buffer);
                if($buffer_arr[0] != $host) {
                    if(!$buffer)
                        continue;
                    $b_c[] = $buffer;
                }else {
                    $host_exists = true;
                }
            }
            fclose($handle);
        }
        if(!$host_exists) {
            echo "the host is not created!" . $end_tag;
            exit;
        }

        $fp = @fopen($config_file, "w");
        foreach($b_c as $v) {
            fwrite($fp, $v . $end_tag);
        }
        fclose($fp);
    }catch(Exception $e) {
        echo "the config file can write!". $end_tag;
        exit;
    }

    try{
        $handle = @fopen($host_file, "r");
        if ($handle) {
            while (!feof($handle)) {
                $buffer = trim(fgets($handle, 4096));
                $buffer_arr = explode(" ", $buffer);
                $pp = false;
                for($i=0;$i<count($buffer_arr);$i++) {
                    if($buffer_arr[$i] == $host) {
                        $pp = true;
                        break;
                    }
                }

                if(!$pp) {
                    if(!$buffer)
                        continue;
                    $b[] = $buffer;
                }
            }
            fclose($handle);
        }
        $fp = @fopen($host_file, "w");
        foreach($b as $v) {
            fwrite($fp, $v . $end_tag);
        }
        fclose($fp);
    }catch(Exception $e) {
        echo "the host file can write!". $end_tag;
        exit;
    }

    @unlink($ngnix_conf_dir . "/" .$host.".conf");

    echo "delete host " . $host . " success!" . $end_tag;
}