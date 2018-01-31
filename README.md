# Run [syncthing](https://syncthing.net) from a docker container

The service is not centralized as in today's cloud systems, but communication is direct between devices. This service is pre-licensed and is very user-friendly. This service works on the resin/rpi-raspbian:jessie(ARM) architecture. There is no need for passwords and usernames. All is configured correctly.

## Install
```sh
docker pull nanorocks/syncthing_nanorocks_arm
```

## Usage

```sh
docker run -v /config --name nanorocks_syncthing_arm_config resin/rpi-raspbian:jessie chown -R 22000 /config
```

```sh
docker run -d --net='host' -v /mnt/media:/mnt/media --volumes-from nanorocks_syncthing_arm_config \
	-p 22000:22000 -p 8384:8384 -p 21027:21027/udp --name nanorocks_syncthing_arm nanorocks/syncthing_nanorocks_arm
```

## Developing
You can run `run_syncthing.sh` to manipulate with syncthing image and containers.


