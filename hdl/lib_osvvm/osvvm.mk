BLOCK := lib_osvvm
$(BLOCK)_COMPILE_ORDER := ../lib_osvvm/hdl/IfElsePkg.vhd
$(BLOCK)_COMPILE_ORDER += ../lib_osvvm/hdl/OsvvmScriptSettingsPkg.vhd
$(BLOCK)_COMPILE_ORDER += ../lib_osvvm/hdl/OsvvmSettingsPkg.vhd
$(BLOCK)_COMPILE_ORDER += ../lib_osvvm/hdl/TextUtilPkg.vhd
$(BLOCK)_COMPILE_ORDER += ../lib_osvvm/hdl/ResolutionPkg.vhd
$(BLOCK)_COMPILE_ORDER += ../lib_osvvm/hdl/NamePkg.vhd
$(BLOCK)_COMPILE_ORDER += ../lib_osvvm/hdl/OsvvmGlobalPkg.vhd
$(BLOCK)_COMPILE_ORDER += ../lib_osvvm/hdl/CoverageVendorApiPkg_default.vhd
$(BLOCK)_COMPILE_ORDER += ../lib_osvvm/hdl/deprecated/LanguageSupport2019Pkg_c.vhd
$(BLOCK)_COMPILE_ORDER += ../lib_osvvm/hdl/TranscriptPkg.vhd
$(BLOCK)_COMPILE_ORDER += ../lib_osvvm/hdl/AlertLogPkg.vhd
$(BLOCK)_COMPILE_ORDER += ../lib_osvvm/hdl/TbUtilPkg.vhd
$(BLOCK)_COMPILE_ORDER += ../lib_osvvm/hdl/NameStorePkg.vhd
$(BLOCK)_COMPILE_ORDER += ../lib_osvvm/hdl/MessageListPkg.vhd
$(BLOCK)_COMPILE_ORDER += ../lib_osvvm/hdl/SortListPkg_int.vhd
$(BLOCK)_COMPILE_ORDER += ../lib_osvvm/hdl/RandomBasePkg.vhd
$(BLOCK)_COMPILE_ORDER += ../lib_osvvm/hdl/OsvvmTypesPkg.vhd
$(BLOCK)_COMPILE_ORDER += ../lib_osvvm/hdl/RandomPkg.vhd
$(BLOCK)_COMPILE_ORDER += ../lib_osvvm/hdl/RandomProcedurePkg.vhd
$(BLOCK)_COMPILE_ORDER += ../lib_osvvm/hdl/CoveragePkg.vhd
$(BLOCK)_COMPILE_ORDER += ../lib_osvvm/hdl/DelayCoveragePkg.vhd
$(BLOCK)_COMPILE_ORDER += ../lib_osvvm/hdl/ClockResetPkg.vhd
$(BLOCK)_COMPILE_ORDER += ../lib_osvvm/hdl/deprecated/ClockResetPkg_2024_05.vhd
$(BLOCK)_COMPILE_ORDER += ../lib_osvvm/hdl/ResizePkg.vhd
$(BLOCK)_COMPILE_ORDER += ../lib_osvvm/hdl/ScoreboardGenericPkg.vhd
$(BLOCK)_COMPILE_ORDER += ../lib_osvvm/hdl/ScoreboardPkg_slv.vhd
$(BLOCK)_COMPILE_ORDER += ../lib_osvvm/hdl/ScoreboardPkg_int.vhd
$(BLOCK)_COMPILE_ORDER += ../lib_osvvm/hdl/ScoreboardPkg_signed.vhd
$(BLOCK)_COMPILE_ORDER += ../lib_osvvm/hdl/ScoreboardPkg_unsigned.vhd
$(BLOCK)_COMPILE_ORDER += ../lib_osvvm/hdl/ScoreboardPkg_IntV.vhd
$(BLOCK)_COMPILE_ORDER += ../lib_osvvm/hdl/MemorySupportPkg.vhd
$(BLOCK)_COMPILE_ORDER += ../lib_osvvm/hdl/deprecated/MemoryGenericPkg_xilinx.vhd
$(BLOCK)_COMPILE_ORDER += ../lib_osvvm/hdl/MemoryPkg.vhd
$(BLOCK)_COMPILE_ORDER += ../lib_osvvm/hdl/ReportPkg.vhd
$(BLOCK)_COMPILE_ORDER += ../lib_osvvm/hdl/OsvvmTypesPkg.vhd
$(BLOCK)_COMPILE_ORDER += ../lib_osvvm/hdl/OsvvmSettingsPkg_default.vhd
$(BLOCK)_COMPILE_ORDER += ../lib_osvvm/hdl/deprecated/RandomPkg2019_c.vhd
$(BLOCK)_COMPILE_ORDER += ../lib_osvvm/hdl/OsvvmContext.vhd

include ../../build/questa_blocks.mk

