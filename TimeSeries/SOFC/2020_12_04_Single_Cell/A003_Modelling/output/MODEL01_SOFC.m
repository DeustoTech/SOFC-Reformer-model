function [Y,Xf,Af] = MODEL01_SOFC(X,~,~)
%MODEL01_SOFC neural network simulation function.
%
% Auto-generated by MATLAB, 16-Mar-2021 07:33:24.
% 
% [Y] = MODEL01_SOFC(X,~,~) takes these arguments:
% 
%   X = 1xTS cell, 1 inputs over TS timesteps
%   Each X{1,ts} = 30xQ matrix, input #1 at timestep ts.
% 
% and returns:
%   Y = 1xTS cell of 1 outputs over TS timesteps.
%   Each Y{1,ts} = 9xQ matrix, output #1 at timestep ts.
% 
% where Q is number of samples (or series) and TS is the number of timesteps.

%#ok<*RPMT0>

% ===== NEURAL NETWORK CONSTANTS =====

% Input 1
x1_step1.xoffset = [0.220711391188418;-0.785826533977772;-1.25634024379094;-0.0714314361975021;-0.259884570802151;-1.79077406372002;-0.276277049261076;-2.38484668708159;-1.10462478252951;-1.0691346338849;-0.319927136223361;-0.374396571565005;-0.0714314361975021;-0.259884570802151;-1.79077406372002;-0.276277049261076;-2.38484668708159;-1.10462478252951;-1.0691346338849;-0.319927136223361;-0.374396571565005;-0.0714314361975021;-0.259884570802151;-1.79077406372002;-0.276277049261076;-2.38484668708159;-1.10462478252951;-1.0691346338849;-0.319927136223361;-0.374396571565005];
x1_step1.gain = [406.166738664338;0.506617998136642;0.285183795250523;2.85171986667843;0.669884747818768;0.763920067143812;0.805307247866163;0.530558089351831;0.763794742722342;0.978198667808455;0.255378816321154;0.34845305852434;2.85171986667843;0.669884747818768;0.763920067143812;0.805307247866163;0.530558089351831;0.763794742722342;0.978198667808455;0.255378816321154;0.34845305852434;2.85171986667843;0.669884747818768;0.763920067143812;0.805307247866163;0.530558089351831;0.763794742722342;0.978198667808455;0.255378816321154;0.34845305852434];
x1_step1.ymin = -1;

% Layer 1
b1 = [-1.6027919377600230444;1.103639171781468864;-0.84628926102969248557;-1.0344570483964177221;-0.98079118761604999754;-0.75586216413960460869;-0.50868974121122045862;0.052223725625087098756;0.76842400418785483662;0.29484911990485873634;0.31552444023254183625;-0.41451125507972108597;0.27148528521376658063;0.66022655584410749885;0.15187868889781883097;0.37631229224811835188;-1.5438099286456548054;-1.1318234163146421167;-0.84700601087524207689;-1.9862706831685279507];
IW1_1 = [0.0089798007909337989457 -0.17756882315974650832 0.084651625914127323624 -0.19116901569104535752 -0.46273010630663591325 0.24202003217324927209 0.2872522152799726336 -0.01058578176718694662 0.23433382642965588927 0.19731716416159836291 0.07159044588561803979 0.056733778035639476078 0.41845170552336252712 0.097333172896807332308 -0.19248339105730394305 -0.046479559345565461814 -0.23285523804822497174 -0.50338981873627619557 -0.040618520187871730298 0.29154743122373477648 0.47866749380694334493 0.084423450599411253847 0.25851084311874816812 -0.28438057686627310483 0.035391982644921667067 0.63554762332176983897 -0.3362780742268259293 -0.13427678279796856353 0.21097673068512037831 -0.29918708822109130185;-0.00070725099540998098355 -0.1876018139113832528 0.14312945965530182724 -0.0125392659394170259 0.13278668383122452235 -0.55901807079643384135 -0.53309202177779113629 0.38851681756693146053 -0.16579320844313752414 -0.50584200173075810625 0.41141692732112289388 -0.10220455682547861798 0.13047456628123782485 -0.33582814657203435837 0.30263906171935461842 0.1164849868888334361 -0.38723619655165220088 -0.009692300140940265582 -0.10973230511403540832 0.45093397378767141603 -0.073411850975476117265 0.00087202992380862396748 0.030535089074188115355 -0.013203076647661076901 0.085702773400631801493 0.2057251761909993093 -0.69809603106034068265 0.076513639225350635331 0.49701576628408489222 0.24722899252826488481;-0.0044585952384167239562 0.63827163875596182319 0.21303352690435159444 0.042926102155633215351 -0.30998400529452430074 0.0098138921065565390411 -0.4132698575966659571 0.40761581166223576078 0.50537050770309943637 -0.00042859697181095706559 -0.088432323783774677284 0.028086944042661043941 0.025600783420943108715 -0.10633983428520078773 -0.043412624457771657738 -0.37079093716396077651 -0.12641475226472473348 0.6828642330597958221 -0.46168632520490016091 0.17039612494214950722 0.0059563086561537558969 -0.17689213250235347186 0.17972438712280472406 -0.00085540869348568575325 -0.13058340198113091435 -0.16266221188925289454 -0.012572221648461173391 0.0072109425525818575745 0.32191715110293533941 0.38822824898144830952;-0.017226002321536870721 0.18575696204011338253 -0.084142315939788853152 -0.064537819884632363632 -0.39400704428435096016 -1.071948824493843988 0.20576611332323610504 -0.37831544286739254845 0.38741222528090513144 -0.63728909137805156426 -0.30424442956707586916 -0.16003410882023416661 -0.12453305184700567965 0.0071751223834952016639 0.67679999126987111513 0.047938561372505510139 0.015812776500217701203 0.20789620331597113978 -0.5614218731894343728 0.42733477690654880776 -0.28828653612810312135 0.07035100564050381089 0.24572870818570408114 0.082591796312488752196 -0.11577620454912682102 -0.31482207363459990823 -0.62584493980262334567 -0.39298334697770831436 0.42757658436176210204 0.29290973625404020941;0.022388668124592395886 0.34309230584169503331 -0.15530510323030130571 0.16890480587870687623 0.27774235443842582027 0.54636625796269244759 0.7231632720911700396 0.20235009016975294416 -0.30135125574472154675 0.028159130650017120956 -0.14999550022333871246 0.2136151425471914389 0.18747756927925460224 0.21569397631386252878 -0.24180453650923483533 0.057629382942517563826 -0.10931177807139054459 0.29516521707035520139 0.16238507311896488439 -0.0032422796096706371465 0.27637236322097857855 -0.14554761726097176222 0.061689030888531719288 -0.12529740768714614507 -0.06957085106512185535 -0.19878202242414264034 -0.37737601115393004658 0.1051696587913293901 -0.1656124088402188832 0.4626284562061629968;-0.0023734544824275589404 0.17714967825743982432 -0.018815724284563441204 -0.31429200532841072846 -0.28836052707692755304 0.1234893521219564555 0.25365313036427256099 0.12528598659443909713 -0.34917905573725921409 -0.10518620352407440088 -0.53996868208191217686 -0.41842437694045003793 0.00076817176740060682041 0.27717055427763148678 0.099604827296651432533 -0.014087547115531203271 0.11015228073439456424 0.33907781341050818869 -0.034259737950773978821 0.1661035383819307043 -0.030285846462050833305 0.075881012178836831916 -0.29982869612720186581 -0.07950861420314261907 -0.059207454073357410063 -0.20180778661966924936 0.34095285735597741228 -0.18015339622852497015 0.14042700889136347508 0.18237800927672689899;-0.0020453206574671191527 -0.054274784630359201865 0.22460060984136462348 -0.19767821185734169021 0.91044347528095692645 -0.082153793501399258181 0.18940804203548350371 0.059288869151628779963 -0.23769050196425114962 0.0033863926164140315846 -0.0641144395197734418 0.071484113840449031718 -0.018052679269093801356 0.21514241894131491684 0.033314596647270933172 -0.32367463908275145856 -0.33301525276106669349 0.28217435426677939247 0.020804037344687661276 -0.14372552517928263716 -0.14270103023992872227 0.075811847085007405544 -0.38477997799610952345 0.021490442198739793944 -0.11135907889884075206 -0.49119912833736145696 -0.43259875350541426853 -0.035447781705855711809 0.067837039223221151651 -0.35155832254964503036;0.0020680286919675032291 -0.25179744313535629141 -0.0022578561688245540884 -0.24903934597509153059 -0.1670417130406063877 0.61873568636909537233 0.53583177688951255657 0.37917130503731932833 -0.52372661820803390054 -0.20112345743745765891 0.089466558756919653539 0.50382424702139150252 0.1037688981262697846 -0.11039617652837829809 -0.40433939485824510474 -0.17372702414838153695 -0.11040011835650587191 -0.2827421753909525326 0.41806417313279975456 0.024894102719999373907 -0.078630330476746806978 0.03952025447780722206 0.16982116513551617776 0.049983137293407808865 -0.063914344579021689641 -0.013794558173157837194 0.16312687506306203233 0.36573833749123135783 -0.35086830654190953593 -0.093702301144292024504;-0.061250385909915015803 -0.11126162434395271694 -0.074327824244782389473 0.11148470800270610104 -0.4804466395483857899 0.082046689640773093344 -0.14463799605692703731 -0.61302704243938344053 -0.48411529927695362563 -0.18810523315122343324 -0.10985855045149243991 -0.10774779239993735602 0.097447297372526622827 -0.073185506106380693314 -0.17118769960101828942 -0.40453656626457579204 0.036774419077646822163 -0.042686004002114606715 0.26207655931571954833 -0.81990811081561787432 -0.61050654206933041568 -0.12988742836480623999 0.40215101252914831065 0.15641133921206545887 0.12356320817940270873 0.10344475942282257974 -0.66572346608388310862 -0.21112378039526949469 0.19040478510504266207 0.00870888562761716091;0.0049052526712283044119 0.025411008296564036035 -0.25444516225000773924 0.36539135536663058801 0.25067078907529416476 0.65865138040944859465 0.37367268128677505468 0.4953325374937220249 -0.15482376491048968625 0.3194317556488387444 -0.05400696093364353717 -0.51856607574024804475 -0.36919860827871575637 -0.40361215428332214428 0.055460744013842475097 -0.12361521047553750141 0.021561116770525662334 -0.53956330594624268837 0.030421333187401533582 -0.1500932787438733762 -0.15895910333005547344 0.094798922727629700291 -0.4413147615828268977 -0.48230019653461780882 0.13775439502887584786 -0.28943758593678697855 -0.48616382495648041706 -0.15674339520493915656 -0.40413774091150989065 0.051283078164897431817;-0.020090589945977146286 -0.20056683126276264595 0.32131285185551367034 0.0088373789469136827812 -0.076499332776119824406 -0.39617010569026939182 0.45336945582427617962 0.36933622255896425557 -0.1676391788864047272 -0.06375874252238841744 0.24422066969523276159 0.34056154301414087726 -0.13332959942391653385 0.14734040683276714012 0.69116534521964068105 0.23518944289942755876 -0.2008305517715275601 -0.074129365416000486677 0.06062735934226328588 0.42108905733044427189 -0.48404475318698347852 0.17121328064761873189 0.20433315997489065463 -0.087816168815789727442 0.010884408322192824434 0.28965869958342554957 0.19922461579995714986 -0.15605784813368486774 0.65968995027500332284 0.2961613648934166565;-0.0062271903358283734256 0.018357783887414977353 0.0085147263960848942888 -0.23521141273617507395 -0.59590844110006779832 -0.32033451691567349506 0.13735865905923058672 -0.89907528554080107241 0.63742832204619870318 -0.018805954222886014926 0.45950697114075284011 -0.34816331052542176527 0.13387334620533419827 0.12663625925730584432 0.31689190683159251805 0.29894537572966101147 -0.24545393331874695853 0.047647219928830301938 0.021004565693623456629 0.22598151343521907797 0.20603700721498210968 0.11012074611434551075 0.16048260238299955072 -0.056287553628059573685 -0.11568779140906503 0.026324485922168936597 0.39675184125721635331 -0.055284306357674513344 0.26742764572429239545 0.20566530358432455472;0.0075286886156088264621 -0.088456369554420377632 -0.014728568945081444569 -0.14085599371114587708 0.47050410717623569745 -0.37011532846908401506 -0.53403682541168828735 0.17080430045593225641 0.55252756284171278267 0.22665571192127301203 0.40163924180355886628 0.45862332593506804912 0.056917808151810141137 -0.23013862552675665163 0.10786574716692104436 0.040811697698752251451 0.19044521060088853703 -0.34479343484697533295 0.1236217026509608824 0.25191769251247070338 0.14430072762543474929 -0.06471890874711583308 -0.10048734461733756229 -0.01737363634466104409 -0.0021413823964439300356 0.10303914353433583917 -0.78966670706580488481 -0.22373521325660550296 -0.25904822281275902141 -0.06051400383681792422;0.0045141939124832206054 -0.05457682820821956049 -0.20292983446189133412 0.04733080790052247161 0.094355693661376471848 0.23808949700284359752 0.37721475104612772755 0.35595739217505945051 -0.11415402601397127424 0.73991724843729966832 0.068155942293619584116 -0.55696527001439666282 -0.0073934063089661668233 -0.06164405636838747593 -0.10562468951578174448 0.021767657466610152578 0.032314059113301991932 -0.28960497931297890517 -0.057803290940105125917 0.25649050084928110005 0.35884164433290555163 -0.046982337715373662101 0.022765300273072712478 0.087228459765848101459 0.034761921671241896581 0.33272134814320203366 0.008614614553355250115 -0.056832843712101337175 0.10573198596661309567 -0.030679992317871104118;0.0025462660250292331807 -0.37368717568349868463 0.026072771887556880216 -0.29206376880098877669 -0.21173961387034126447 0.14510013091362441995 0.05766400621088522277 -0.16791341078756441552 -0.14582315804455889263 -0.038423954308185487294 0.29165227407091265377 -0.30286010131087753861 0.095383601982727231339 -0.10929141997888065785 -0.02955513048610452706 -0.10699466676693220046 -0.27436610614749629145 0.41064562832099932299 0.16021071072303255667 0.10282126083851303444 0.14651191330292767656 -0.028181707164232981666 0.0039354927393357910098 -0.038211770607181526349 0.074660834266225509226 -0.041994847496792671315 -0.306109950732710967 0.0015755463767358869956 0.39541865355919353364 -0.095045978069250913745;0.011828489913936335656 0.45040249181253033672 -0.32212412849001192949 0.015483381153906815297 0.14128850885171406748 0.21776566556665058472 -0.19611374462821368203 0.29287594270797262519 0.85823333216286690206 -0.73982919769108168584 -0.41684529254689856037 0.29527629320817500025 -0.095625540723624571915 0.39133028506899819599 -0.14194931508029418055 0.21826739313207246806 -0.30357880164742223617 0.40460903239733181369 -0.75021191459278024904 -0.25611224249998654212 -0.14361703519311827537 -0.10987074652558348475 -0.29823988019497527091 -0.074648595281195620488 0.20913762868031102182 -0.14601920808067911373 0.30787402123472917825 -0.41479947727303068117 -0.0065455557360955497412 0.29469482239093575116;-0.020766238749770678934 0.24243109768460871511 0.42212027249797368089 -0.13112344402798159493 -0.27729413701230815059 0.12668746838241615182 -0.26634994970545000648 0.32678856237791165107 0.27655681029533796256 -0.41668655280645294781 0.43909856580653572333 0.42839024283580079411 -0.22021356230376193386 0.071498746183860525938 -0.36144837610424107588 -0.4069234796709519375 0.32144342110492696296 -0.019065091678581485429 0.15777569116996767451 0.39290768976281253977 0.18905153029817620136 0.33930877642631673829 -0.39331320963791471801 -0.48024216832273247668 -0.25062928842963005938 0.31745532537370146908 0.39040790521307960903 -0.1730317132430885807 -0.12085233214855657657 -0.17571364414925114139;-0.016511367572113286317 -0.35251408851118115617 0.066014686050101273329 0.045785362934730344797 0.2834335030084768059 0.14926430481212932255 0.97364065435211233357 -0.3026518540386955447 -0.26002218725740855465 -0.47002160569788103972 -0.41854679353295509703 -0.029422173260822581664 -0.37062469424057259415 0.54646728826203339047 0.0062191342523071693749 0.49063175041869516724 0.083540123012066383468 0.30928361772379642236 0.31175596809151390199 0.38036795682815494057 -0.38141231848710704933 -0.11503409127455525851 0.37360414275158965181 0.065706822570279599383 0.027038240547974753958 0.40277128910851944799 0.24238652750896139132 -0.30963673248256101678 -0.0052131895535415077869 -0.63718566739500570595;-0.017334104825160113333 0.10758167623171376037 0.095289805232485577657 -0.0052564594339701521328 -0.394587194533684682 -0.37412736607984131698 0.33564442675657085724 0.12526982625362054202 0.61000848155777498416 -0.38429809953205329442 0.083144227715620147579 -0.70720568956121732107 -0.051803480572751782474 0.15265589640241317149 0.71563381719703844652 0.24848965492407978917 -0.28258129282296118312 0.56751483768501331806 -0.25811106080239798466 -0.39243447453591556728 0.0044158983014418781016 0.00014614444642666946442 0.64512852349557958664 -0.085042215295211776027 0.10475663235374549354 0.22721863138920822545 -0.054662393206086096198 -0.28559877473249478674 0.29399700519368399121 0.23986392491993127618;0.0023807317513741743306 -0.046013861732608685173 0.10342798719997528534 0.25497340251101979769 -0.70424297003553226748 0.20738739375571932366 0.3565260075700413811 0.16522625912209776278 -0.10821796257513836836 -0.060922588626417140123 -0.043589945900106639998 0.46675429792373651638 -0.028873026452884840293 -0.13640310717571388355 0.030426517921088951785 -0.15683168496082280918 -0.285718243294866725 -0.066603064389319427407 -0.34525522564687061156 -0.41733175607566980192 -0.30983919745939442203 -0.080271778273684854521 -0.25111440524983408284 -0.30900193175709589344 -0.086168418573674923633 0.0052784772137639537556 0.25562995141550221012 0.31983776197717755929 -0.34137521387929020689 -0.043347852487854998671];

% Layer 2
b2 = [1.3961917219414516911;1.7922306037861190919;-1.2760474111122976915;1.2579359445034414833;1.0453114333293769267;0.85317554847085619318;-0.59343753133739751693;0.31839545837607535761;0.13870067740718375338;0.16458656804828375453;0.018449408043199059387;-0.60122176487466361117;0.56021705945246869085;0.61007535977207971722;0.22635384363891200565;1.0309929398986998894;1.3311746710265093263;-1.2891707582711680047;1.4687266439476671653;1.7665227496274740204];
LW2_1 = [-0.41836178355299608045 0.037493321499808308916 0.72085064873889115322 -0.031120829293092323875 0.11932755250513218948 0.029182782140448310093 0.095513526223668057669 0.30479446592196896004 -0.21029871850680670331 0.34032288660205722852 -0.46321068608273535672 0.50703955832331071285 -0.37003960806091013014 -0.80889770204960553812 0.16636510348800717662 -0.58621744605626513458 -0.12177644930485910513 -0.098611057551722183789 -0.16065105317507266669 -0.16911547549688490943;-0.71629191750448673037 0.32091822371521128154 -0.41102762406653847727 0.75290206482475707794 0.41658588706763333143 -0.34301597870947841962 0.024423798355794557047 0.11855157224560262941 -0.084682224667912753269 0.10012235587198099751 0.44905203786855307779 0.74145241946729767424 0.23477987031181651867 0.079661637604665075374 0.65849142784698200259 -0.58529244447825456987 -0.049737329422656656464 -0.37391407775027490912 -0.16410759506406358277 0.25586864072263315606;0.20083642446584340502 -0.095386917364099474415 0.77224279846471122202 -0.56259320890686426164 0.31169766799727977036 0.50872226716281332415 0.69548419783673243177 0.34761071572697099796 -0.027215546950382123875 0.46382067005519944658 0.56912412179228477616 -0.12609745444210773702 0.29182836153998220619 -0.42665521632023201137 -0.50365495992979913975 0.044329503689205400352 0.040857867630597219377 0.21014358720773348987 0.076704550179487962502 -0.0077275390459382838418;-0.29495414154063737122 -0.28899826734485767332 -0.17895820869452877533 -0.63935033833135235248 -0.32997659416552060918 -0.2416403607186323188 -0.57348102063199635214 -0.32011494009006252748 -0.11811921897331265074 0.43868125608801367132 -0.18670926200827411834 0.29040033488202193768 0.78803275873995037859 0.22836606211067636552 -0.18558996297174171208 0.22059774708724910752 -0.3996478161408350549 -0.19346608310953933296 0.49297697724501204908 -0.10483895632756699834;0.015450273330001519645 -0.46500268337189598622 -0.73239501993334732433 0.47735848109336703748 -0.019598272906976063612 -0.26677179098067965723 -0.28376802871464235078 0.90214941995113950846 0.53692016035249545691 0.36228297432091638441 0.17233806514045110769 0.09952414600622522256 0.71929278427003640051 -0.22050891227021932051 0.070841448120796443599 0.67233559283391419736 -0.71489740128145728981 0.17699300701787532009 0.48003409256585383158 0.48151280673563273682;0.25223748478647445292 -0.18334230730958372968 0.10722797399642400307 -0.044021269054705866597 -0.23425969951273281633 0.52025199096788787845 -0.70122128762863800144 -0.2554873962951267341 -0.15217149139883939801 -0.25027476246296714857 -0.26170013782019196924 0.2626796236643272886 0.50540301309123181195 -0.6924016113849962295 0.55226802312810296947 -0.065325155688001429466 0.067294468919357128267 0.36283226484966762948 -0.15527071712987655649 -0.61839572844019197184;0.066750937007317129313 -0.96832328964096958668 -0.66395361983695599939 -0.31960201947312555371 0.13831771588039945553 0.17494088925029982473 0.01953105792278018657 0.023000445884716478467 0.48763978210319863793 -0.37350587225110304379 -0.30480160690434715542 -0.093718103313071010607 0.011937780758850175672 -0.22560731508406089985 -0.52610952649190423358 0.19667903083771534622 0.32857862692806694138 -0.22003511940332934338 0.46559228975898181435 0.077297522469554999502;-0.1848093628841681324 -0.22153828806388622952 0.49393191422600113416 0.1502149467888451162 0.022991202273904935705 -0.18885745445167803624 -0.62989134955813652628 0.31441526670385400166 -0.27041443985250956938 0.12416170068385101732 0.10151881842429864855 0.30715946260713977711 -0.37726018166299823964 0.32311017383210616227 0.078175984802486331304 -0.13320261394956656176 -0.078311544633286919725 -0.09421690729204224013 0.015643524600885513887 0.42730041436003068922;0.046623104298288114977 0.67794471086067442656 0.33592256443619256112 0.299088340856452084 -0.51849458646992929722 -0.27312816120604732628 -0.37467053328737981444 -0.5192227428100310016 0.33830038161843539735 -0.13231774065912133009 -0.1828368195066741031 -0.24848960699602301583 -0.19262576832609928923 0.3722387010448218736 1.2275936946045302722 -0.65082327282502649979 -0.10165630803722053299 0.090005084590151510082 0.13029955086503711148 -0.24820791318430698857;-0.57574121775116449129 -0.22609574416490124671 0.43041176151834475982 -0.11794886812516797159 -0.23312552328562857751 -0.41367794727352630302 -0.22206376207881009521 0.29581520922887716285 -0.1930805803423460143 0.37820586522930721429 0.52682901141961158142 0.20494012087712701331 -0.70165514161162878537 -0.42742728491437609328 0.032605141110565886986 0.39303437438595162368 -0.15838648417083681097 0.20459465924249012336 -0.34277689394213478602 0.1062407784200155858;-0.56642909143310371523 0.5668887352736862173 -0.36118206980072342649 -0.78224615455638069061 -0.28829512555714292832 0.38226432028772588945 -0.14891660579833956857 -0.48578883428821123536 -0.3366471551041048671 -0.57748133928428435624 -0.49799900220532250517 -0.3381029145510003886 -0.15382156055696225017 -0.45656058149171013794 -0.20749841596392637477 -0.29452124616680036562 -0.29933472798706756146 -0.61395217225965859065 -0.0095701300265662765654 -0.40603897762544960415;-0.4345729547956663219 0.16472749199397196396 0.61313528525693139493 -0.31946709167557030273 -0.3783795349336967484 0.76816227193697550479 -0.37018064771187680906 0.1971300874068904474 -1.1312678603194050719 0.22085165690642577507 0.09257300042927638084 -0.67323341246286794171 -0.0057313206528005512796 -0.5976148540389787378 0.28385853697792357009 -0.3613802971922754903 -0.15675993374745195164 0.46445878871377976882 -0.73985216795163089021 -0.6449249247028309151;0.12459346528692273604 -0.37947538565072991279 -0.52309222883174888441 0.4179102949182458282 -0.019581911503348307935 0.21189425591872451671 0.50048992307320028239 1.0073687764398109312 0.1770312114866623987 -0.017104461512867315948 0.54268656487355348972 0.10552222865971566668 0.072629647237004130167 0.1633097714079657925 0.41641859080683218952 0.49665908357620719427 0.27645817377691511707 -0.33241360525862700959 0.61547332239986507485 0.36638017910656495157;-0.31011220214962270658 0.323039349405143561 0.43132126393128161768 -0.34669257454623397807 0.10177905251149677035 0.12470636253562861206 -0.33609030799200578787 -0.21902638197454932234 -0.19127933543638833691 -0.26387907403814342411 -0.05520992774108790524 0.0057118472206099139485 -0.075886724667650853893 0.39569149616248294743 -0.2029138638778155701 0.1269656478876353134 0.34753421005109569331 0.047165733773907404791 0.3597700903415164686 -0.20950825289872374024;0.39546836080080816078 0.2563124089238879022 -0.21350361629967953836 0.24432643686870231248 -0.012656440812535665191 0.45763701724427274797 0.20246329098428131332 0.5320245619775587631 0.024446543880326267878 0.31819311127794341898 -0.20412728380357988978 0.540231247997893127 0.043833796247880384145 0.05969410653040833209 -0.48618511845716499975 0.050007266383503022611 -0.42498270845240082583 -0.37843030638727759296 -0.16940302895579439912 0.64459442037925052116;0.007466248362818917253 0.31975701058916999875 0.12495721889597671828 -0.25353430679883298682 0.45297518778114675975 0.29725671776930573387 -0.50025040170561785313 -0.39843942066075538344 0.2631713208675924287 -0.026617654210006495841 -0.45668377689145905896 0.18300451701052106168 -0.47980383715660362975 0.081260605876376193479 0.42541384097691492538 0.052538178358743782559 0.21834328362060831386 0.3572282332814387118 -0.33200638936582527183 -0.24963170447222729487;-0.0056120115875474821041 -0.86556220825556917653 -0.066507123105572218957 -0.1192301119791465136 -0.44966584338524767661 0.14827695281347430534 -0.078431679784742913686 -0.44588396392297729998 0.42131043008826801755 -0.41837000709154953393 0.0023256738037482583767 0.2427033082519090279 0.098693231590895047489 -0.35537502160836653697 0.52617804183189109679 -0.050120655877383998855 -0.45864366110386428632 -0.59855331546922174724 0.37873156717684686168 -0.22712299045982645151;-0.38869686178542639521 0.064944769087791329176 0.37460252377638753041 -0.062061427456816795067 0.47292469741828485619 -0.21005791142592641907 0.66039899953881531225 0.58761750188269423756 -0.40640802819539262325 -0.31705817219977849852 -0.17137935573449816773 -0.43449372144048264976 -0.2551602931493145987 -0.014570628192974551668 -0.55735097579338666041 -0.040497678174942708385 -0.54988916346247551648 0.15263127538245097048 0.36624971277284967819 0.19098451243447001069;0.273710568736688864 -0.30183597494269487349 -0.54243077415820950549 -0.028726495388984144702 -0.32122317873331779348 0.033422078217634806907 0.27507940774996308964 -0.58764108632344291827 0.04838146939803190244 -0.65899422460422429904 0.21894399059593294687 0.34975080731618179986 -0.079431429868198219491 0.56156249461535556744 0.36387620328200098729 0.22650199036672485908 0.38418791492855519643 0.088240733352465058892 -0.0059456890752629379046 -0.15206578810433701854;0.22091704284180746498 -0.15484489141809282264 -0.27542648973616284946 -0.32280707024555616025 0.47009345603393576374 0.26100842799632167912 -0.033877788442117140466 0.37774636193707389342 0.71595583787048999724 0.59671624090933894635 0.23492664674892207999 -0.5003072520783526933 0.1589207758965093531 0.27186154363730002936 -0.52309464572564701168 -0.04903501427483591274 0.016896169408488929259 -0.16536416038565673881 0.1015368125044487646 -0.74376087536705437486];

% Layer 3
b3 = [0.47579446971557604051;0.69770531108067002091;0.53498568728824591467;0.69568685768358640154;0.82387177994697013972;0.015543209234861245574;-0.88686351174136690556;-0.46595208978437174796;-0.61972684659561361187];
LW3_2 = [0.44788283767039410721 0.19055908783981956311 0.31387796800426792654 -0.78535129067688136395 0.37487402658638668829 -1.014249953830270945 -0.59229128816119058776 0.47312234202004910255 0.24396532641833568178 0.9965352739743743582 -0.67624926832966725243 -1.1587554588975332859 -1.5286714096034388355 0.3130760271949541429 -0.2581383040756276559 0.37450991410294570683 0.11047257752284790622 0.58262282606732807011 -0.44199103464931627228 -0.427943102025265254;-0.16574538571001862231 0.49955281873273604809 0.19288992295378809549 -0.21557213126451638119 -0.067763017900275224203 -0.65010579285466552069 0.22292635051387910128 -0.75011368613192119792 -0.65784927809846149849 0.017680523730989085307 0.32002591535466634598 0.29331618651954910471 0.0094901795821586698576 -0.08316866773447034733 -0.94882768875377510032 -0.8492453004142289652 -0.39006877990527549782 -1.0603784632581774172 0.45081627522684825093 -0.71304734549928949772;0.54454961390199330129 -1.687165969160719925 0.10208332023259600319 -0.39729497152039489061 -0.39181406967527993013 -1.5902378978395972364 -0.28875305622851954457 -0.22482044450792842971 -0.26574058564515828929 0.96332066986590192403 0.63018591055910799792 2.477515743346697441 -0.40038771870128581076 0.58400885076835740151 0.020681694105927600491 0.39689259750793665082 1.314377182943335054 0.89101052665943325515 -0.73279840038885546427 0.80531395758322077416;-1.0767831059438552899 1.03702478439682233 0.61444395923662176173 0.17764997967016313285 0.78515511248457470206 -0.26831075716699176459 -0.19803934770514750041 0.47962881605849100319 0.016908390244357921622 -0.28463090191334150525 -0.62457107680595558286 -1.126726259378222128 1.552315201993246907 0.087156152083033372469 -0.9080625801229021965 0.58250556392550978391 0.14147791589314873129 0.64706863459133978633 -0.19394701976332853754 -0.036438755147427656644;-0.068374587262878816496 0.3522774368237072129 -0.14287240089191471926 -0.80338903506199976778 0.63308273403055459472 -0.24600806748429848714 0.28141330583822360412 0.29580179953990121122 0.15595736810826774099 -0.77881960234284353106 0.21135456125677234973 0.26861723759052824612 0.03063173498754051885 1.0391592988198650183 -0.037377508249264980444 -1.0179883902556967623 -0.76210278948498411111 -0.92144527146699084508 -0.0061827694686593806864 0.047945341968170414326;0.55295852750402918474 0.31410213207191645113 1.0105505472077083162 -0.033897324811548147638 0.6377101826246296401 0.44657853020790932996 0.31230047875076394348 0.68037902348720702417 -0.14919979021024667998 0.082465672763429614944 0.43027010129043324893 -0.16892829918752952367 -0.043073559659905058528 0.25616961047158676168 -0.39793161268502813543 -0.99123754064747859882 -0.30096323859498480546 0.42473911938904496122 0.6506526310687783532 0.46837886861248784198;-0.2478741582514753794 -0.42762031996278315749 -0.14658426294924359334 1.2375141977696111351 -0.24388481170771914019 -0.23707932148775243131 -0.017747855333090777064 0.98438710582818123029 -0.63036246124709072181 -0.36389380982519398122 -0.55481758948127124498 0.56249858761483884084 -0.33764948855951099072 -1.0926705522217177169 -0.53559603275214651141 -0.58325077198820796109 0.67764489120125215305 -0.13655151534711462702 0.66365873108301720595 0.99991353807763572181;0.21046865303972797645 0.069028114896090994601 0.6485732209508028312 0.10805130537874031715 -1.2363768636464496087 0.057214748086426188423 -0.46091474521180608726 0.18270647694391625726 -0.32169650677179983944 -0.007772622920518230949 0.087595281678070138764 -0.067244269373200118989 0.060653537190762538134 0.1692035127460576327 -0.22595126234548032484 -0.040785624888525814913 -0.00048223968007043028355 -0.65081125461081190675 0.21081132173348829384 0.45631452057735061301;-0.37874401178123351386 0.25083204312445261941 0.32564376241051151695 0.85755994533470181196 -0.17591499722228487457 0.39176537146794160327 -0.11065363063305787283 -0.097838128084812681085 -0.68675192157778452984 0.65329949740483295173 0.29369772642722130618 -0.078343311210287133739 0.054115717883078957862 -0.31089230579378052122 -0.31791861823439887536 -0.93743029640669739422 0.22897454869166014579 -0.62458360456381933901 -0.83417686573762916957 -0.22267581421790208496];

% Output 1
y1_step1.ymin = -1;
y1_step1.gain = [2.85171986667843;0.669884747818768;0.763928693404851;0.807994220267054;0.530558089351831;0.768476760645639;0.978198667808455;0.245011273994521;0.34845305852434];
y1_step1.xoffset = [-0.0714314361975021;-0.259884570802151;-1.79077406372002;-0.268018127741013;-2.38484668708159;-1.10462478252951;-1.0691346338849;-0.319927136223361;-0.374396571565005];

% ===== SIMULATION ========

% Format Input Arguments
isCellX = iscell(X);
if ~isCellX
  X = {X};
end

% Dimensions
TS = size(X,2); % timesteps
if ~isempty(X)
  Q = size(X{1},2); % samples/series
else
  Q = 0;
end

% Allocate Outputs
Y = cell(1,TS);

% Time loop
for ts=1:TS

    % Input 1
    Xp1 = mapminmax_apply(X{1,ts},x1_step1);
    
    % Layer 1
    a1 = tansig_apply(repmat(b1,1,Q) + IW1_1*Xp1);
    
    % Layer 2
    a2 = tansig_apply(repmat(b2,1,Q) + LW2_1*a1);
    
    % Layer 3
    a3 = repmat(b3,1,Q) + LW3_2*a2;
    
    % Output 1
    Y{1,ts} = mapminmax_reverse(a3,y1_step1);
end

% Final Delay States
Xf = cell(1,0);
Af = cell(3,0);

% Format Output Arguments
if ~isCellX
  Y = cell2mat(Y);
end
end

% ===== MODULE FUNCTIONS ========

% Map Minimum and Maximum Input Processing Function
function y = mapminmax_apply(x,settings)
  y = bsxfun(@minus,x,settings.xoffset);
  y = bsxfun(@times,y,settings.gain);
  y = bsxfun(@plus,y,settings.ymin);
end

% Sigmoid Symmetric Transfer Function
function a = tansig_apply(n,~)
  a = 2 ./ (1 + exp(-2*n)) - 1;
end

% Map Minimum and Maximum Output Reverse-Processing Function
function x = mapminmax_reverse(y,settings)
  x = bsxfun(@minus,y,settings.ymin);
  x = bsxfun(@rdivide,x,settings.gain);
  x = bsxfun(@plus,x,settings.xoffset);
end
