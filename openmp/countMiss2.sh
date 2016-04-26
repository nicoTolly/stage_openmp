for i in {1..20} 
do
	echo 'processing iteration' $i
	perf stat -e cache-misses timeout 10 ./example 2>&1 > /dev/null | grep cache-misses \
		| python getNumber.py
done
