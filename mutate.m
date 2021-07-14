function Y33 = mutate(P, D, etam, X_min , X_max)
%% polynomial mutation

pm = 1 / D;

deltam = min((P-X_min),(X_max-P))./(X_max-X_min);

t=rand(1,D);

loc_mut=t<pm;        

u=rand(1,D);

delq = (u<=0.5).*((((2*u)+((1-2*u).*((1-deltam).^(etam+1)))).^(1/(etam+1)))-1)+...
    (u>0.5).*(1-((2*(1-u))+(2*(u-0.5).*((1-deltam).^(etam+1)))).^(1/(etam+1)));

Y33 = P + delq.*loc_mut.*(X_max-X_min);

a=find (Y33<X_min);
Y33(a) = X_min(a);
b=find (Y33>X_max);
Y33(b) = X_max(b);


end
