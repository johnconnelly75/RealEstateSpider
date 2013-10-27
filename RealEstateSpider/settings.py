# Scrapy settings for REIV project
#
# For simplicity, this file contains only the most important settings by
# default. All the other settings are documented here:
#
#     http://doc.scrapy.org/en/latest/topics/settings.html
#

BOT_NAME = 'RealEstateSpider'

SPIDER_MODULES = ['RealEstateSpider.spiders']
NEWSPIDER_MODULE = 'RealEstateSpider.spiders'
ITEM_PIPELINES = ['RealEstateSpider.pipelines.ReivPipeline']

LOG_LEVEL = 'INFO'
# Crawl responsibly by identifying yourself (and your website) on the user-agent
#USER_AGENT = 'REIV (+http://www.yourdomain.com)'
