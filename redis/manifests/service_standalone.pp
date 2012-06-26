define redis::service_standalone(
        $port = '6379' ,
        $config_bind_device = 'em2' ,
        $config_loglevel = 'notice' ,
        $config_timeout = '300' ,
        $ensure = 'running',
        $masterip = '127.0.0.1'
){
  redis::service{"standalone_$port":
        port=>$port,
        is_master=>$is_master,
        masterip=>$masterip,
        ensure=>$ensure,
        ipaddress=>$ipaddress
        }
}
