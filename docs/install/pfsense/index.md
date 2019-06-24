# Install DNS Safety Filter on pfSense 2.4

The following steps show how to install DNS Safety filter with corresponding UI plugin on pfSense 2.4 64-bit. Note, that after installation you must follow [several additional required steps](/config/pfsense/) before enabling the filter for actual use.

## Add reference to DNS Safety repository

Login into pfSense terminal console and run the following commands to install the reference to DNS Safety repository into the system.

	fetch -q -o /usr/local/etc/pkg/repos/dnssafety.conf https://raw.githubusercontent.com/diladele/dnssafety-pfsense-repo/master/dnssafety.conf
	pkg update

## Install DNS Safety

Now run the following commands in the console to install the latest version of DNS Safety Filter.

	pkg install dnssafety

After installation is complete, ensure you have `/opt/dnssafety/bin/dsdnsd` daemon binary present on your pfSense system.

## Install UI Plugin for pfSense

Finally, to install pfSense UI plugin for DNS Safety, run the following commands in the terminal console.

	pkg install pfSense-pkg-dnssafety

Note, before enabling DNS Safety for the first time we need to perform [several additional required steps](/config/pfsense/).
