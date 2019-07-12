#!/bin/bash
run_path=$(pwd)
source $run_path/prepare.sh
$run_path/strip_libs.sh 
$run_path/list_light.sh $@
if [ -z "${install_lib}" ]; then
	$run_path/deploy_all_sources.sh
else
	$run_path/deploy_source.sh $@
fi
$run_path/redo_strip.sh
