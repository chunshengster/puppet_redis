#require 'facter/util/ip'
#define redis::service_standalone(
#        $port = '6379' ,
#        $config_bind_device = 'em2' ,
#        $config_loglevel = 'notice' ,
#        $config_timeout = '300' ,
#        $ensure = 'running',
#        $masterip = '127.0.0.1'
#){
#  redis::service{
#	port=>$port,
#	is_master=>$is_master,
#	masterip=>$masterip,
#	ensure=>$ensure,
#	ipaddress=>$ipaddress
#	}
#}
#define redis::service_masterslave(
#    	$port = '6379' , 
#	$config_bind_device = 'em2' , 
#	$config_loglevel = 'notice' , 
#	$config_timeout = '300' , 
#	$ensure = 'running',
#	$masterip = '127.0.0.1'
#) { 
# 
#  $net = "ipaddress_${config_bind_device}"
#  $ipaddress = inline_template("<%= scope.lookupvar(net) %>")
#
#  if $ipaddress==$masterip{
#	$is_master = true
#	#notify{"$is_master":;}
#  }else{
#	$is_master = false
#  }
#  redis::service{
#	port=>$port,
#	is_master=>$is_master,
#	masterip=>$masterip,
#	ensure=>$ensure,
#	ipaddress=>$ipaddress
#	}
#}

define redis::service(
	$port  = '6379',
	$is_master = true,
	$masterip  = '127.0.0.1',
	$ensure	   = 'stopped',
	$ipaddress = '127.0.0.1'
){
  file { "redis_dir_${port}":
	ensure => directory,		
	path	=> "/data/redis_${port}",
	mode   => 755,
        group  => 'redis',
	owner  => 'redis'
  }

  file { "redis_config_${port}": 
	ensure    => file , 
	path      => "/data/redis_${port}/redis_${port}.conf" , 
	content   => $is_master ? { 
			true => template("${module_name}/master.redis.conf.erb") , 
			false=> template("${module_name}/slave.redis.conf.erb"),
			undef=> template("${module_name}/slave.redis.conf.erb")
			},
	require   => File["redis_dir_${port}"]
	#require   => [Class['redis'],File["redis_dir_${port}"]]
  }

  #file { "redis_logfile_${port}":
	#ensure    => file , 
	#path      => "/data/redis_${port}/redis-${port}.log" , 
	#require   => File["redis_dir_${port}"],
	#group     => 'redis' , 
	#owner     => 'redis'
  #}

  file { "redis_upstart_${port}": 
	ensure    => file , 
	path      => "/etc/init.d/redis_$port",
	content   => template("${module_name}/redis.server.erb") , 
	require   => File["redis_dir_${port}"],
	#require   => [Class['redis'],File["redis_dir_${port}"]],
	mode	=> 755
  }


  service { "redis_${port}":
	ensure    => $ensure , 
	path	 => "/etc/init.d/redis_${port}",
	subscribe	=> File["redis_config_${port}"],
	provider  => 'redhat' , 
	require   => [  File["redis_upstart_${port}"] , 
			File["redis_config_${port}"] ],
	start	=> "/etc/init.d/redis_${port} start",
	stop	=> "/etc/init.d/redis_${port} stop",
	restart	=> "/etc/init.d/redis_${port} restart",
	status	=> "/etc/init.d/redis_${port} status"
  }
}
