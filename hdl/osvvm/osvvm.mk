#############################################################
## HDL Buildfiles © 2025 by Jordan Woods is licensed under ##
## CC BY-NC-ND 4.0. To view a copy of this license, visit  ##
## https://creativecommons.org/licenses/by-nc-nd/4.0/      ##
#############################################################
BLOCK := osvvm
$(BLOCK)_COMPILE_ORDER := ../$(BLOCK)/hdl/IfElsePkg.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/OsvvmTypesPkg.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/OsvvmScriptSettingsPkg.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/OsvvmScriptSettingsPkg_default.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/OsvvmSettingsPkg.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/TextUtilPkg.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/ResolutionPkg.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/NamePkg.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/OsvvmGlobalPkg.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/CoverageVendorApiPkg_default.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/deprecated/LanguageSupport2019Pkg_c.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/TranscriptPkg.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/AlertLogPkg.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/TbUtilPkg.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/NameStorePkg.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/MessageListPkg.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/SortListPkg_int.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/RandomBasePkg.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/RandomPkg.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/RandomProcedurePkg.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/CoveragePkg.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/DelayCoveragePkg.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/ClockResetPkg.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/deprecated/ClockResetPkg_2024_05.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/ResizePkg.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/ScoreboardGenericPkg.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/ScoreboardPkg_slv.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/ScoreboardPkg_int.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/ScoreboardPkg_signed.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/ScoreboardPkg_unsigned.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/ScoreboardPkg_IntV.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/MemorySupportPkg.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/deprecated/MemoryGenericPkg_xilinx.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/MemoryPkg.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/ReportPkg.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/OsvvmTypesPkg.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/OsvvmSettingsPkg_default.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/deprecated/RandomPkg2019_c.vhd
$(BLOCK)_COMPILE_ORDER += ../$(BLOCK)/hdl/OsvvmContext.vhd

include ../../make/questa/questa_blocks.mk

