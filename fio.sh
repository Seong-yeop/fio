#/bin/sh


dev=/mnt/rbd/
#bs=(4m)
#rw=( write read randwrite randread rw randrw )

rw=(write)
client=(28)
iodepth=(32)

sudo mkdir -p ./rbd_log
for i in "${client[@]}"
do
	for j in "${rw[@]}"
	do
		sudo sync
		sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'
		#sudo mkfs -t ext4 /dev/rbd0
		sudo fio --name=rbd-test --numjobs=${i} --directory=${dev} --size=50G --ioengine=sync --direct=1 --iodepth=32 --group_reporting --rw=${j} --bs=4m | sudo tee ./rbd_log/sync${j}_${i}.log
		#echo sudo fio --name=write --filename=${dev} --ioengine=libaio --direct=1 --iodepth=32 --runtime=180 --rw=${j} --bs=${i} | tee ${j}_${i}.log
		#exit
	done
done




rw=(randread)
client=(1 2 4 8 12 16 20 24 28)
iodepth=(32)

for i in "${client[@]}"
do
	for j in "${rw[@]}"
	do
		sudo sync
		sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'
		#sudo mkfs -t ext4 /dev/rbd0
		sudo fio --name=rbd-test --numjobs=${i} --directory=${dev} --size=50G --ioengine=sync --direct=1 --iodepth=32 --group_reporting --rw=${j} --bs=4m | sudo tee ./rbd_log/sync${j}_${i}.log
		#echo sudo fio --name=write --filename=${dev} --ioengine=libaio --direct=1 --iodepth=32 --runtime=180 --rw=${j} --bs=${i} | tee ${j}_${i}.log
		#exit
	done
done

