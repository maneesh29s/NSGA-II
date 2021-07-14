% Load dataset
load('data_6_unit.mat');

cost=@(x,n) PS_cost_new(x,n);
constraint = @(x,d) PS_constraint_new(x,d);

global X_min X_max;
X_min = DATA(:,1)';
X_max = DATA(:,2)';

global gen_data emm_data;
gen_data = DATA(:,3:7);     % ai bi ci di ei

emm_data = DATA(:,8:end);   % alpha beta gamma eta delta

clear temp;
% Demand (MW)
global Pd
Pd=1000;

% Loss coefficients it should be squarematrix of size nXn where n is the no
global Bij Bio Boo;
Bij = Bij_mat;
Bio = Bio_mat;
Boo = Boo_mat;

clear DATA Bij_mat Bio_mat Boo_mat;