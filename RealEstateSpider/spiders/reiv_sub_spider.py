import re
import sys
import MySQLdb
import hashlib
import datetime

from RealEstateSpider.util import Reiv_Util
from scrapy.spider import BaseSpider
from scrapy.selector import HtmlXPathSelector

from RealEstateSpider.items import REIVAuctionItem

class ReivSubSpider(BaseSpider):
    name = "REIVSub_Sp"
    allowed_domains = [
        "http://www.realestateview.com.au/portal/",
    ]
    RU = Reiv_Util()
    start_urls = RU.get_urls()

    #Function to parse URL response object
    def parse(self, response):

        hxs = HtmlXPathSelector(response)
        auction_ress = hxs.select('//div[contains(@class, "pd-table-inner")]/table/tr')
        items = []

        for auction_res in auction_ress:

            # Check if the td element text exists in a particular tr
            if len(auction_res.select('td/text()')) > 0:

              item = REIVAuctionItem()

              item['src_domains'] = self.allowed_domains
              item['src_url'] = response.url

              # Check if xpath (/table/tbody/tr[N]/td[N]/a) has
              # a href item if so, take both URL and street address
              pre_item_prop_addr_href = auction_res.select('td[1]/a/@href').extract()
              if len(pre_item_prop_addr_href) > 0:
                pre_item_prop_addr_href = pre_item_prop_addr_href[0].lstrip().rstrip()
                pre_item_prop_addr = auction_res.select('td[1]/a/text()').extract()[0].lstrip().rstrip()
              else:
                pre_item_prop_addr_href = ''
                pre_item_prop_addr = auction_res.select('td[1]/text()').extract()[0].lstrip().rstrip()

              item['prop_url'] = pre_item_prop_addr_href

              # Derive property address
              # RegEx to replace HexA0 and contigious whitespaces as a space
              item['prop_address'] = pre_item_prop_addr
              re_address_del1 = re.compile('\\xa0|\s\s+')
              item['prop_address'] = re_address_del1.sub(' ', item['prop_address'])
              re_address_del2 = re.compile('/\s+([0-9])')
              item['prop_address'] = re_address_del2.sub(r'/\1', item['prop_address'])
              re_address_del3 = re.compile('\s\s+')
              item['prop_address'] = re_address_del3.sub(' ', item['prop_address'])

              # RegEx to find suburb and replace %20 string as a space
              re_getsuburb = re.compile('suburb=([a-zA-Z%20]+)')
              re_space_rel = re.compile('%20')
              item['prop_suburb'] = re_getsuburb.search(item['src_url']).group(1)
              item['prop_suburb'] = re_space_rel.sub(' ', item['prop_suburb'])

              item['prop_bedr'] = auction_res.select('td[2]/text()').extract()[0].lstrip().rstrip()

              item['prop_price'] = auction_res.select('td[3]/text()').extract()[0].lstrip().rstrip()
              re_price_del = re.compile('[$,a-zA-Z]')
              item['prop_price'] = re_price_del.sub('', item['prop_price'])

              item['prop_type'] = auction_res.select('td[4]/text()').extract()[0].lstrip().rstrip()
              item['auc_method'] = auction_res.select('td[5]/text()').extract()[0].lstrip().rstrip()

              item['auc_saledate'] = auction_res.select('td[6]/text()').extract()[0].lstrip().rstrip()
              item['auc_saledate'] = datetime.datetime.strptime(item['auc_saledate'], "%d/%m/%Y").date()

              item['auc_agent'] = auction_res.select('td[7]/text()').extract()[0].lstrip().rstrip()

              items.append(item)

        return items
