################################################################################
## empty_project.tcl = Make and empty project to create dcps/xcis/tcl scripts ##
##                                                                            ##
## Manual Revision History                                                    ##
## 01/07/25 - JFW - Initial Release                                           ##
################################################################################
##
########################################################################
## make-hdl © 2025 by Jordan Woods is licensed under CC BY-NC-SA 4.0. ##
## To view a copy of this license, visit                              ##
## https://creativecommons.org/licenses/by-nc-sa/4.0/                 ##
########################################################################

# create_ip requires that a project is open in memory. Create project
# but don't do anything with it
create_project -in_memory -part xc7a12ticsg325-1L -ip
set_property target_simulator modelsim [current_project]

