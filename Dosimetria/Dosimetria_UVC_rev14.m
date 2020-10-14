clc 
clear all
close all

% Densidade de Potencia UVC da Lampada G13

P = 4 % Puvc = 4W
CompCirc= 2*pi*0.013;
CompLamp=0.438;
I = P/(CompLamp*CompCirc)

% 100 W/m2 - 5.38 cm

%HNS 15W G13, Pel=15W Puv = 4W
Med1=[5.65 3.98 2.96 2.19 1.72 1.48 1.30 1.18 1.04 0.92 0.81 0.72 0.65 0.58 0.5 ...
    0.45 0.42 0.38 0.33 0.31 0.309 0.308 0.307 0.306 0.305 0.304 0.303 0.30 0.29 0.29...
    0.28 0.27 0.25 0.25 0.22 0.20 0.20 0.20 0.19 0.19 0.18 0.18 0.17 0.16 0.15...
    0.13 0.13 0.13 0.12 0.11 0.10];

Med1_Wm2=(Med1*100)/5.38;

Med2=[5.35 4.51 4 3.5 3.09 2.73 2.41 2.15 1.9 1.69 1.5];

Med2_Wm2=(Med2*1.5)/4.5;
    
D1=0:0.01:0.5;
D2=0.5:0.05:1;

figure(1)
plot(D1,Med1_Wm2)
xlabel('Distancia em metros')
ylabel('Irradiancia UVC - W/m2')
title('Fluxo Irradiante por unidade de ?rea')
grid

figure(2)
plot(D2,Med2_Wm2)
xlabel('Distancia em metros')
ylabel('Irradiancia UVC - W/m2')
title('Fluxo Irradiante por Unidade de Area')
grid

[p1,S]=polyfit(D1,Med1_Wm2,9);

dist=0;
i=1;
while dist<0.51
    Polin1(i)=polyval(p1,dist);
    dist=dist+0.01;
    i=i+1;
end

figure(3)
plot(D1,Polin1)
xlabel('Distancia em metros')
ylabel('Irradiancia UVC - W/m2')
title('Fluxo Irradiante por Unidade de Area')
grid

[p2,S]=polyfit(D2,Med2_Wm2,6);

dist=0.51;
i=1;
while dist<1.01
    Polin2(i)=polyval(p2,dist);
    dist=dist+0.01;
    i=i+1;
end

D2=0.51:0.01:1;

figure(4)
plot(D2,Polin2)
xlabel('Distancia em metros')
ylabel('Irradiancia UVC - W/m2')
title('Fluxo Irradiante por Unidade de Area')
grid

Polin=[Polin1 Polin2];
D=0:0.01:1;
figure(5)
plot(D,Polin)
xlabel('Distancia em metros')
ylabel('Irradiancia UVC - W/m2')
title('Fluxo Irradiante por Unidade de Area')
grid

[p,S]=polyfit(D,Polin,12);
% Polinomio mal condicionado para grau maior ou igual a 13

dist=0;
i=1;
while dist<1.01
    Irrad(i)=polyval(p,dist);
    dist=dist+0.01;
    i=i+1;
end

D=0:0.01:1;

figure(6)
plot(D,Irrad)
xlabel('Distancia em metros')
ylabel('Irradiancia UVC - W/m2')
title('Fluxo Irradiante por Unidade de Area')
grid

% Superficie de Irradiancia

X=-0.5:0.01:0.5;
Y=-0.5:0.01:0.5;
for i=1:length(X)
    for j=1:length(Y)
        distancia(i,j)=(sqrt(X(i)^2+Y(j)^2)-0.013);
        if distancia(i,j)<0
            Z(i,j)=0;
        end
        if (distancia(i,j)>=0 & distancia(i,j)<0.5) 
            Z(i,j)=polyval(p1,distancia(i,j));
        end
        if (distancia(i,j)>=0.5) 
            Z(i,j)=polyval(p2,distancia(i,j));
        end
    end
end

figure(7)
surf(X,Y,Z)
title('Irradiancia da Lampada UVC - Projeto EDP - Tergos - IFSP')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dosagem para a mascara fixada diante das lampadas
% Supondo que o ponto mais distante da mascara esta a h1 metros da lampada.
% H_dosagemInterna ? a dosagem total recebida na parte interna da m?scara
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Hipotese: O ponto mais afastado da m?scara estar? a uma DistMedia das
% lampadas por um tempo igual a TempoMinutos

TempoMinutos=5;
TempoSegundos=TempoMinutos*60;
h1=0.15;
r=0.013; % Raio da lampada
dlamp= 3*r; % Distancia entre as lampadas (centro a centro)
DistMedia=sqrt((dlamp/2)^2+h1^2)
distancia=(sqrt(0^2+DistMedia^2)-0.013);
EfeitoLambertiano=1.8;
NumerodeLampadas=2;
H_dosagemInterna=(EfeitoLambertiano*NumerodeLampadas*polyval(p1,distancia)*TempoSegundos)/10000 % Para transformar de J/m2 para J/cm2 deve ser dividido por 10000
