
C:

cd "C:\Documents and Settings\Aiwendil\Application Data\Thunderbird\Profiles\ocey6n8c.default\News"

ren  news.eternal-september.org.rc  news.eternal-september.org_ORIG.rc
ren  news.mozilla.org.rc            news.mozilla.org_ORIG.rc
ren  ssl-us.astraweb.com.rc         ssl-us.astraweb.com_ORIG.rc
ren  text.giganews.com.rc           text.giganews.com_ORIG.rc

sortdup -r < news.eternal-september.org_ORIG.rc > news.eternal-september.org.rc
sortdup -r < news.mozilla.org_ORIG.rc           > news.mozilla.org.rc
sortdup -r < ssl-us.astraweb.com_ORIG.rc        > ssl-us.astraweb.com.rc
sortdup -r < text.giganews.com_ORIG.rc          > text.giganews.com.rc

erase news.eternal-september.org_ORIG.rc
erase news.mozilla.org_ORIG.rc
erase ssl-us.astraweb.com_ORIG.rc
erase text.giganews.com_ORIG.rc










