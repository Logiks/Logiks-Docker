#!/bin/sh

rootFolder=webData
appName=home
appPath=https://github.com/LogiksApps/_website.git

dirname=`pwd`
parentDir="$(basename "$dirname")"

clear
echo "Initiating Installer ...\n"
pwd
echo ""

# Functions required
command_exists () {
    type "$1" &> /dev/null ;
}


if command_exists git ; then
	mkdir dataMySQL
	mkdir userData
	#mkdir webTools
	
	# Starting Docker Containers
	echo "Initiating Docker Containers"
	docker kill $(docker ps -q)
	docker rm $(docker ps -a -q)
	docker network prune --force
	#docker rmi $(docker images -q)
	docker-compose up -d --no-recreate
	#docker-compose up -d --force-recreate
	echo ""
	
	echo "Cloning Framework"
	git clone --branch=master --recurse-submodules https://github.com/Logiks/Logiks-Core.git $rootFolder
    echo ""
    
	echo "Installing core modules"
	cd $rootFolder/plugins/modules/
	git clone --branch=master https://github.com/LogiksPlugins/charts.git
	git clone --branch=master https://github.com/LogiksPlugins/content.git
	git clone --branch=master https://github.com/LogiksPlugins/dashboard.git
	git clone --branch=master https://github.com/LogiksPlugins/datagrid.git
	git clone --branch=master https://github.com/LogiksPlugins/forms.git
	git clone --branch=master https://github.com/LogiksPlugins/infoview.git
	git clone --branch=master https://github.com/LogiksPlugins/infoviewTable.git
	git clone --branch=master https://github.com/LogiksPlugins/infovisuals.git
	git clone --branch=master https://github.com/LogiksPlugins/mapps.git
	git clone --branch=master https://github.com/LogiksPlugins/navigator.git
	git clone --branch=master https://github.com/LogiksPlugins/pages.git
	git clone --branch=master https://github.com/LogiksPlugins/reports.git
	git clone --branch=master https://github.com/LogiksPlugins/views.git
	git clone --branch=master https://github.com/LogiksPlugins/dcpages.git
	git clone --branch=master https://github.com/LogiksPlugins/gallery.git
	git clone --branch=master https://github.com/LogiksPlugins/packages.git
	echo ""
	
	cd ../../apps/
	echo "Installing CMS, Application"
	git clone --branch=master --recurse-submodules https://github.com/LogiksApps/Logiks-CMS.git cms/
	git clone --branch=master --recurse-submodules $appPath $appName
	echo ""
	
	echo "Install app specific modules"
	cd $appName/plugins/modules/
	echo ""
	# Returning to apps folder
	cd ../../../
	
	# Returning to webData folder
	cd ../
	chmod -R 0777 tmp/
	
	# Returning to root folder
	cd ../

	echo "Configuring the installation"
	cp -r -f src/jsonConfig/* $rootFolder/config/jsonConfig/
	cp -r -f src/wtools/adminer.php $rootFolder/
	echo ""
	
	echo "Waiting for Database to bootup"
	sleep 15
	
	# Import Databases as per requirements
	echo "Starting Database Import"
	#docker exec -i "$parentDir"_silkdockerMYSQL_1 mysql -uroot -pmy@2019SQL -e "ALTER USER 'root' IDENTIFIED WITH mysql_native_password BY 'my@2019SQL';"
	docker exec -i "$parentDir"_silkdockerMYSQL_1 mysql -uroot -pmy@2019SQL -e "CREATE DATABASE logiks4_coredb collate utf8_general_ci;"
	docker exec -i "$parentDir"_silkdockerMYSQL_1 mysql -uroot -pmy@2019SQL --database logiks4_coredb < ./webData/.install/sql/MySQL/schema-coredb.sql
	docker exec -i "$parentDir"_silkdockerMYSQL_1 mysql -uroot -pmy@2019SQL --database logiks4_coredb < ./webData/.install/sql/MySQL/data-coredb.sql

	docker exec -i "$parentDir"_silkdockerMYSQL_1 mysql -uroot -pmy@2019SQL --database logiks4_coredb < ./webData/apps/cms/sql/schema.sql
	docker exec -i "$parentDir"_silkdockerMYSQL_1 mysql -uroot -pmy@2019SQL --database logiks4_coredb < ./webData/apps/cms/sql/data.sql

	docker exec -i "$parentDir"_silkdockerMYSQL_1 mysql -uroot -pmy@2019SQL -e "CREATE DATABASE logiks4_logdb collate utf8_general_ci;"
	#docker exec -i "$parentDir"_silkdockerMYSQL_1 mysql -uroot -pmy@2019SQL --database logiks4_logdb < ./webData/apps/home/sql/log_schema.sql

	docker exec -i "$parentDir"_silkdockerMYSQL_1 mysql -uroot -pmy@2019SQL -e "CREATE DATABASE logiks4_app1 collate utf8_general_ci;"
	docker exec -i "$parentDir"_silkdockerMYSQL_1 mysql -uroot -pmy@2019SQL --database logiks4_app1 < ./webData/apps/home/sql/schema.sql
	docker exec -i "$parentDir"_silkdockerMYSQL_1 mysql -uroot -pmy@2019SQL --database logiks4_app1 < ./webData/apps/home/sql/data.sql

	docker exec -i "$parentDir"_silkdockerMYSQL_1 mysql -uroot -pmy@2019SQL -e "UPDATE logiks4_coredb.lgks_users SET pwd='\$2a\$10\$AFrfn8GS8yDwb6FKShznMu7Q6B1aYrT8w44yiJ0.aL0dMY1Y2ezPm', pwd_salt='AFrfn8GS8yDwb6FKShznMw==' WHERE userid='root';"
	echo "Database Import Complete"
	
	# echo "Please start the docker composer instance to checkout"
	echo ""
	echo ""
	echo "Installation Completed"

	echo ""
	echo "Installation Directory"
	pwd
	
	echo ""
	echo "All systems up and running"
	echo "Please check the site running at http://localhost:8000/"
	echo ""
	echo "Please do check the Security Section of Readme.md for securing your instance"
	echo "For root password, use silk@123. Change the root password after first login"
	echo ""
	echo "Thank you for using Logiks Framework, do send us your feedback"
else
	echo "Git Not Installed, it is required to continue"
fi
