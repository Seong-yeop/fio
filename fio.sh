#/bin/sh

dev=/dev/nvme0n1p1
bs=( 4k 8k 16k 32k 64k 128k 256k 512k 1m 2m 4m )
#rw=( write read randwrite randread rw randrw )
rw=( read write )
iodepth=( 1 2 4 8 16 32 )

sudo mkdir -p ./log
for i in "${bs[@]}"
do
	for j in "${rw[@]}"
	do
		sudo sync
		sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'
		sudo nvme format $dev
		sudo fio --name=write --filename=${dev} --ioengine=libaio --direct=1 --iodepth=32 --runtime=180 --rw=${j} --bs=${i} | tee ./log/${j}_${i}.log
		#echo sudo fio --name=write --filename=${dev} --ioengine=libaio --direct=1 --iodepth=32 --runtime=180 --rw=${j} --bs=${i} | tee ${j}_${i}.log
		#exit
	done
done

:<<END
#for i in "${iodepth[@]}"
for i in 1
do
	for j in read write
	do
		sudo sync
		sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'
		sudo nvme format $dev
		sudo fio --name=write --filename=${dev} --ioengine=libaio --direct=1 --iodepth=${i} --runtime=180 --rw=${j} --bs=4k | tee ${j}_${i}.log
		#echo sudo fio --name=write --filename=${dev} --ioengine=libaio --direct=1 --iodepth=${i} --runtime=180 --rw=${j} --bs=4k | tee ${j}_${i}.log
		#exit
	done
done
END
