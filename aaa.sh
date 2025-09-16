
set -e
set -x
CUR_DIR=$(cd "$(dirname "$0")";pwd)
CPU_COUNT=$(cat /proc/cpuinfo| grep "processor"| wc -l)
DEP=${COMPILE_SPEC}
lookupDir=""
#set target
function  set_target()
{
    ARCHI="$1"
}

function read_dir(){
    local append=""
    for file in `ls $1`
    do
        if [ -d $1"/"$file ]
        then
            read_dir $1"/"$file
        else
            append="-I$1/ "
        fi
    done
    lookupDir="$lookupDir$append"
}

function rebuild_export_compile_flags()
{
    lookupDir="export PNF_INCLUDE_FLAGS=\""
    myDir=${CUR_DIR}/deps/include
    read_dir $myDir
    lookupDir="$lookupDir\" "
    sed -i "s|^export PNF_INCLUDE_FLAGS.*|$lookupDir|g" ${CUR_DIR}/deps/export_compile_flags.sh
}

function build()
{
    pushd build
    if [ -d deps ]; then
        rm -rf deps
    fi
    pnftool build-dep -a "$ARCHI" -s ${DEP} -d true
    rm -rf ${CUR_DIR}/deps/lib/aarch64-linux-gnu/openssl
    popd
    rm -rf /data/bmk/output/rpmbuild/BUILD/bgp_benchmark-1.0.0/build/deps/lib/aarch64-linux-gnu/devm-board-rt-rootfs-usr-origin/libbootdrv.so
    rebuild_export_compile_flags
    source "${CUR_DIR}"/deps/export_compile_flags.sh
    source /opt/pdt-toolchains/setenv.sh "${ARCHI}"
    echo ${CUR_DIR}
    cmake -DCMAKE_TOOLCHAIN_FILE="$CUR_DIR"/../cmake/toolchain-"$ARCHI".cmake "$CUR_DIR"/../
    cd "$CUR_DIR"/../
    make -j"${CPU_COUNT}"
    cd -
}

function main()
{   
    set_target "$@"
    build
}

main "$@"
