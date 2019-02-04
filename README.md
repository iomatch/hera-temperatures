# hera-temperatures
# version: 0.9.3
Linux bash scripts (etc.) needed to operate DHT22 & DS18B20 temperature sensors. 

 * [My Blog](http://f8.oire.fi/blog)
 * [My Photos](http://f8.oire.fi/)

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites
 - DHT22 & DS18B20 temperature sensors
 
 - A [Raspberry Pi](https://www.raspberrypi.org/) running [Raspbian GNU/Linux](https://www.raspbian.org/) 9 (stretch) or newer
 
 - [pigpiod](https://github.com/guymcswain/pigpio-client/wiki/Install-and-configure-pigpiod) 

	A C library to manipulate the Pi's GPIO.
	Install from Raspbian package manager
```
sudo apt-get update
sudo apt-get install pigpio
pigpiod -v
```
 - DHTXXXD binaries
	You can find the binaries in bin/. Unzip, read the DHTXXD_README and compile. Rename the binary
	```
	DHTXXD-exec
	```
	and move (or link) the binary to /usr/local/sbin/.
	
 - [curl](http://curl.haxx.se)

 - [PushBullet](https://www.pushbullet.com/)

	For receiving notifications on your phone from scripts.
	
	To install PushBullet, get your API code from [PushBullet](https://www.pushbullet.com/). Also download pushbullet.sh (from this repository, under sbin/) and create a link for it in /usr/bin/

### Installing

Create /lockdir/ directory and make it universally writable. This will be used by the scripts to store lock information in. The lock information cannot be stored in /tmp as it gets cleared [at least] at boot-time and many of the scripts (notably the ones sending PushBullet messages, eg. temperature-monitor) will need to keep time-relative track of notifications across boots and /tmp being randomly cleared cannot be used for this.

After downloading the scripts (and their respective folders) to [/path/to/your/scripts], add [/path/to/your/scripts] to env $PATH (usually you can just edit your .profile, located in your $HOME, to contain eg. PATH="$PATH:$HOME[your/scripts]")

```
PATH="$PATH:$HOME[your/scripts/]
```

Create symlinks for /usr/local/etc and /usr/local/sbin
```
ln -s [/path/to/your/scripts]/etc/ /usr/local/etc
```
```
ln -s [/path/to/your/scripts]/sbin/ /usr/local/sbin
```

!! Also create necessary conf files in scripts/etc/conf!!

Add the following to the end of your /etc/rc.local

```
modprobe w1-gpio
modprobe w1_therm
```
and the following to root's cron

```
# sudo crontab -e
```
```
@reboot /usr/bin/pigpiod
```

## Running a test script

```
[/path/to/your/scripts]temperature_sensor -in
```

### Result?

When run script should output only a temperature reading, eg.
```
5.6
```

## Built With

* [nano](https://www.nano-editor.org/) - Text Editor

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details.

## Authors

* **Tommi Nikkilä** - *Initial work* - [iomatch](https://github.com/iomatch) 

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the GNU GPL v.3 - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Jaana, without whom all this would not be possible.
* Hat tip to also anyone whose code was (ab)used
* The Linux and OpenSource communities!
