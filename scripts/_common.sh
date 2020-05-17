#=================================================
# COMMON VARIABLES
#=================================================

# dependencies used by the app
pkg_dependencies=""
extra_pkg_dependencies="php7.3-curl php7.3-dom php7.3-gd php7.3-json php7.3-mbstring php7.3-pdo-mysql php7.3-tokenizer php7.3-zip"

# Version numbers
php_version="7.3"
project_version="~0.1.0-beta.13"
core_version="~0.1.0-beta.13"
ssowat_version="dev-0.1.0-beta.13"

#=================================================
# PERSONAL HELPERS
#=================================================

# Activate extension in Flarum's database
# usage: activate_flarum_extension $db_name $extension $short_extension
# $short_extension is the extension name written in database, how it is shortened is still a mystery
activate_flarum_extension() {
	# Declare an array to define the options of this helper.
	local legacy_args=ds
	declare -Ar args_array=( [d]=database= [s]=short_extension )
	local database
	local short_extension
	# Manage arguments with getopts
	ynh_handle_getopts_args "$@"
	database="${database:-$db_name}"

	local sql_command
	local old_extensions_enabled
	local addition
	local new_extensions_enabled

	# Retrieve current extensions
	sql_command="SELECT \`value\` FROM settings WHERE \`key\` = 'extensions_enabled'"
	old_extensions_enabled=$(ynh_mysql_execute_as_root "$sql_command" $database | tail -1)

	# Append the extension name at the end of the list
	addition=",\"${short_extension}\"]"
	new_extensions_enabled=${old_extensions_enabled::-1}$addition
	# Update activated extensions list
	sql_command="UPDATE \`settings\` SET \`value\`='$new_extensions_enabled' WHERE \`key\`='extensions_enabled';"
	ynh_mysql_execute_as_root "$sql_command" $database
}

#=================================================
# EXPERIMENTAL HELPERS
#=================================================

# See ynh_* scripts
