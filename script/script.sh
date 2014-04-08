echo $1;
echo $2;
echo $3;
echo $4;

count=0;

for apk in `find $1 -type f -exec echo "{}" \;`
do
	size=`ls -l $apk | awk '{ print $6 }'`

	if (( size <= $3 )); then
		echo $size
		if (( size > $2 )); then
			count=$(( count+1 ));
			cp $apk $4/$count.apk
			echo "$size:$apk"

		fi
	fi
done



#! /usr/bin/python
import sys
import os
import shutil
import zipfile

srcDir=sys.argv[1]
destDir=sys.argv[2]
minSize=sys.argv[3]
maxSize=sys.argv[4]

if minSize == "0":
	minSize = 0

count = 1 

def traverseDir( path ):
	global count
	for (dirpath, dirnames, filenames) in os.walk(path):
		for filename in filenames:
			filepath = dirpath + "/" + filename
			if not zipfile.is_zipfile(filepath):
				continue
			if count >= 1000:
				sys.exit(0)
			destFilepath = destDir + "/{}.apk".format(count);
			zf = zipfile.ZipFile(filepath, 'r')
			size = zf.getinfo('classes.dex').file_size
			zf.close()
			if int(size) <= int(maxSize):
				print str(size) + ":" + str(maxSize)
				if int(size) >= int(minSize):
					shutil.copy2(filepath, destFilepath)
					count = count + 1
	return


traverseDir( srcDir )