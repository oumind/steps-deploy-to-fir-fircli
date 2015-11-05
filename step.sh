#!/bin/bash

THIS_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# load bash utils
source "${THIS_SCRIPT_DIR}/bash_utils/utils.sh"
source "${THIS_SCRIPT_DIR}/bash_utils/formatted_output.sh"


# ------------------------------
# --- Error Cleanup

function finalcleanup {
  echo "-> finalcleanup"
  local fail_msg="$1"

  write_section_to_formatted_output "# Error"
  if [ ! -z "${fail_msg}" ] ; then
    write_section_to_formatted_output "**Error Description**:"
    write_section_to_formatted_output "${fail_msg}"
  fi
  write_section_to_formatted_output "*See the logs for more information*"

  write_section_to_formatted_output "**If this is the very first build**
of the app you try to deploy to iTunes Connect then you might want to upload the first
build manually to make sure it fulfills the initial iTunes Connect submission
verification process."
}

function CLEANUP_ON_ERROR_FN {
  local err_msg="$1"
  finalcleanup "${err_msg}"
}
set_error_cleanup_function CLEANUP_ON_ERROR_FN


# ---------------------
# --- Required Inputs

if [ -z "${ipa_path}" ] ; then
	finalcleanup "Input: \`ipa_path\` not provided!"
	exit 1
fi

if [ -z "${token}" ] ; then
	finalcleanup "Input: \`token\` not provided!"
	exit 1
fi


# ---------------------
# --- Main

write_section_to_formatted_output "# Setup"
bash "${THIS_SCRIPT_DIR}/_setup.sh"
fail_if_cmd_error "Failed to setup the required tools!"

write_section_to_formatted_output "# Deploy"

fir p "${ipa_path}" -T "${token}" --verbose
fail_if_cmd_error "Deploy failed!"

write_section_to_formatted_output "# Success"
echo_string_to_formatted_output "* The app (.ipa) was successfully uploaded to [fir.im](http://fir.im/apps)"

exit 0
