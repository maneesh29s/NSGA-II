clc;
clear;
close all;
% rng(1);

s = rng;

%% Problem formulation
% cost=@(x,n) cost(x,n);

NumO = 2;				% number of objective functions
D = 2;				% number of decision variables

% % X_limit = [-5 5]; X_limit = repmat(X_limit,3,1);
% % X_limit = [0 10 ; 0 10 ; 1 5; 0 6 ; 1 5 ; 0 10];
% % % X_limit = [-5 10];
X_limit = [-4 4]; X_limit = repmat(X_limit,D,1);
% X_limit = [0 1 ; repmat([-5 5],D-1,1)]; 
% % X_limit = [0 1]; X_limit = repmat(X_limit,D,1);
% 
X_min = X_limit(:,1)';
X_max = X_limit(:,2)';
% 
% 
% PS_problem;
% PS_problem_new;


%% NSGA Parameters
Max_iter = 10000;
np = 100;
pc = 0.9;
mu = 1/D;
nc = round(pc*np/2);              % number of crossovers
nm = round(np*mu);
etac = 20;      % crossover index
etam = 80;     % mutation index
%% Initialization

X = initialize(X_min, X_max, np, D);
Z = cost(X,NumO);
error_normalized = constraint(X,D);
[X , Z , ranks , crowding_distance] = nd_sorting(X,Z,error_normalized,NumO);

%% Complete Sort
NDSop = [X , Z , ranks , crowding_distance];
[~,idx] = sort(NDSop(:,D + NumO + 1 + 1),"descend");    % sorting by crowding distance
NDSop = NDSop(idx,:);
[~,idx2] = sort(NDSop(:,D + NumO + 1),"ascend");    % sorting by rank (again)
NDSop = NDSop(idx2,:);
X = NDSop(:,1:D);
Z = NDSop(:,D+1:D+NumO);
ranks = NDSop(:,D+NumO+1);
crowding_distance = NDSop(:,end);
clear NDSop;

%% Main loop
prob = zeros(np,1);
W = zeros(1,Max_iter);
tic;
for it = 1:Max_iter
    %% tournament selection and crossover
    Y1 = zeros(nc,D);
    Y2 = zeros(nc,D);
    Z1 = zeros(nc,NumO);
    Z2 = zeros(nc,NumO);
    for j = 1:nc
        % select parents
        P1 = tournament_selection(X,ranks,crowding_distance);
        P2 = tournament_selection(X,ranks,crowding_distance);
        % perform crossover
        [Y1(j,:),Y2(j,:)] = crossover (P1, P2,D, etac, X_min , X_max);           % create 2 offspring
        Z1(j,:) = cost(Y1(j,:),NumO);         % sphere value of 1st offspring
        Z2(j,:) = cost(Y2(j,:),NumO);         % sphere value of 2nd offspring
    end
    Ycross=[Y1;Y2];             % convert all to a column matrix [nc*2,2]
    Zcross=[Z1;Z2];           % convert all to a column matrix [nc*2,1]
    
    %%mutation
    Ymutate=zeros(nm,D);
    Zmutate=zeros(nm,NumO);
    for i=1:nm
        % Select Parent
        P3 = tournament_selection(X,ranks,crowding_distance);
        % Apply Mutation
        Ymutate(i,:) = mutate(P3, D, etam, X_min , X_max);
        Zmutate(i,:) = cost(Ymutate(i,:),NumO);
    end
   
    % Create Merged Population
    Zmerged=[Z
         Zcross
         Zmutate];          % shape [np + nc*2 + nm , 1]
    Xmerged=[X
         Ycross
         Ymutate];                % shape [np + nc*2 + nm , 2]
     
    error_normalized_merged = constraint(Xmerged,D);
	% Sort Population
	[Xmerged, Zmerged , ranks_merged , crowding_distance_merged] =...
        nd_sorting(Xmerged,Zmerged,error_normalized_merged,NumO);
    
    % Full sort
    NDSop = [Xmerged , Zmerged , ranks_merged , crowding_distance_merged];
    [~,idx] = sort(NDSop(:,D + NumO + 1 + 1),"descend");    % sorting by crowding distance
    NDSop = NDSop(idx,:);
    [~,idx2] = sort(NDSop(:,D + NumO + 1),"ascend");    % sorting by rank (again)
    NDSop = NDSop(idx2,:);
    
    % Truncation
	NDSop = NDSop(1:np,:);
    
    X = NDSop(:,1:D);
    Z = NDSop(:,D+1:D+NumO);
    ranks = NDSop(:,D+NumO+1);
    crowding_distance = NDSop(:,end);
    clear NDSop;
    
%     % Truncation
% 	[X, Z , ranks , crowding_distance] =...
%         truncation(Xmerged, Zmerged , ranks_merged , crowding_distance_merged, np);
% 	
	fprintf('%d generations completed\n',it);
    figure(1);
%     plot3(Z(:,1),Z(:,2),Z(:,3),'*');
    plot(Z(:,1),Z(:,2),'*')
    
end

toc;
% Results
%plot3(Z(:,1),Z(:,2),Z(:,3),'*');
% plot(Z(:,1),Z(:,2),'*')
