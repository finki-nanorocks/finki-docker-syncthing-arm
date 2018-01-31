
#/bin/bash

# Function for removing docker containers 
function remove_docker_containers()
{
	l=`docker ps -a | grep 'nanorocks_syncthing_arm' | awk '{ print $1 }'`

	if [[ -z "$l" ]] 
	then
		echo '-> Containers are deleted.'
		
	else 
		for i in $l 
		do 
			echo '-> Removing: '$i' container.'
			docker rm -f $i
			sleep 2
		done
	fi
}

# Function for removing docker image 
function remove_docker_image()
{

	i=`docker images | grep 'nanorocks\/syncthing_nanorocks_arm' | awk '{ print $3 }'`
	if [[ -z "$i" ]] 
	then
		echo '-> Image nanorocks/syncthing_nanorocks_arm is deleted.'
	else 
		docker rmi -f $i
	fi
}

# Function for building docker containers 
function build_docker_containers()
{

	docker run -v /config --name nanorocks_syncthing_arm_config resin/rpi-raspbian:jessie chown -R 22000 /config
	# Create config volume and set permissions:
	docker run -d --net='host' -v /mnt/media:/mnt/media --volumes-from nanorocks_syncthing_arm_config \
	-p 22000:22000 -p 8384:8384 -p 21027:21027/udp --name nanorocks_syncthing_arm nanorocks/syncthing_nanorocks_arm

	echo -e "\n-> BUILDING CONTAINERS DONE."

	docker ps -a
}

# Function for building docker image 
function build_docker_image()
{
	docker build -t nanorocks/syncthing_nanorocks_arm .
}

# Template printing code just for use
function template_menu()
{

	echo -e "\nMENU\n"
	echo "1) Build/Rebulid docker image <nanorocks/syncthing>"
	echo "2) Build/Rebulid docker containers for nanorocks/syncthing image"
	echo "3) EXIT"
	
	echo "Enter number: "
	
}

# Validation number input
function validation_number()
{
	if [ $num = "1" ] || [ $num = "2" ] || [ $num = "3" ]; 
	then 
		echo "Input OK."
	else 
		echo "Invalid input."
		read num
		validation_number $num
	fi
}

# main function
function main()
{
	if ! [ $(id -u) = 0 ]; 
	then
	   echo "You must be root!"
	   exit 1
	else 

		echo -e "\nYou are root! What you want to do ?\n"
		echo "IMPORTANT --> If you don't have the dockerfile for nanorocks/syncthing image just enter number 2." 
		echo -e "The image will automatically be downloaded from docker hub. \n"

		template_menu .
		read num
		validation_number $num

		if [ $num = "1" ] 
		then 
			remove_docker_containers . 
			remove_docker_image .
			build_docker_image .
		fi

		if [ $num = "2" ] 
		then 
			remove_docker_containers .
			build_docker_containers . 
		fi

		if [ $num = "3" ] 
		then 
			echo "-> Terminated. Bye. "
    		exit 0
		fi

		while ! [[ -z "$num" ]]; 
		do 
			template_menu .
			read num
			validation_number $num

			if [ $num = "1" ] 
			then 
				remove_docker_containers . 
				remove_docker_image .
				build_docker_image .
			fi

			if [ $num = "2" ] 
			then 
				remove_docker_containers .
				build_docker_containers . 
			fi

			if [ $num = "3" ] 
			then 
				echo "-> Terminated. Bye. "
	    		exit 0
			fi
		done
	fi
}

main .


