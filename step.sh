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

printf "\e[34mUploading dSYM to Xamarin.Insights\e[0m\n"
curl -w "Upload returned: %{http_code}\\n" -sfF "dsym=@${dsym_path};type=application/zip" "https://xaapi.xamarin.com/api/dsym?apikey=${xamarin_insights_api_key}" -o /dev/null
