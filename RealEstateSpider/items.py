# Define here the models for your scraped items
#
# See documentation in:
# http://doc.scrapy.org/en/latest/topics/items.html

from scrapy.item import Item, Field

class REIVAuctionItem(Item):
    src_domains = Field()
    src_url = Field()
    prop_address = Field()
    prop_suburb = Field()
    prop_bedr = Field()
    prop_price = Field()
    prop_type = Field()
    auc_method = Field()
    auc_saledate = Field()
    auc_agent = Field()
