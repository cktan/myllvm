set -e 

function fatal
{
   echo 
   echo FATAL: "$@"
   echo
   exit 1
}

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LLVMSRC=llvm-15.0.7.src
OPTDIR=$DIR/llvm-15-release
DEVDIR=$DIR/llvm-15-release+assert

TARGET=$(python3 -c 'import platform; print(platform.processor())')

case $TARGET in 

    arm) 
	TARGET="AArch64"
	;;

    x86_64)
	TARGET="X86"
	;;

    *)
	fatal architecture not supported: $TARGET
	;;
esac
echo TARGET is $TARGET

rm -rf cmake cmake-15.0.7.src 2> /dev/null
tar xf cmake-15.0.7.src.tar.xz
mv cmake-15.0.7.src cmake

if [ $1 == "dev" ]; then 
    ##########################
    # assert on
    echo Building DEV in $DEVDIR
    (rm -rf $LLVMSRC && tar xf $LLVMSRC.tar.xz &&
	cd $LLVMSRC &&
	mkdir build && 
	cd build &&
		CC=gcc-11 CXX=g++-11 cmake -G 'Unix Makefiles' -DCMAKE_INSTALL_PREFIX=$DEVDIR \
			-DLLVM_INCLUDE_BENCHMARKS=OFF \
			-DCMAKE_BUILD_TYPE=Release \
			-DCMAKE_CXX_STANDARD=17 \
			-DLLVM_TARGETS_TO_BUILD=$TARGET \
			-DLLVM_ENABLE_ASSERTIONS=On \
			.. &&
	(make -j8 || make -j8 || make -j4 || make) && make install)  || fatal $DEVDIR
elif [ $1 == "opt" ]; then 
    ##########################
    # assert off
    echo Building OPT in $OPTDIR
    (rm -rf $LLVMSRC && tar xf $LLVMSRC.tar.xz &&
	cd $LLVMSRC &&
	mkdir build &&
	cd build &&
		CC=gcc-11 CXX=g++-11 cmake -G 'Unix Makefiles' -DCMAKE_INSTALL_PREFIX=$OPTDIR \
			-DLLVM_INCLUDE_BENCHMARKS=OFF \
			-DCMAKE_BUILD_TYPE=Release \
			-DCMAKE_CXX_STANDARD=17 \
			-DLLVM_TARGETS_TO_BUILD=$TARGET \
			-DLLVM_ENABLE_ASSERTIONS=Off \
			.. &&
	(make -j8 || make -j8 || make -j4 || make) && make install) || fatal $OPTDIR
else
    fatal "usage: $0 {opt|dev}"
fi

echo
echo SUCCESS
