## :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
##                    ______          __            __                         :
##                   / ____/___ ___  / /____  _____/ /_                        :
##                  / __/ / __ `__ \/ __/ _ \/ ___/ __ \                       :
##                 / /___/ / / / / / /_/  __/ /__/ / / /                       :
##                /_____/_/ /_/ /_/\__/\___/\___/_/ /_/                        :
##                                                                             :
## This file contains confidential and proprietary information of Emtech SA.   :
## Any unauthorized copying, alteration, distribution, transmission,           :
## performance, display or other use of this material is prohibited.           :
## :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
##                                                                             :
## Client             :                                                        :
## Version            : 1.0                                                    :
## Application        : Generic                                                :
## Filename           : compile.do                                             :
## Date Last Modified : 2021 SEP 16                                            :
## Date Created       : 2021 SEP 16                                            :
## Device             : Generic                                                :
## Design Name        : Generic                                                :
## Purpose            : QuestaSim compilation script for Stream Agent          :
## Author(s)          : Nicolas Bertolo                                        :
## Email              : nbertolo@emtech.com.ar                                 :
##                                                                             :
## :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
##
## Detailed Description:
##
##
## -----------------------------------------------------------------------------

set stream_vip_path "$lib_path/sim/vip/stream_vip"

# Compile VIPs
vlog -timescale 1ns/1ps +incdir+$stream_vip_path \
    "$stream_vip_path/stream_agent_pkg.sv"       \
    "$stream_vip_path/stream_if.sv"