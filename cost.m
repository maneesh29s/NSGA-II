function [Z] = cost(X,NumO)

[ pp , ~ ] = size(X);

%% Schaffer function N. 2 
% Z11 = zeros(pp,1);
% cond = (X<=1);
% Z11(cond) = -1*X(cond);
% 
% cond = ((1<X) & (X<=3));
% Z11(cond) = X(cond)-2;
% 
% cond = ((3<X) & (X<=4));
% Z11(cond) = 4 - X(cond);
% 
% cond = (X>4);
% Z11(cond) = X(cond)-4;
% 
% Z22 = (X - 5).^2;
% % 
%% Binh and Korn function
% Z11 = 4*X(:,1).^2 + 4*X(:,2).^2;
% Z22 = (X(:,1) - 5).^2 + (X(:,2) - 5).^2;
% 
%% Kursawe Function (KUR) 
% Z11 = -10*exp(-0.2* sqrt(X(:,1).^2 + X(:,2).^2)) + ...
%         -10*exp(-0.2* sqrt(X(:,2).^2 + X(:,3).^2));
% Z22 = ((abs(X(:,1))).^0.8 + 5.*sin(X(:,1).^3)) + ...
%         ((abs(X(:,2))).^0.8 + 5.*sin(X(:,2).^3)) + ...
%         ((abs(X(:,3))).^0.8 + 5.*sin(X(:,3).^3));

%% Fonseca-Fleming Function
Z11=1-exp(-sum(((X-1/sqrt(2)).^2),2));

Z22=1-exp(-sum(((X+1/sqrt(2)).^2),2));
%
%
%% Osyczka and Kundu function
% Z11 = -25.*(X(:,1)-2).^2 - (X(:,2)-2).^2 - (X(:,3)-1).^2 - (X(:,4)-4).^2 - (X(:,5)-1).^2;
% Z22 = X(:,1).^2 + X(:,2).^2 + X(:,3).^2 + X(:,4).^2 + X(:,5).^2 + X(:,6).^2;
% 
% Z11 = [];
% Z22 = [];
% for i = 1 : pp
%     Z11(i,:) = -25*(X(i,1)-2)^2 - (X(i,2)-2)^2 - (X(i,3)-1)^2 - (X(i,4)-4)^2 - (X(i,5)-1)^2;
%     Z22(i,:) = X(i,1)^2 + X(i,2)^2 + X(i,3)^2 + X(i,4)^2 + X(i,5)^2 + X(i,6)^2;
% end
%

%% ZDT3
% D = 30;
% Z11 = X(:,1);
% g = 1;
% for i = 2:D
%    g = g + (9/29).*(X(:,i)); 
% end
% Z22 = g .* ( 1 - ( Z11 ./ g).^(0.5) - ( Z11 ./ g) .* sin(10.*pi.*Z11));


%% ZDT4
% D = 10;
% 
% Z11 = X(:,1);
% % g = 91 + sum(((X(:,2:end).^2) - 10*cos(4*pi*(X(:,2:end)))),2);
% g = 91;
% for i = 2:D
%     g = g + ((X(:,i).^2) - 10*cos(4*pi*(X(:,i))));
% end
% 
% Z22 = g .* ( 1 - ( Z11 ./ g).^0.5);


%% DTLZ1 Inverted
%   % Compute 'g' functional.
%   k = D - NumO + 1;
%   if k > 0
%     g = 100 * (k + sum( (X(:,NumO:D) - 0.5).^2 - cos(20*pi*(X(:,NumO:D)-0.5)), 2) );
%   else
%     g = 0;
%   end
%   f(:,1) = prod( cos(X(:,1:NumO-1)*pi/2) ,2) .* (1 + g);
%   for(fNo = 2:NumO-1)
%     f(:,fNo) = prod( cos(X(:,1:NumO-fNo)*pi/2) ,2) .* sin( X(:,NumO-fNo+1)*pi/2 ) .* (1 + g);
%   end
%   f(:,NumO) = sin( X(:,1)*pi/2 ) .* (1 + g);
% 
% Z = f;


%% Post processing
Z = [ Z11 Z22 ];

if size(Z,1) ~= pp || size(Z,2) ~= NumO 
    error('Theres an error in cost function');
end

end