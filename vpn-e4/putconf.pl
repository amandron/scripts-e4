#!/usr/bin/perl
 
use strict;
use warnings;
 
my $version = "0.5"; 
my $host   = "S-mon";
my $domain = "gsb.lan";
my $ip     = "172.16.0.8";
my $mask   = "255.255.255.0";
my $gw     = "172.16.0.254";
my $dns1   = "127.0.0.6";
my $dns2   = "172.16.0.1";
 
# les paquets a installer 
my $packages = "aptitude update -y && upgrade -y";
 
sub putconf {
        my ($file, $comment, $msg)= @_;
        print "Generation du fichier $file ...\n";
        my $dat = `date`;
        open (FILE, ">$file") or die "Erreur ecriture fichier $file : $! \n";
        print FILE "$comment $version - putconf - $dat"  if ($comment);
        print FILE $msg;
        close FILE;
};
 

system "aptitude install -y $packages" if ($packages);
 
putconf("/etc/hostname", "", "$host\n");
 
putconf ("/etc/hosts", "#",
"127.0.0.1      localhost.localdomain localhost
127.0.1.1       $host
$ip     $host.$domain $host
 
# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
");
 
putconf ("/etc/network/interfaces", "#",
"
# The loopback network interface
auto lo
iface lo inet loopback
 
# The primary network interface
allow-hotplug eth0
iface eth0 inet static
        address $ip
        netmask $mask
        gateway $gw
	
iface eth1 inet dhcp
");
 
putconf ("/etc/resolv.conf","#",
"domain $domain
nameserver $dns1
");
 