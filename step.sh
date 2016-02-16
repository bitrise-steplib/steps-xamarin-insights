#!/bin/bash

set -e

if [ -z "$xamarin_insights_api_key" ]; then
	printf "\e[31mError: \e[0mxamarin_insights_api_key variable not set\n"
	exit 1
fi

if [ -z "$dsym_path" ]; then
	printf "\e[31mError: \e[0mdsym_path variable not set\n"
	exit 1
fi

shopt -s nocasematch

zip_dsym_path=""
if [[ -d "${dsym_path}" ]] ; then
	printf "\e[34mZipping dSYM...\e[0m\n"
	zip_dsym_path="${dsym_path}.zip"
	zip -r "${zip_dsym_path}" "${dsym_path}"
elif [[ -f "${dsym_path}" ]]; then
	if [[ $dsym_path =~ \.zip$ ]] ; then
		zip_dsym_path="${dsym_path}"
	else
		printf "\e[31mError: \e[0mUnsupported dSYM format\n"
		exit 1
	fi
else
	printf "\e[31mError: \e[0mFile not found at path ${dsym_path}\n"
	exit 1
fi

printf "\e[34mUploading ${zip_dsym_path} to Xamarin.Insights\e[0m\n"
curl -w "Upload returned: %{http_code}\\n" -sfF "dsym=@${zip_dsym_path};type=application/zip" "https://xaapi.xamarin.com/api/dsym?apikey=${xamarin_insights_api_key}" -o /dev/null
