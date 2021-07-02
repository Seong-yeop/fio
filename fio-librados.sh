#/bin/sh


:<<'END'
rw=(write)
client=(28)

sudo mkdir -p ./log
for i in "${client[@]}"
do
	for j in "${rw[@]}"
	do
		# sudo sync
		sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'
		#sudo mkfs -t ext4 /dev/rbd0
		sudo fio --name=librados-test --numjobs=${i}  --size=50G --ioengine=rados --direct=1  --group_reporting --pool=librados_bench --clientname=admin --busy_poll=0 --rw=${j} --bs=4m --nr_files=32 | sudo tee ./log/sync${j}_${i}.log
	done
done
END

rw=(randread)
client=(1)

sudo mkdir -p ./log
for i in "${client[@]}"
do
	for j in "${rw[@]}"
	do
		# sudo sync
		sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'
		#sudo mkfs -t ext4 /dev/rbd0
		sudo fio --name=librados-test --numjobs=${i}  --size=50G --nr_files=1 --ioengine=rados --direct=1  --group_reporting --pool=librados_bench --clientname=admin --busy_poll=0 --rw=${j} --bs=4m | sudo tee ./log/sync${j}_${i}.log
	done
done

