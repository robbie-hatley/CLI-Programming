sed -n '/picasa/p'       < F:\Principal\Resources\www\3-URLs\urls9999.txt > F:\Principal\Resources\www\3-URLs\urls9999-01(picasa).txt
sed -n '/smugmug/p'      < F:\Principal\Resources\www\3-URLs\urls9999.txt > F:\Principal\Resources\www\3-URLs\urls9999-02(smugmug).txt
sed -n '/idnes/p'        < F:\Principal\Resources\www\3-URLs\urls9999.txt > F:\Principal\Resources\www\3-URLs\urls9999-03(idnes).txt
sed -n '/barnaland/p'    < F:\Principal\Resources\www\3-URLs\urls9999.txt > F:\Principal\Resources\www\3-URLs\urls9999-04(barnaland).txt
sed -n '/naver/p'        < F:\Principal\Resources\www\3-URLs\urls9999.txt > F:\Principal\Resources\www\3-URLs\urls9999-05(naver).txt
sed -n '/webshots/p'     < F:\Principal\Resources\www\3-URLs\urls9999.txt > F:\Principal\Resources\www\3-URLs\urls9999-06(webshots).txt
sed -n '/flickr/p'       < F:\Principal\Resources\www\3-URLs\urls9999.txt > F:\Principal\Resources\www\3-URLs\urls9999-07(flickr).txt
sed -n '/photofile/p'    < F:\Principal\Resources\www\3-URLs\urls9999.txt > F:\Principal\Resources\www\3-URLs\urls9999-08(photofile).txt

awk -f 'E:\scripts\present-urls.awk' < F:\Principal\Resources\www\3-URLs\urls9999-01(picasa).txt > F:\Principal\Resources\www\4-Links\links9999-01(picasa).html
awk -f 'E:\scripts\present-urls.awk' < F:\Principal\Resources\www\3-URLs\urls9999-02(smugmug).txt > F:\Principal\Resources\www\4-Links\links9999-02(smugmug).html
awk -f 'E:\scripts\present-urls.awk' < F:\Principal\Resources\www\3-URLs\urls9999-03(idnes).txt > F:\Principal\Resources\www\4-Links\links9999-03(idnes).html
awk -f 'E:\scripts\present-urls.awk' < F:\Principal\Resources\www\3-URLs\urls9999-04(barnaland).txt > F:\Principal\Resources\www\4-Links\links9999-04(barnaland).html
awk -f 'E:\scripts\present-urls.awk' < F:\Principal\Resources\www\3-URLs\urls9999-05(naver).txt > F:\Principal\Resources\www\4-Links\links9999-05(naver).html
awk -f 'E:\scripts\present-urls.awk' < F:\Principal\Resources\www\3-URLs\urls9999-06(webshots).txt > F:\Principal\Resources\www\4-Links\links9999-06(webshots).html
awk -f 'E:\scripts\present-urls.awk' < F:\Principal\Resources\www\3-URLs\urls9999-07(flickr).txt > F:\Principal\Resources\www\4-Links\links9999-07(flickr).html
awk -f 'E:\scripts\present-urls.awk' < F:\Principal\Resources\www\3-URLs\urls9999-08(photofile).txt > F:\Principal\Resources\www\4-Links\links9999-08(photofile).html

