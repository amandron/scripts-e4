#!/usr/bin/perl

sub putconf {
        my ($file, $msg)= @_;
        print "Generation du fichier $file ...\n";
        my $dat = `date`;
        open (FILE, ">$file") or die "Erreur ecriture fichier $file : $! \n";
        print FILE "### $version - putconf - $dat" if ($file ne "/etc/hostname") ;
        print FILE $msg;
        close FILE;
};

putconf ("/root/iptables.sh",
"
#!/bin/bash
 
## Règles iptables.
 
## On vide les règles iptables.
 
iptables -F
 
## On supprime toutes les chaînes utilisateurs.
 
iptables -X
 
## On supprime tout le trafic entrant.
 
iptables -P INPUT DROP
 
## On supprimer tout le trafic sortant.
 
iptables -P OUTPUT DROP
 
## On supprimer le forward.
 
iptables -P FORWARD DROP

## On accepte la boucle locale en entrée.
 
iptables -I INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
 
## On log les paquets en entrée.
 
iptables -A INPUT -j LOG
 
## On log les paquets forward.
 
iptables -A FORWARD -j LOG

## Permettre les connexions relatives au tunnel IPsec

iptables -A INPUT -p udp --dport isakmp -m comment --comment ipsec -j ACCEPT
iptables -A OUTPUT -p udp --sport isakmp -m comment --comment ipsec -j ACCEPT
iptables -A FORWARD -p udp --dport isakmp -m comment --comment ipsec -j ACCEPT
iptables -A FORWARD -p udp --sport isakmp -m comment --comment ipsec -j ACCEPT

iptables -A INPUT -p esp -j ACCEPT
iptables -A OUTPUT -p esp -j ACCEPT
iptables -A FORWARD -p esp -j ACCEPT

## Permettre les connexions des autres protocoles autorisés

iptables -A INPUT -p icmp -j ACCEPT
iptables -A OUTPUT -p icmp -j ACCEPT
iptables -A FORWARD -p icmp -j ACCEPT
");

system "chmod +x /root/iptables.sh";
