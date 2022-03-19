#!/bin/sh

echo -n '' > /etc/virtual/domains
echo -n '' > /etc/virtual/domainowners

mkdir -p /etc/virtual/`hostname`
chown mail:mail /etc/virtual/`hostname`
chmod 711 /etc/virtual/`hostname`
echo `hostname` >> /etc/virtual/domains

for u in `ls /usr/local/directadmin/data/users`; do
{
       for d in `cat /usr/local/directadmin/data/users/$u/domains.list`; do
       {
               echo "$d: $u" >> /etc/virtual/domainowners
               echo "$d" >> /etc/virtual/domains

               DMN=/etc/virtual/$d

               mkdir -p $DMN
               chmod 711 $DMN
               chown mail:mail $DMN

               touch $DMN/aliases
               if [ ! -s $DMN/aliases ]; then
                       echo "$u: $u" > $DMN/aliases
               fi
               touch $DMN/autoresponder.conf
               touch $DMN/filter
               touch $DMN/filter.conf
               touch $DMN/passwd
               touch $DMN/quota
               touch $DMN/vacation.conf
               chown mail:mail $DMN/*

               mkdir -p $DMN/majordomo
               chmod 751 $DMN/majordomo
               chown majordomo:daemon $DMN/majordomo

               mkdir -p $DMN/reply
               chmod 700 $DMN/reply
               chown mail:mail $DMN/reply

               for p in `cat /usr/local/directadmin/data/users/$u/domains/$d.pointers 2>/dev/null`; do
               {
                       echo "$p: $u"  >> /etc/virtual/domainowners
                       echo "$p" >> /etc/virtual/domains
                       ln -s $d /etc/virtual/$p
               };
               done;
       }
       done;
}
done;
chown mail:mail /etc/virtual/domains
chown mail:mail /etc/virtual/domainowners
chmod 644 /etc/virtual/domainowners
chmod 644 /etc/virtual/domains
