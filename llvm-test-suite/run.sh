#!/bin/bash
# usage: BINARY_URL=https://compiler-ci-bucket.oss-cn-hangzhou.aliyuncs.com/llvm/CI/alios/17.0.6.1-1/latest/alios7.`arch`.tar.gz ./tone install llvm-test-suite &> install.log && ./tone run llvm-test-suite:codeup-release___17.x-release___17.x-0X2DO1 &> run.log
get_llvm_code()
{
    cd ${TONE_BM_RUN_DIR}/
    rm -rf llvm-test-suite/ alibaba-llvm-project/ llvm-project/
    #LLVM_PROJECT_DIR="ERROR"
    test_branch=`echo ${test_branch} | sed "s|___|/|g"`
    llvm_branch=`echo ${llvm_branch} | sed "s|___|/|g"`
    if [ "$code_source" == "alibaba" ] ; then
        git_clone "git clone --depth 1 --branch ${test_branch} http://$TONE_USER:\"$TONE_PASS\"@gitlab-sp.alibaba-inc.com/clang-llvm/llvm-test-suite.git" llvm-test-suite || return 1
        #git_clone "git clone --depth 1 --branch ${llvm_branch} http://$TONE_USER:\"$TONE_PASS\"@gitlab-sp.alibaba-inc.com/clang-llvm/alibaba-llvm-project.git" alibaba-llvm-project || return 1
        #LLVM_PROJECT_DIR="alibaba-llvm-project"
        git_clone "git clone git@gitlab.alibaba-inc.com:os-quality/acc-test-suite-lit.git" acc-test-suite-lit
    elif [ "$code_source" == "codeup" ] ; then
        git_clone "git clone --depth 1 --branch ${test_branch} git@codeup.aliyun.com:5f4e0dfe6207a1a8b17fa7cf/compiler-test/llvm-test-suite.git" llvm-test-suite || return 1
        #git_clone "git clone --depth 1 --branch ${llvm_branch} git@codeup.aliyun.com:5f4e0dfe6207a1a8b17fa7cf/compiler-test/llvm-project.git" llvm-project || return 1
        #LLVM_PROJECT_DIR="llvm-project"
        git_clone "git clone git@codeup.aliyun.com:5f4e0dfe6207a1a8b17fa7cf/compiler-test/acc-test-suite-lit.git" acc-test-suite-lit
    else
        return 1
    fi
}

setupCompiler()
{
    . ${TONE_BM_RUN_DIR}/.shrc
    . ${TONE_ROOT}/tone-matrix-compiler/common/common.sh
    get_llvm_code || exit 1
    echo "alias lit=${TONE_ROOT}/tone-matrix-compiler/${testsuite}/llvm-lit" >> ${TONE_BM_RUN_DIR}/.shrc
    alias lit=${TONE_ROOT}/tone-matrix-compiler/${testsuite}/llvm-lit
}


runCompiler()
{
    which tclsh
    if [[ 0 -ne $? ]] ; then
        echo "please install tclsh!"
        return 1
    fi
    . ${TONE_ROOT}/tone-matrix-compiler/common/common.sh
    . ${TONE_BM_RUN_DIR}/.shrc
    set -x
    gcc -v
    which gcc
    echo OPTFLAGS=${OPTFLAGS}
    cd ${TONE_BM_RUN_DIR}/
    rm -rf ${TONE_BM_RUN_DIR}/test-suite-build
    mkdir ${TONE_BM_RUN_DIR}/test-suite-build
    cd ${TONE_BM_RUN_DIR}/test-suite-build
    ${TEST_LLVM}/bin/clang -v
    OPTFLAGS=`${TONE_ROOT}/tone-matrix-compiler/common/confConvert.pl "${compilerOpts}"`
    if ${TEST_LLVM}/bin/clang -v 2>&1 | grep "clang version 17" ; then
        OPTFLAGS="${OPTFLAGS} --gcc-toolchain=${GCC_REF}"
        # prepend LD_LIBRARY_PATH ${GCC_REF}/lib64
    fi
    echo OPTFLAGS=${OPTFLAGS}
    cmake -DOPTFLAGS="${OPTFLAGS}" -DCMAKE_C_COMPILER=${TEST_LLVM}/bin/clang -DCMAKE_CXX_COMPILER=${TEST_LLVM}/bin/clang++ -C${TONE_ROOT}/tone-matrix-compiler/llvm-test-suite/cmake.txt ${TONE_BM_RUN_DIR}/llvm-test-suite 2>&1 | tee cmake-llvm.log || return 1
    time make -j LOG=DEBUG 2>&1 | tee make-llvm.log || return 1
    time python3 ${TONE_ROOT}/tone-matrix-compiler/${testsuite}/llvm-lit -v -j `nproc` -o results-llvm-test-suite.json . 2>&1 | tee test-result-llvm-test-suite.log
    upload_testlogs results-llvm-test-suite.json test-result-llvm-test-suite.log ${TONE_ROOT}/tone-matrix-compiler/llvm-test-suite/cmake.txt make-llvm.log cmake-llvm.log

    #ABI-Testsuite/test
    if [[ "xx86_64" == "x${arch}" ]] ; then
        cd ${TONE_BM_RUN_DIR}/llvm-test-suite/ABI-Testsuite
        ln -s ${TONE_ROOT}/tone-matrix-compiler/llvm-test-suite/llvm/utils/lit/lit .
        time python3 linux-x86.py "clang ${OPTFLAGS}" test 2>&1 | tee test-result-ABI-test-suite.log
        upload_testlogs test-result-ABI-test-suite.log
    fi

    #acc-test-suite
    rm -rf ${TONE_BM_RUN_DIR}/acc-test-suite-build
    mkdir -p ${TONE_BM_RUN_DIR}/acc-test-suite-build
    cd ${TONE_BM_RUN_DIR}/acc-test-suite-build
    EXEC_ROOT="/tmp/build-acc-test-suite-lit-`whoami`"
    rm -rf ${EXEC_ROOT}
    mkdir -p ${EXEC_ROOT}
    time python3 ${TONE_ROOT}/tone-matrix-compiler/${testsuite}/llvm-lit -DOPTFLAGS="${OPTFLAGS}" -DEXEC_ROOT="${EXEC_ROOT}" -v -j `nproc` -o results-acc-test-suite.json ${TONE_BM_RUN_DIR}/acc-test-suite-lit 2>&1 | tee test-result-acc-test-suite.log
    upload_testlogs results-acc-test-suite.json test-result-acc-test-suite.log

    #fortran-test-suite
    if [[ -e ${TEST_LLVM}/bin/flang ]] ; then
        cp -f ${TONE_ROOT}/tone-matrix-compiler/${testsuite}/flang-new ${TEST_LLVM}/bin/flang-new
        chmod +x ${TEST_LLVM}/bin/flang-new
        flang="${TEST_LLVM}/bin/flang-new"
    elif [[ -e ${TEST_LLVM}/bin/flang-new ]] ; then
        flang=${TEST_LLVM}/bin/flang-new
    else
        return
    fi    
    rm -rf ${TONE_BM_RUN_DIR}/test-suite-build-fortran
    mkdir ${TONE_BM_RUN_DIR}/test-suite-build-fortran
    cd ${TONE_BM_RUN_DIR}/test-suite-build-fortran
    \rm -rf ${TEST_LLVM}/include/flang
    # \cp -rf `find ${GCC_REF}/lib/gcc -name include | LC_ALL=C sort | head -n 1` ${TEST_LLVM}/include/flang
    \cp -rf `find ${GCC_REF} -type f -name ISO_Fortran_binding.h | xargs dirname` ${TEST_LLVM}/include/flang
    cmake -DCMAKE_C_COMPILER=${TEST_LLVM}/bin/clang -DCMAKE_CXX_COMPILER=${TEST_LLVM}/bin/clang++ -DCMAKE_Fortran_COMPILER=${TEST_LLVM}/bin/flang-new -DTEST_SUITE_COLLECT_CODE_SIZE:STRING=OFF -DTEST_SUITE_SUBDIRS:STRING="Fortran" -DTEST_SUITE_FORTRAN:STRING=ON -DTEST_SUITE_LIT=/tmp/tone/tone-matrix-compiler/llvm-test-suite/llvm-lit -C${TONE_BM_RUN_DIR}/llvm-test-suite/cmake/caches/O3.cmake ${TONE_BM_RUN_DIR}/llvm-test-suite &> cmake-fortran.log || die "fortran cmake fail!"
    \rm -f ${TONE_BM_RUN_DIR}/llvm-test-suite/Fortran/gfortran/regression/integer_exponentiation_3.F90
    \rm -f ${TONE_BM_RUN_DIR}/llvm-test-suite/Fortran/gfortran/regression/coarray/registering_1.f90
    \rm -f ${TONE_BM_RUN_DIR}/llvm-test-suite/Fortran/gfortran/regression/g77/cabs.f
    \rm -f ${TONE_BM_RUN_DIR}/llvm-test-suite/Fortran/gfortran/torture/execute/forall_1.f90
    \rm -f ${TONE_BM_RUN_DIR}/llvm-test-suite/Fortran/gfortran/regression/achar_2.f90
    time make -k -j &> make-fortran.log
    \cp -rf ${TONE_BM_RUN_DIR}/llvm-test-suite/litsupport .
    \cp -f ${TONE_BM_RUN_DIR}/llvm-test-suite/lit.cfg .
    time python3 ${TONE_ROOT}/tone-matrix-compiler/${testsuite}/llvm-lit -j `nproc` -v -o result-fortran.json . 2>&1 | tee result-fortran.log
    upload_testlogs cmake-fortran.log make-fortran.log result-fortran.json result-fortran.log

    upload_testlogs ${TONE_ROOT}/tone-matrix-compiler/${testsuite}/known-failure.txt ${TONE_ROOT}/tone-matrix-compiler/${testsuite}/known-failure-ABI-testsuite.txt ${TONE_ROOT}/tone-matrix-compiler/${testsuite}/known-failure-acc-testsuite.txt ${TONE_ROOT}/tone-matrix-compiler/${testsuite}/known-failure-fortran.txt ${TONE_BM_RUN_DIR}/.shrc
}

parseCompiler()
{
    set -x
    ${TONE_ROOT}/tone-matrix-compiler/${testsuite}/parse.pl ${TONE_BM_RUN_DIR}/test-suite-build/test-result-llvm-test-suite.log ${TONE_ROOT}/tone-matrix-compiler/${testsuite}/known-failure.txt
    if [[ "xx86_64" == "x${arch}" ]] ; then
        ${TONE_ROOT}/tone-matrix-compiler/${testsuite}/parse.pl ${TONE_BM_RUN_DIR}/llvm-test-suite/ABI-Testsuite/test-result-ABI-test-suite.log ${TONE_ROOT}/tone-matrix-compiler/${testsuite}/known-failure-ABI-testsuite.txt
    fi
    ${TONE_ROOT}/tone-matrix-compiler/${testsuite}/parse.pl ${TONE_BM_RUN_DIR}/acc-test-suite-build/test-result-acc-test-suite.log ${TONE_ROOT}/tone-matrix-compiler/${testsuite}/known-failure-acc-testsuite.txt
    ${TONE_ROOT}/tone-matrix-compiler/${testsuite}/parse.pl ${TONE_BM_RUN_DIR}/test-suite-build-fortran/result-fortran.log ${TONE_ROOT}/tone-matrix-compiler/${testsuite}/known-failure-fortran.txt
}

teardownCompiler()
{
    echo nothing todo.
}
