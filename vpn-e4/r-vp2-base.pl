#!/usr/bin/perl

use strict;
use warnings;
 
my $version = "0.4"; 
my $host   = "R-vp2";
my $remhost   = "R-vp1";
my $domain = "gsb.lan";
my $ip1    = "172.16.128.254"; # eth0 : reseau agence
my $ip2    = "10.0.0.2";   # eth1 : liaison
my $remip  = "10.0.0.1";
my $mask   = "255.255.255.0";

my $mynet  = "172.16.128.0";
my $remnet = "192.168.1.0";

my $gw     = "10.0.0.2";
my $dns1   = "172.16.0.6";
my $dns2   = "172.16.0.1";

sub putconf {
        my ($file, $msg)= @_;
        print "Generation du fichier $file ...\n";
        my $dat = `date`;
        open (FILE, ">$file") or die "Erreur ecriture fichier $file : $! \n";
        print FILE "### $version - putconf - $dat" if ($file ne "/etc/hostname") ;
        print FILE $msg;
        close FILE;
};
 
 putconf("/etc/hostname", "$host\n");
 
putconf ("/etc/hosts",
"127.0.0.1      localhost.localdomain localhost
127.0.1.1       $host
$ip1     $host.$domain $host
$ip2     $host.$domain $host
$remip $remhost.$domain $remhost 

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
");

putconf("/etc/hostname", "$host\n");
 
putconf ("/etc/hosts",
"127.0.0.1      localhost.localdomain localhost
127.0.1.1       $host
$ip1     $host.$domain $host
$ip2     $host.$domain $host
$remip $remhost.$domain $remhost 

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
");
 
putconf ("/etc/network/interfaces",
"
# The loopback network interface
auto lo
iface lo inet loopback
 
# The primary network interface
allow-hotplug eth0
iface eth0 inet static
        address $ip1
        netmask $mask
        up /root/iptables.sh

allow-hotplug eth1
iface eth1 inet static
        address $ip2
        netmask $mask
    up route add -net 192.168.1.0 netmask 255.255.255.252 gw 10.0.0.1
	up /sbin/sysctl -w net.ipv4.ip_forward='1'

");
 
putconf ("/etc/resolv.conf",
"domain $domain
nameserver $dns1
nameserver $dns2
");
