#!/bin/bash
# Avaliable environment:
#
# Download variable:
# WEB_URL=
#BRANCH="master"
#GIT_URL=
#DEP_PKG_LIST="gcc gcc-c++ tk expectk"

if [[ $(grep ID_LIKE /etc/os-release | grep debian) ]] ; then
    DEP_PKG_LIST="build-essential python3 tclsh cmake"
    sudo apt-get install -y ${DEP_PKG_LIST}
    sudo bash -c "cd /bin ; rm -rf sh ; ln -s bash sh"
elif [[ $(grep ID_LIKE /etc/os-release | grep -E "(centos)|(fedora)") ]] || [[ $(grep -E "(ID_LIKE)|(PRETTY_NAME)" /etc/os-release | grep -i anolis) ]] ; then
    sudo yum groupinstall -y 'Development tools'
    DEP_PKG_LIST="python3 tcl cmake libstdc++*"
    sudo yum install -y ${DEP_PKG_LIST}
fi

set_env_from_install()
{
    cd ${TONE_BM_RUN_DIR}/
    rm -rf ${TONE_BM_RUN_DIR}/.shrc
    echo "export TONE_USER=$TONE_USER" >> ${TONE_BM_RUN_DIR}/.shrc
    echo "export TONE_PASS=$TONE_PASS" >> ${TONE_BM_RUN_DIR}/.shrc
    sed -i "s|(|\\\\(|g" ${TONE_BM_RUN_DIR}/.shrc
    sed -i "s|)|\\\\)|g" ${TONE_BM_RUN_DIR}/.shrc
}

buildCompiler()
{
    :
}

installCompiler()
{
    . ${TONE_ROOT}/tone-matrix-compiler/common/common.sh
    logger "set_env_from_install || exit 1"
    set -x
    logger "get_llvm_binary || exit 1"
    export arch=`arch`
    echo "export arch=${arch}" >> ${TONE_BM_RUN_DIR}/.shrc
    # cmake version must be higher than 3.14
    install_cmake
    # test
    logger "cmake -version"

    if ${TEST_LLVM}/bin/clang -v 2>&1 | grep "clang version 17" ; then
        prepend LD_LIBRARY_PATH ${GCC_REF}/lib64
    fi
    prepend LD_LIBRARY_PATH ${TEST_LLVM}/lib64
    prepend PATH ${TONE_ROOT}/tone-matrix-compiler/${testsuite}/tools/${arch}

    #get gcc-ref binary
    cd ${TONE_BM_RUN_DIR}
    GCC_REF_VERSION=12.2.0
    wget_wrapper "https://compiler-ci-bucket.oss-cn-hangzhou.aliyuncs.com/llvm/binary/gcc-${GCC_REF_VERSION}-binary-${arch}.tar.xz" gcc-${GCC_REF_VERSION}-binary-${arch}.tar.xz
    getGccBinary &> get-gcc-binary.log

    if cat /etc/os-release | grep PRETTY_NAME | grep "CentOS Linux 7" ; then
        sudo yum install -y centos-release-scl
        sudo yum install -y devtoolset-10
        source /opt/rh/devtoolset-10/enable
        echo "source /opt/rh/devtoolset-10/enable" >> ${TONE_BM_RUN_DIR}/.shrc
    fi
}
