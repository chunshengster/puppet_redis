class redis ($groupid = 0,$port=6379,$masterip='127.0.0.1') {
	package { "redis-server":
		name	=>'redis.x86_64',
		ensure	=> installed,
	}
	package {'python-redis':
		name	=> 'python-redis.noarch',
		ensure	=> installed,
	}

	#如果是第一组redis，则以下定义的redis service运行
	#if $groupid == 1{
		#$running_1 = 'running'
	#} elsif $groupid ==2  {
		##$running = 'stopped'
	#}
	notify{"groupid_$groupid":}
	$running_1 = $groupid ? {
		1	=> 'running',
		2	=> 'stopped',	
		undef	=> 'stopped'
	}
	notify{"running_1_$running_1":}

	redis::service_masterslave{ "redis_6379":
		port	=> 6379,
		masterip=>'172.16.2.5',
		ensure	=> $running_1
	}
	redis::service_masterslave{"redis_6380":
		port	=> 6380,
		masterip=>'172.16.2.5',
		ensure	=> $running_1
	}
	redis::service_masterslave{"redis_6381":
		port	=> 6381,
		masterip=> '172.16.2.7', 
		ensure	=> $running_1
	}
	redis::service_masterslave{"redis_6382":
		port	=> 6382,
		masterip=> '172.16.2.7' ,
		ensure	=> $running_1
	}
	#如果是第二组redis，则以下定义的redis service运行
	#if $groupid == 1{
		#$running = 'stopped'
	#}elsif $groupid ==2{
	$running_2 = $groupid ? {
		2	=> 'running',
		1	=> 'stopped',	
		undef	=> 'stopped'
	}
	notify{"groupid2_$groupid":}
	notify{"running_2_$running_2":}

	redis::service_masterslave{"redis_6383":
		port	=> 6383,
		masterip=> '172.16.2.4',
		ensure	=> $running_2
	}

	redis::service_masterslave{"redis_6384":
		port	=> 6384,
		masterip=> '172.16.2.4' ,
		ensure	=> $running_2
	}
	redis::service_masterslave{"redis_6385":
		port	=> 6385,
		masterip=> '172.16.2.6' ,
		ensure	=> $running_2
	}
	redis::service_masterslave{"redis_6386":
		port => 6386,
		masterip => '172.16.2.6' ,
		ensure	=> $running_2
	}

	$running_3 = $groupid ? {
		2	=> 'running',
		1	=> 'stopped',
		undef	=> 'stopped'
	}
	redis::service_standalone{"redis_6387":
		port	=> 6387,
		ensure	=> $running_3
	}
	
}
