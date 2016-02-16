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


zip_dsym_path=""
zip_ext=".zip"

if [[ "${dsym_path}" == *${zip_ext} ]] ; then

	zip_dsym_path="${dsym_path}"

else
	printf "\e[34mZipping dSYM...\e[0m\n"

	zip_dsym_path="${dsym_path}${zip_ext}"

	zip -r "${zip_dsym_path}" "${dsym_path}"
fi

printf "\e[34mUploading dSYM to Xamarin.Insights\e[0m\n"
curl -w "Upload returned: %{http_code}\\n" -sfF "dsym=@${zip_dsym_path};type=application/zip" "https://xaapi.xamarin.com/api/dsym?apikey=${xamarin_insights_api_key}" -o /dev/null
