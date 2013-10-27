import sys
import MySQLdb
import hashlib

from scrapy import log

class Reiv_Util:

    def get_urls(self):
        urls = []

        print "Util connection msg..."
        #log.start(loglevel=log.WARNING)
        #log.msg("Connection to MySQL to get starting URLs", level=log.INFO)
        self.conn = MySQLdb.connect(user="scrapydb",passwd= "denied957", db="realestatedb", host="192.168.100.57", port=1306, charset="utf8", use_unicode=True)

        self.cursor = self.conn.cursor()

        self.cursor.execute('SELECT url FROM reiv_src_url')

        #rows = self.cursor.fetchmany(1)
        rows = self.cursor.fetchall()
        
        # Unpack tuple of results
        urls = [ seq[0] for seq in rows ]

        self.conn.close()
        return urls

