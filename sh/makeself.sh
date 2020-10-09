
script_path=$0
script_dir=`dirname $0`


make_entry_shell()
{
	pack_checksum=`md5sum $1 | cut -d' ' -f1`
	pack_filesize=`ls -l $1 | awk '{print $5}'`

	echo "pack_checksum=${pack_checksum}"
	echo "pack_filesize=${pack_filesize}"
	echo 'set -e
	tmp_dir=/tmp/${USER}/$$
	mkdir -p ${tmp_dir}
	echo "extract to ${tmp_dir} ..."
	tail -c ${pack_filesize} $0 > ${tmp_dir}/pack.tar.gz
	tmp_checksum=`md5sum ${tmp_dir}/pack.tar.gz | cut -d" " -f1`
	[ x"${pack_checksum}" = x"${tmp_checksum}" ] || exit 1
	mkdir -p ${tmp_dir}/pack
	cd ${tmp_dir}/pack
	tar xvf ../pack.tar.gz
	cd -
	sh ${tmp_dir}/pack/run.sh $@
	exit 0
	'
}

if [ x"$1" = x"" ] || [ x"$2" = x"" ]; then
	echo "usage:"
	echo "  $0 dst_file src_dir"
	exit 0
fi

src_dir=$2
dst_file=$1
tmp_dir=/tmp/${USER}/$$
pack_file=pack.tar.gz

rm -fr ${tmp_dir}
mkdir -p ${tmp_dir}

cd ${src_dir}
tar zcvf ${tmp_dir}/${pack_file} *
cd -

cd ${tmp_dir}
make_entry_shell ${pack_file} > self.run
cat ${pack_file} >> self.run
chmod +x self.run
cd -

mv ${tmp_dir}/self.run ${dst_file}
rm -fr ${tmp_dir}
