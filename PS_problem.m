%% Reference:
% EED matlab file exchange

%% Problem formulation
cost=@(x,n) PS_cost(x,n);
constraint = @(x,d) PS_constraint(x,d);

NumO = 2;				% number of objective functions
D = 6;				% number of decision variables

% This program solves the economic emission dispatch dispatch with Bmn coefficients by
% quadratic programming and equal incremental cost critetion
% the elddata matrix should have 5 columns of fuel cost coefficients and plant  limits.
% 1.a ($/MW^2) 2. b $/MW 3. c ($) 4.lower lomit(MW) 5.Upper limit(MW)
%no of rows denote the no of plants(n)

global elddata
        % a          % b       % c     %min %max
data=[0.15247	38.53973	756.79886	10	125
      0.10587	46.15916	451.32513	10	150
      0.02803	40.3965     1049.9977	35	225
      0.03546	38.30553	1243.5311	35	210
      0.02111	36.32782	1658.5596	130	325
      0.01799	38.27041	1356.6592	125	315];

X_min = data(:,4)';
X_max = data(:,5)';
elddata = data(:,1:3);

% the emidata matrix should have 3 columns of fuel cost coefficients and plant  limits.
% 1.a (Kg/MW^2) 2. b Kg/MW 3. c (Kg)

global emidata
          %d          %e          %f
emidata=[0.00419	0.32767     13.85932
         0.00419	0.32767     13.85932
         0.00683    -0.54551	40.2669
         0.00683    -0.54551	40.2669
         0.00461	-0.51116	42.89553
         0.00461	-0.51116	42.8955];

% Demand (MW)
global Pd
Pd=700;

% Loss coefficients it should be squarematrix of size nXn where n is the no
% of plants
global B

B=1e-4*[1.4	.17	.15	.19	.26	.22
        .17	.6	.13	.16	.15	.2
        .15	.13	.65	.17	.24	.19
        .19	.16	.17	.71	.3	.25
        .26	.15	.24	.3	.69	.32
        .22	.2	.19	.25	.32	.85];


