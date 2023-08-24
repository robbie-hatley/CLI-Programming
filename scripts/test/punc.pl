#! /bin/perl -CSDA
use v5.36;
use strict;
use warnings;
use utf8;
use warnings FATAL => 'utf8';
use Sys::Binmode;
my $text = q$᠊᳓‾﹉-﹌_＿﹍-﹏︳︴‗-－﹣֊᐀᭠᠆᠇‐-–︲—﹘︱―⸺⸻⁓⹃⸗⹀⹝〜゠・･𐺭,，﹐︐⸴⸲⹁⹌⹎⹏՝،؍٫٬߸᠂᠈꓾꘍꛵𖺗、﹑︑､﹅﹆𖿢;;；﹔︔؛⁏⸵꛶⹉:：﹕︓։؞܃-܈࠰-࠾፡፣-፦᠄᠅༔៖᭝꧇᛫-᛭꛴!！﹗︕¡⹓՜߹᥄𞥞?？﹖︖⁈⁇¿⸮⹔՞؟܉፧᥅⳺⳻꘏꛷꫱𑅃𞥟‽⸘.．․﹒‥︰…︙᠁۔܁܂።᠃᠉᙮᭜⳹⳾⸰⸼꓿꘎꛳𖫵𖺘𛲟。︒｡··⸱⸳।॥꣎꣏᰻᰼꡶꡷᜵᜶꤯၊။។៕᪨-᪫᭞᭟꧈꧉꩝-꩟꫰꯫𐩖𐩗𑁇𑁈𑃀𑃁𑅁𑅂𑇅𑇆𑈸𑈹𑑋𑑌𑗂𑗃𑙁𑙂𑜼𑜽𑥄𑱁𑱂𑽃𑽄𖩮𖩯᱾᱿؝܀߷჻፠፨᨞᨟᭚᭛᭽᭾꧁-꧆꧊-꧍꛲꥟𐡗𐬺-𐬿𐽕-𐽙𐾆-𐾉𑂾𑂿𑅀𑇈𑇞𑇟𑊩𑜾𑥆𑻷𑻸𑽅-𑽏⁕⁖⁘-⁞⸪-⸭⸽⳼⳿⸙𐤿𐄀-𐄂𐎟𐏐𐤟𒑰-𒑴𒿱𒿲'＇‘-‛‹›"＂“-‟⹂〝-〟«»(（﹙⁽₍︵)）﹚⁾₎︶[［﹇]］﹈{｛﹛︷}｝﹜︸༺-༽᚛᚜⁅⁆⌈-⌋⧼⧽⦃-⦅｟⦆｠⦇-⦘⟅⟆⟦-⟯❨-❵⸂-⸅⸉⸊⸌⸍⸜⸝⸠-⸩⹕-⹜〈〈︿〉〉﹀《︽》︾「﹁｢」﹂｣『﹃』﹄【︻】︼〔﹝︹〕﹞︺〖︗〗︘〘-〛﴾﴿‖⸾⧘-⧛§⸹¶⁋⹍⸿@＠﹫*＊﹡⁎⁑٭꙳/／\＼﹨⹊&＆﹠⁊⹒#＃﹟%％﹪٪‰؉‱؊†‡⸶-⸸⹋•‣‧⁃⁌⁍′-‴⁗‵-‷〃‸※‿⁔⁀⁐⁁⁂⸀⸁⸆-⸈⸋⸎-⸖⸚⸛⸞⸟⹄-⹈꙾՚՛՟־׀׃׆׳״܊-܍࡞᠀𑙠-𑙬॰꣸-꣺꣼𑬀-𑬉৽੶૰౷಄෴๏๚๛꫞꫟༄-༊࿐࿑་-༒྅࿒-࿔࿙࿚𑨿-𑩆𑪚-𑪜𑪞-𑪢𑱰𑱱᰽-᰿၌-၏៘-៚᪠-᪦᪬᪭᳀-᳇⵰꡴꡵᯼-᯿꤮꧞꧟꩜𐕯𑁉-𑁍𐩐-𐩕𐩘𑱃-𑱅𐬹𐫰-𐫶𐮙-𐮜𑂻𑂼𑅴𑅵𑇍𑇇𑇛𑇝𑈺-𑈽𑑍𑑚𑑎𑑏𑑛𑑝𑓆𑗁𑗄-𑗗𑙃𑚹𑠻𑥅𑧢𑿿𖬷-𖬻𖭄𖺙𖺚𝪇-𝪋𐩿‼⁉〰〽$;
say length $text;
say $text =~ m/^\pP+$/ ? "YES" : "NO";
