function [Y,Xf,Af] = SOFC_nn(X,~,~)
%SOFC_NN neural network simulation function.
%
% Auto-generated by MATLAB, 08-Nov-2021 14:11:40.
% 
% [Y] = SOFC_nn(X,~,~) takes these arguments:
% 
%   X = 1xTS cell, 1 inputs over TS timesteps
%   Each X{1,ts} = 8xQ matrix, input #1 at timestep ts.
% 
% and returns:
%   Y = 1xTS cell of 1 outputs over TS timesteps.
%   Each Y{1,ts} = 6xQ matrix, output #1 at timestep ts.
% 
% where Q is number of samples (or series) and TS is the number of timesteps.

%#ok<*RPMT0>

% ===== NEURAL NETWORK CONSTANTS =====

% Input 1
x1_step1.xoffset = [-3.06861536594312;-1.94844309687998;-0.747718144823527;-0.185907708816494;-1.24011877820575;-0.194865687712192;-0.502549614093466;-1.0744385420077];
x1_step1.gain = [0.539250384648967;0.341211030380429;0.462783459241746;0.267333374475063;0.497901683200313;0.297685349680154;0.469693468413209;0.672342508414225];
x1_step1.ymin = -1;

% Layer 1
b1 = [-1.6791071893189906117;-3.2609867299872750124;-7.0918336791042069223;1.955342546593900277;13.952168995762923132;8.5452928708640722988;4.7711286297448642912;15.990274216471686231];
IW1_1 = [-0.97943969877612746533 0.55106884036272008043 0.30945685353886043245 -1.2921082899756541895 -0.41747925651178097173 -0.37533049086554870488 -0.94141127241442157381 -0.071134260100056467824;3.2147219744176847023 -0.013975927038992488893 -2.9245242769038970465 7.6898455421787144104 -2.6902355327852225386 -6.6193142672652145464 1.3496602365426479953 -1.1711572302954438296;10.6717707035964402 0.095975325617438045356 9.0191930639004027626 1.1651692800961788166 2.2014307028362276597 -1.0508240840472469202 -5.8162066233977824936 0.70238838198505459953;-3.6296099318903407571 -1.8970035925904742413 2.8516051984901995553 -15.154320557984387818 -0.794963266514211786 14.452147968912615994 -0.22269411460175556061 1.4422469076999504534;-15.441489106670706732 1.952219752470075953 -1.7508655275682272201 0.39437749240977554299 -0.96632911354222772449 0.27342064628185996922 0.29150219357218032368 -0.6276768556024977519;1.2104958034055397498 3.1655200278832080762 25.612216042916831071 4.5552828811463061953 -1.798927667761272442 -10.965372693706585849 -10.90085937338829325 -0.23920056547809628866;0.52554329535555710518 -0.70785584148373603686 3.3097907416979697182 19.036155315629269325 0.60861500566490611686 -20.665515164659414182 2.558912582358016774 0.10593886068921348764;-3.6603504097397037143 -2.0084297923928158269 -7.1961241691917550156 1.1126032764710402923 1.0469124092411998816 17.311288291639744585 4.4009525551588275505 -0.51065375313241712085];

% Layer 2
b2 = [4.3624124942107247449;-1.9219387544096728782;-6.4153538375534120419;10.700879915867334446;3.9665967576528533556;-4.8449989063212601792;11.066896986267671821];
LW2_1 = [1.7265159978886168712 -0.62402218686720878349 -1.9193393458327212553 0.90618529755271259862 -0.42337664539929703578 0.85062783192843249847 -6.2597538732360797908 -1.2994366549594438265;18.01847899461534297 0.82196238573303503916 -0.46540656813344455367 -2.7726159482649355148 -2.7138325377755618817 -2.8810777137119836233 17.109678139430727128 5.577178159036807692;-12.41988944155218455 -0.80903554223756113384 7.8666799692697413349 -6.5442073788601407003 1.0111707099825228973 7.2267468828330576613 -6.4646012590967734113 -4.7081075803694520943;-2.2684544307418512687 5.9410529232105071529 -3.612151982547401996 2.0891004305428970689 -4.4083915851537307518 0.53847644593127974577 -1.8664492782979658081 6.0216902078935481413;-3.3148328819720043192 -5.2607281449325373757 -15.236061817409737529 -8.6081056800138266993 0.45737861007939045743 18.60256948157481105 -9.2306933188140103397 -6.6323789579617580259;-5.0058832499013119488 -13.216619782015690987 0.19366531616540644256 -1.0378191141460733071 3.1178531151282595779 -15.541237160781475879 -0.78670444247034432284 7.4147385870662834151;2.7548501231056410354 1.1686087498360968606 0.60990424682741528617 -1.1820745633810083586 -2.6805343388428526374 -2.8151249179352109131 -0.97871591529063173276 5.4993717875583820742];

% Layer 3
b3 = [-2.2541489213064465069;-4.1989133919759975555;-26.355165823848629714;0.53110465266701012421;4.0894385762453930866;0.52940221756679739507];
LW3_2 = [-0.42402141590465913801 1.1145129529860697826 -5.3676477201735695033 9.1063263384471682116 -14.192997831158749023 14.215086534723930356 -18.504337311040995218;-9.7577456016679580131 -8.2195580508061123481 9.6146456171302432381 2.9771698904685455211 2.3563905201832158198 -3.2752767522202992367 13.724808060302702728;10.345924137111410346 3.3670796504801114857 16.208322896279995007 12.311045837957644622 14.590144508096743792 -19.798071123554869644 -12.370912085080753684;-4.1510167712689636232 -8.3739794066638868486 -0.51728927832184168345 -3.6134810166583455349 3.20122348258317313 -2.0681251984453767889 7.3651631308068470361;-0.054871346958185109044 2.9374483819884158464 -5.2930984935133080782 -2.9097597041011744601 -2.0896881830913063283 -0.34433290079548595219 -2.5221883599987280355;-0.53753835230717039728 -3.3367995374246666174 0.18422377628685160378 -1.5574502573876927158 1.7860904126426440097 -0.10768640451687809534 0.24583429781025628591];

% Layer 4
b4 = [-0.29775352027225476803;-0.49137272795912750878;-0.36106858317680518011;-0.6516702493155740461;-0.93609014459692230226;-0.2321511647786371757];
LW4_3 = [-0.17532609612781172026 -0.031617359938711911416 -0.11278776771767802523 0.66454691189139447616 -0.16286226099163986225 -0.19107793532027869676;-0.01578103854019993757 0.32807066099548509719 0.010322899425864093953 0.68077661725506000145 0.43459968686549788064 -0.082502532449655358038;-0.07302644097324093031 -1.0485588776587047022 -0.12860513952776589375 0.96930542521940366019 -1.0153539122889450041 -0.29717746018951324283;0.00062554443538784081091 -0.63991102976018066073 -0.064649354025156924308 0.60505336398013032095 -0.53053044971742191471 -0.17346083792594010897;-0.017382946881687424273 -0.10904871782336775232 -0.02639927794936299324 0.10358900257691082414 -0.1427899701427203516 -0.068736378194413236264;0.087849712713840441558 0.19390075168097745117 0.0045234832324298496903 -0.20589701070929056215 0.21568070908662703711 0.80880497179498700433];

% Output 1
y1_step1.ymin = -1;
y1_step1.gain = [0.54689029260216;0.722471907108075;0.586022478289733;0.339758380324897;0.0975431359614734;0.62031979462852];
y1_step1.xoffset = [0;0;0;0;0;0];

% ===== SIMULATION ========

% Format Input Arguments
Xcell = {X};

% Dimensions
TS = size(Xcell,2); % timesteps
if ~isempty(Xcell)
  Q = size(Xcell{1},2); % samples/series
else
  Q = 0;
end

% Allocate Outputs
Y = cell(1,TS);

% Time loop
for ts=1:TS

    % Input 1
    Xp1 = mapminmax_apply(Xcell{1,ts},x1_step1);
    
    % Layer 1
    a1 = tansig_apply(repmat(b1,1,Q) + IW1_1*Xp1);
    
    % Layer 2
    a2 = tansig_apply(repmat(b2,1,Q) + LW2_1*a1);
    
    % Layer 3
    a3 = tansig_apply(repmat(b3,1,Q) + LW3_2*a2);
    
    % Layer 4
    a4 = repmat(b4,1,Q) + LW4_3*a3;
    
    % Output 1
    Y{1,ts} = mapminmax_reverse(a4,y1_step1);
end

% Final Delay States
Xf = cell(1,0);
Af = cell(4,0);

% Format Output Arguments
  Y = Y{:};
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
