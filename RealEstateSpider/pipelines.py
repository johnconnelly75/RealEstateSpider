import sys
import MySQLdb
import hashlib
from datetime import datetime
from scrapy.exceptions import DropItem
from scrapy.http import Request


class ReivPipeline(object):
    def __init__(self):
        print "Opening DB connection."
        self.conn = MySQLdb.connect(user="scrapydb",passwd= "denied957", db="realestatedb", host="192.168.100.57", port=1306, charset="utf8", use_unicode=True)
        self.cursor = self.conn.cursor()

    def process_item(self, item, spider):
        try:
            self.cursor.execute("""INSERT INTO auction_results (prop_street_address, prop_num_bedrooms, prop_sale_price, prop_type, prop_suburb, prop_url, auc_method, auc_saledate, auc_agent, data_source, data_ins_TS) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)""",
                           [
                            item['prop_address'].encode('utf-8'),
                            item['prop_bedr'].encode('utf-8'),
                            item['prop_price'].encode('utf-8'),
                            item['prop_type'].encode('utf-8'),
                            item['prop_suburb'].encode('utf-8'),
                            item['prop_url'].encode('utf-8'),
                            item['auc_method'].encode('utf-8'),
                            item['auc_saledate'],
                            item['auc_agent'].encode('utf-8'),
                            item['src_url'].encode('utf-8'),
                            datetime.today()
                           ]
            )
            
            self.conn.commit()
            print ".",

        except MySQLdb.Error, e:
            print "Error %d: %s" % (e.args[0], e.args[1])

        return item



# NOTE:
#     Need a method to close the conn, below doesn't seem to work

    def __exit__(self):
        print "Closing DB connection."
        self.conn.close()

