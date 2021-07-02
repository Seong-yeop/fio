#/bin/sh

dev=/my-new-bucket1/abcd
#bs=(4m)
#rw=( write read randwrite randread rw randrw )

rw=(write)
client=(1)

sudo mkdir -p ./log
for i in "${client[@]}"
do
	for j in "${rw[@]}"
	do
		#sudo sync
		sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'
		#sudo mkfs -t ext4 /dev/rbd0
		sudo fio --name=s3-test --ioengine=http --numjobs=${i} --filename=${dev} --size=100G  --iodepth=32 --https=off --http_mode=s3 --http_s3_key=csl --http_s3_keyid=csl --http_host=172.31.15.150:7480 --direct=1  --group_reporting --rw=${j} --bs=4m | sudo tee ./log/${j}_${i}.log
		#echo sudo fio --name=write --filename=${dev} --ioengine=libaio --direct=1 --iodepth=32 --runtime=180 --rw=${j} --bs=${i} | tee ${j}_${i}.log
		#exit
	done
done

