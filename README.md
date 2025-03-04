# openssl-keylog

Add [`SSLKEYLOGFILE`](https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/Key_Log_Format) support to any dynamically linked app using OpenSSL 1.1.1+, including .NET 5 applications.

## Building

No dependencies. Just make it.

```shell
$ sudo apt install git build-essential
$ git clone https://github.com/wpbrown/openssl-keylog
$ cd openssl-keylog
$ make
cc sslkeylog.c -shared -o libsslkeylog.so -fPIC -ldl
```

The `.so` is built next to the `sslkeylogged` script. Add the project directory to your path.

```shell
$ export PATH=/home/foo/openssl-keylog:$PATH
```


## Usage 

Start a network capture on `eth0` in the background (your interface name may be different). Run your command with the `sslkeylogged` script. If you don't set `SSLKEYLOGFILE`, a value will be set and printed before running your command.

```shell
$ sudo dumpcap -q -i eth0 -w /tmp/output.pcapng &
$ sslkeylogged ./SimulatedDevice
*** SSLKEYLOGFILE set to /tmp/sslkeys-cOHTcLbk.txt ***
IoT Hub - Simulated Mqtt device.
Press control-C to exit.
02/24/2021 03:13:08 > Sending message: {"temperature":32.53831510550264,"humidity":63.50118943653125}
...
```

Set the `sslkeys` text file in your Wireshark [preferences](https://wiki.wireshark.org/TLS) before you open a capture file to see the decrypted TLS traffic.

The process of capturing during command execution can be automated with the `dumpcapssl` script. The script will automatically merge the secret keys in to the pcapng file so there is no need to change Wireshark preferences.

```shell
$ dumpcapssl eth0 ./SimulatedDevice
*** SSL keys: /tmp/dumpcapssl-iYOYPZd7.keys ***
*** Capture : /tmp/dumpcapssl-iYOYPZd7.pcapng from interface: eth0 ***
*** Starting Capture ***
Capturing on 'eth0'
File: /tmp/dumpcapssl-tiMD6a5K.tmp.pcapng
*** Starting Command ***
IoT Hub - Simulated Mqtt device.
Press control-C to exit.
...
^C
Exiting...
Device simulator finished.
*** Command Interrupted ***
*** Command Stopped ***
*** Stopping Capture ***
Packets captured: 134
Packets received/dropped on interface 'eth0': 134/0 (pcap:0/dumpcap:0/flushed:0/ps_ifdrop:0) (100.0%)
*** Merging Key Files ***
*** Embedding Keys ***
*** Stopped Capture : /tmp/dumpcapssl-iYOYPZd7.pcapng Keys: /tmp/dumpcapssl-iYOYPZd7.keys *** 
```

The file `/tmp/dumpcapssl-iYOYPZd7-dsb.pcapng` in the example above will contain the embedded DSB (Decryption Secrets Block).

# Credit 

The C code is forked from [sslkeylog.c](https://git.lekensteyn.nl/peter/wireshark-notes/tree/src/sslkeylog.c) by Peter Wu. Also thanks to Peter for his [StackExchange post](https://security.stackexchange.com/a/80174).