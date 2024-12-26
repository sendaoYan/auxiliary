#!/bin/bash
# usage: BINARY_URL=https://..../17.0.6.1-1/latest/os7.`arch`.tar.gz ./wrapper install llvm-test-suite &> install.log && ./wrapper run llvm-test-suite:codeup-release___17.x-release___17.x-0X2DO1 &> run.log
get_llvm_code()
{
    cd ${RUN_DIR}/
    rm -rf llvm-test-suite/ llvm-project/
    #LLVM_PROJECT_DIR="ERROR"
    test_branch=`echo ${test_branch} | sed "s|___|/|g"`
    llvm_branch=`echo ${llvm_branch} | sed "s|___|/|g"`
    if [ "$code_source" == "codeup" ] ; then
        git_clone "git clone --depth 1 --branch ${test_branch} git@github.com:llvm/llvm-test-suite.git" llvm-test-suite || return 1
        git_clone "git clone git@github.com:sendaoYan/auxiliary.git" acc-test-suite-lit
    else
        return 1
    fi
}

setupCompiler()
{
    . ${RUN_DIR}/.shrc
    . ${ROOT}/compiler/common/common.sh
    get_llvm_code || exit 1
    echo "alias lit=${ROOT}/compiler/${testsuite}/llvm-lit" >> ${RUN_DIR}/.shrc
    alias lit=${ROOT}/compiler/${testsuite}/llvm-lit
}


runCompiler()
{
    which tclsh
    if [[ 0 -ne $? ]] ; then
        echo "please install tclsh!"
        return 1
    fi
    . ${ROOT}/compiler/common/common.sh
    . ${RUN_DIR}/.shrc
    set -x
    gcc -v
    which gcc
    echo OPTFLAGS=${OPTFLAGS}
    cd ${RUN_DIR}/
    rm -rf ${RUN_DIR}/test-suite-build
    mkdir ${RUN_DIR}/test-suite-build
    cd ${RUN_DIR}/test-suite-build
    ${TEST_LLVM}/bin/clang -v
    OPTFLAGS=`${ROOT}/compiler/common/confConvert.pl "${compilerOpts}"`
    if ${TEST_LLVM}/bin/clang -v 2>&1 | grep "clang version 17" ; then
        OPTFLAGS="${OPTFLAGS} --gcc-toolchain=${GCC_REF}"
        # prepend LD_LIBRARY_PATH ${GCC_REF}/lib64
    fi
    echo OPTFLAGS=${OPTFLAGS}
    cmake -DOPTFLAGS="${OPTFLAGS}" -DCMAKE_C_COMPILER=${TEST_LLVM}/bin/clang -DCMAKE_CXX_COMPILER=${TEST_LLVM}/bin/clang++ -C${ROOT}/compiler/llvm-test-suite/cmake.txt ${RUN_DIR}/llvm-test-suite 2>&1 | tee cmake-llvm.log || return 1
    time make -j LOG=DEBUG 2>&1 | tee make-llvm.log || return 1
    time python3 ${ROOT}/compiler/${testsuite}/llvm-lit -v -j `nproc` -o results-llvm-test-suite.json . 2>&1 | tee test-result-llvm-test-suite.log
    upload_testlogs results-llvm-test-suite.json test-result-llvm-test-suite.log ${ROOT}/compiler/llvm-test-suite/cmake.txt make-llvm.log cmake-llvm.log

    #ABI-Testsuite/test
    if [[ "xx86_64" == "x${arch}" ]] ; then
        cd ${RUN_DIR}/llvm-test-suite/ABI-Testsuite
        ln -s ${ROOT}/compiler/llvm-test-suite/llvm/utils/lit/lit .
        time python3 linux-x86.py "clang ${OPTFLAGS}" test 2>&1 | tee test-result-ABI-test-suite.log
        upload_testlogs test-result-ABI-test-suite.log
    fi

    #acc-test-suite
    rm -rf ${RUN_DIR}/acc-test-suite-build
    mkdir -p ${RUN_DIR}/acc-test-suite-build
    cd ${RUN_DIR}/acc-test-suite-build
    EXEC_ROOT="/tmp/build-acc-test-suite-lit-`whoami`"
    rm -rf ${EXEC_ROOT}
    mkdir -p ${EXEC_ROOT}
    time python3 ${ROOT}/compiler/${testsuite}/llvm-lit -DOPTFLAGS="${OPTFLAGS}" -DEXEC_ROOT="${EXEC_ROOT}" -v -j `nproc` -o results-acc-test-suite.json ${RUN_DIR}/acc-test-suite-lit 2>&1 | tee test-result-acc-test-suite.log
    upload_testlogs results-acc-test-suite.json test-result-acc-test-suite.log

    #fortran-test-suite
    if [[ -e ${TEST_LLVM}/bin/flang ]] ; then
        cp -f ${ROOT}/compiler/${testsuite}/flang-new ${TEST_LLVM}/bin/flang-new
        chmod +x ${TEST_LLVM}/bin/flang-new
        flang="${TEST_LLVM}/bin/flang-new"
    elif [[ -e ${TEST_LLVM}/bin/flang-new ]] ; then
        flang=${TEST_LLVM}/bin/flang-new
    else
        return
    fi    
    rm -rf ${RUN_DIR}/test-suite-build-fortran
    mkdir ${RUN_DIR}/test-suite-build-fortran
    cd ${RUN_DIR}/test-suite-build-fortran
    \rm -rf ${TEST_LLVM}/include/flang
    # \cp -rf `find ${GCC_REF}/lib/gcc -name include | LC_ALL=C sort | head -n 1` ${TEST_LLVM}/include/flang
    \cp -rf `find ${GCC_REF} -type f -name ISO_Fortran_binding.h | xargs dirname` ${TEST_LLVM}/include/flang
    cmake -DCMAKE_C_COMPILER=${TEST_LLVM}/bin/clang -DCMAKE_CXX_COMPILER=${TEST_LLVM}/bin/clang++ -DCMAKE_Fortran_COMPILER=${TEST_LLVM}/bin/flang-new -DTEST_SUITE_COLLECT_CODE_SIZE:STRING=OFF -DTEST_SUITE_SUBDIRS:STRING="Fortran" -DTEST_SUITE_FORTRAN:STRING=ON -DTEST_SUITE_LIT=/tmp/wrapper/compiler/llvm-test-suite/llvm-lit -C${RUN_DIR}/llvm-test-suite/cmake/caches/O3.cmake ${RUN_DIR}/llvm-test-suite &> cmake-fortran.log || die "fortran cmake fail!"
    \rm -f ${RUN_DIR}/llvm-test-suite/Fortran/gfortran/regression/integer_exponentiation_3.F90
    \rm -f ${RUN_DIR}/llvm-test-suite/Fortran/gfortran/regression/coarray/registering_1.f90
    \rm -f ${RUN_DIR}/llvm-test-suite/Fortran/gfortran/regression/g77/cabs.f
    \rm -f ${RUN_DIR}/llvm-test-suite/Fortran/gfortran/torture/execute/forall_1.f90
    \rm -f ${RUN_DIR}/llvm-test-suite/Fortran/gfortran/regression/achar_2.f90
    time make -k -j &> make-fortran.log
    \cp -rf ${RUN_DIR}/llvm-test-suite/litsupport .
    \cp -f ${RUN_DIR}/llvm-test-suite/lit.cfg .
    time python3 ${ROOT}/compiler/${testsuite}/llvm-lit -j `nproc` -v -o result-fortran.json . 2>&1 | tee result-fortran.log
    upload_testlogs cmake-fortran.log make-fortran.log result-fortran.json result-fortran.log

    upload_testlogs ${ROOT}/compiler/${testsuite}/known-failure.txt ${ROOT}/compiler/${testsuite}/known-failure-ABI-testsuite.txt ${ROOT}/compiler/${testsuite}/known-failure-acc-testsuite.txt ${ROOT}/compiler/${testsuite}/known-failure-fortran.txt ${RUN_DIR}/.shrc
}

parseCompiler()
{
    set -x
    ${ROOT}/compiler/${testsuite}/parse.pl ${RUN_DIR}/test-suite-build/test-result-llvm-test-suite.log ${ROOT}/compiler/${testsuite}/known-failure.txt
    if [[ "xx86_64" == "x${arch}" ]] ; then
        ${ROOT}/compiler/${testsuite}/parse.pl ${RUN_DIR}/llvm-test-suite/ABI-Testsuite/test-result-ABI-test-suite.log ${ROOT}/compiler/${testsuite}/known-failure-ABI-testsuite.txt
    fi
    ${ROOT}/compiler/${testsuite}/parse.pl ${RUN_DIR}/acc-test-suite-build/test-result-acc-test-suite.log ${ROOT}/compiler/${testsuite}/known-failure-acc-testsuite.txt
    ${ROOT}/compiler/${testsuite}/parse.pl ${RUN_DIR}/test-suite-build-fortran/result-fortran.log ${ROOT}/compiler/${testsuite}/known-failure-fortran.txt
}

teardownCompiler()
{
    echo nothing todo.
}
