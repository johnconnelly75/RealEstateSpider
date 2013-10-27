import re

re_address_del2 = re.compile('/ ([0-9])')
item = re_address_del2.sub(r'/\1', '3/ 2345 Fin')

print item
exit
