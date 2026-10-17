%% 35sqmm Coroflex Datasheet

% 35 sq.mm DC Cable
R35 = 0.527e-3; % Core resistance [Ohm/m]
L35 = 0.098e-6; % Core inductance [H/m]
C35 = 714.539e-12; % Core-screen capacitance [F/m]
R35screen = 4.461e-3; % Screen resistance [Ohm/m]
Len35 = 1; % Cable length [m]
Rcore35 = R35*Len35;
Lcore35 = L35*Len35;
Ccore35 = C35*Len35;
Rscreen35 = R35screen*Len35;

Total_Dout = 14.4; %Total Cable Outter Diameter with sheath %mm
Dconductor = 8.5; %Conductor Diameter %mm
Dcore = 10.5; %Insulated core outter Diameter %mm
%Geometric mean radius of conductor = Dcore/2  as for now
%Outer sheath Insulation wall thickness: 0.8mm (min)
 
%% HUBER+SUHNER FHLR91XC13X
% 50 mm2 two parallel coaxial cables

Conductor_diameter = 9.3e-3; %m
Insulation_diameter = 11.5e-3; %m
Shield_diameter = 12.6e-3; %m
Sheath_diameter = 14.9e-3; %m

r_cond   = Conductor_diameter/2;    % 4.65 mm
r_ins    = Insulation_diameter/2;   % 5.75 mm
r_shield = Shield_diameter/2;   % 6.30 mm
r_cable  = Sheath_diameter/2;   % 7.45 mm

Len35_batt1_HVJB1_pos=0.750;
Len35_batt1_HVJB1_neg=0.600;

Len_parallel = min(Len35_batt1_HVJB1_pos,Len35_batt1_HVJB1_neg);

%% ==========================================================
% Cable 1 - Positive HV cable
% ==========================================================

Rc1 = 0.38e-3; % Core resistance [Ohm]
Rs1 = 2.55e-3; % Shield resistance [Ohm]

Lc1 = 0.092e-6; % Core self-inductance [H]
Ls1 = 0.177e-6; % Shield self-inductance [H]
Mcs1 = 0.180e-6; % Core1-Shield1 mutual inductance [H]

Ccs1 = 733.62e-12; % Core1-Shield1 capacitance [F]

%% ==========================================================
% Cable 2 - Negative HV cable
% ==========================================================

Rc2 = 0.38e-3; % Core resistance [Ohm]
Rs2 = 2.55e-3; % Shield resistance [Ohm]

Lc2 = 0.092e-6; % Core self-inductance [H]
Ls2 = 0.177e-6; % Shield self-inductance [H]
Mcs2 = 0.180e-6; % Core2-Shield2 mutual inductance [H]

Ccs2 = 733.62e-12; % Core2-Shield2 capacitance [F]

%% ==========================================================
% Coupling between positive and negative cables
% ==========================================================

Mss = 0.068e-6; % Shield1-Shield2 mutual inductance [H] - from Thesis research paper

Css = 93.23e-12; % Shield1-Shield2 capacitance [F]

%% ==========================================================
% Distance-dependent coupling between positive and negative cables 
% ==========================================================
clearance_distance = 0;
Cable_Center_to_center = (r_cable*2) + clearance_distance; %m with clearance 5mm

kss_ref = 0.384;      % Reference coupling derived from thesis
Dref = Sheath_diameter;    % touching cables
Rref = r_shield;
kss_cal = kss_ref*(Dref/Cable_Center_to_center);
Mss_cal = kss_cal*sqrt((Ls1*Len35_batt1_HVJB1_pos)*(Ls2*Len35_batt1_HVJB1_neg));

%% Distance dependent Css
Css_ref = Css;   % F/m
Css_cal = Css_ref * (log(Dref/Rref) / log(Cable_Center_to_center/Rref));

%% ==========================================================
% Shield-to-ground/chassis capacitance
% ==========================================================

Csg1 = 216.23e-12; % Shield1-ground capacitance [F]
Csg2 = 216.23e-12; % Shield2-ground capacitance [F]

%% ==========================================================
% Mutual Inductance matrix
% ==========================================================

Lc1_total = Lc1 + Mcs1; % 0.272 uH
Lc2_total = Lc2 + Mcs2; % 0.272 uH

% Effective shield inductances including Mss
Ls1_eff = Ls1 + Mss_cal;
Ls2_eff = Ls2 + Mss_cal;

Lmat_Cable1 = [Lc1_total Mcs1;Mcs1 Ls1_eff];

Lmat_Cable2 = [Lc2_total Mcs2;Mcs2 Ls2_eff];

%% Full coupled inductance matrix
Lmat = [Lc1_total Mcs1 0 0;
Mcs1 Ls1 Mss 0;
0 Mss Ls2 Mcs2;
0 0 Mcs2 Lc2_total];

%% ==========================================================
% Coupling Coefficients
% k = M/sqrt(L1*L2)
% ==========================================================

% Conductor-1 <-> Shield-1
kcs1 = Mcs1/sqrt(Lc1_total*Ls1_eff);

% Conductor-2 <-> Shield-2
kcs2 = Mcs2/sqrt(Lc2_total*Ls2_eff);

% Shield-1 <-> Shield-2
kss = Mss_cal/sqrt(Ls1_eff*Ls2_eff);