define redis::service_masterslave(
        $port = '6379' ,
        $config_bind_device = 'em2' ,
        $config_loglevel = 'notice' ,
        $config_timeout = '300' ,
        $ensure = 'running',
        $masterip = '127.0.0.1'
) {

  $net = "ipaddress_${config_bind_device}"
  $ipaddress = inline_template("<%= scope.lookupvar(net) %>")

  if $ipaddress==$masterip{
        $is_master = true
        #notify{"$is_master":;}
  }else{
        $is_master = false
  }
  redis::service{"ms_service_$port":
        port=>$port,
        is_master=>$is_master,
        masterip=>$masterip,
        ensure=>$ensure,
        ipaddress=>$ipaddress
        }
}
