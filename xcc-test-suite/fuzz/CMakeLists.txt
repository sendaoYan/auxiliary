set(LIT_SCRIPT "")
list(APPEND LIT_SCRIPT "import lit.llvm")
list(APPEND LIT_SCRIPT "config.CMAKE_CURRENT_BINARY_DIR='${CMAKE_CURRENT_BINARY_DIR}'")
list(APPEND LIT_SCRIPT "config.OPTFLAGS='${OPTFLAGS}'")
list(APPEND LIT_SCRIPT "lit.llvm.initialize(lit_config, config)")
list(APPEND LIT_SCRIPT "lit_config.load_config(config, '${CMAKE_CURRENT_SOURCE_DIR}/lit.cfg')")
list(JOIN LIT_SCRIPT "\n" LIT_SCRIPT)
file(GENERATE OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/lit.site.cfg.py" CONTENT "${LIT_SCRIPT}")
