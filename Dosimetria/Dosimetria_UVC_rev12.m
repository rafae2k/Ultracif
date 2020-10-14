clc 
clear all
close all

% Densidade de Pot?ncia UVC da L?mpada G13

P = 4 %4
CompCirc= 2*pi*0.013;
CompLamp=0.438;
I = P/(CompLamp*CompCirc)

% 
d=0.10;
y=0.5;
x=-10:0.1:10;

for i=1:length(x)
    d1(i)=sqrt(x(i)^2+(y-d)^2); 
    d2(i)=sqrt(x(i)^2+y^2);
    I1(i)=1/d1(i);
    I2(i)=1/d2(i);
    I(i)=I1(i)+I2(i);
end

figure(1)
plot(I)
grid
title('Irradia??o x Posi??o')
xlabel('Posicionamento')
ylabel('Irradia??o')

%rq_1()= x^2+y^2;

%rq_2()= x^2+(y-20)^2;

% 100 W/m2 - 5.38 cm

%HNS 15W G13, Pel=15W Puv = 4W
Med1=[5.65 3.98 2.96 2.19 1.72 1.48 1.30 1.18 1.04 0.92 0.81 0.72 0.65 0.58 0.5 ...
    0.45 0.42 0.38 0.33 0.31 0.309 0.308 0.307 0.306 0.305 0.304 0.303 0.30 0.29 0.29...
    0.28 0.27 0.25 0.25 0.22 0.20 0.20 0.20 0.19 0.19 0.18 0.18 0.17 0.16 0.15...
    0.13 0.13 0.13 0.12 0.11 0.10];

Med1_Wm2=(Med1*100)/5.38;

Med2=[5.35 4.51 4 3.5 3.09 2.73 2.41 2.15 1.9 1.69 1.5];

Med2_Wm2=(Med2*1.5)/4.5;
    
%I=[108
D1=0:0.01:0.5;
D2=0.5:0.05:1;

figure(2)
plot(D1,Med1_Wm2)
xlabel('Distancia em metros')
ylabel('Irradiancia UVC - W/m2')
title('Fluxo Irradiante por unidade de ?rea')
grid

figure(3)
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

figure(4)
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

figure(5)
plot(D2,Polin2)
xlabel('Distancia em metros')
ylabel('Irradiancia UVC - W/m2')
title('Fluxo Irradiante por Unidade de Area')
grid

Polin=[Polin1 Polin2];
D=0:0.01:1;
figure(6)
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

figure(7)
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

figure(8)
surf(X,Y,Z)
title('Irradiancia da Lampada UVC - Projeto EDP - Tergos - IFSP')

% Sombra da outra lampada
% Superficie de Irradiancia

X=-0.5:0.005:0.5;
Y=-0.5:0.005:0.5;
dl=0.126;
A=0;

for i=1:length(X)
    for j=1:length(Y)
        distancia(i,j)=(sqrt(X(i)^2+Y(j)^2)-0.013);
        if (distancia(i,j)>=0 & distancia(i,j)<0.5) 
            Z(i,j)=polyval(p1,distancia(i,j));
        end
        if (distancia(i,j)>=0.5) 
            Z(i,j)=polyval(p2,distancia(i,j));
        end
        if distancia(i,j)<0
            Z(i,j)=0;
        end
        if ((((Y(j)-dl)^2)+X(i)^2)-(0.013)^2)<=0
            Z(i,j)=0;
        end
        if ((Y(j)+(sqrt((2*0.013+dl)^2-0.013^2)/0.013)*X(i))>0) & ((Y(j)-(sqrt((2*0.013+dl)^2-0.013^2)/0.013)*X(i))>0)...
                & (Y(j)-(sqrt(dl^2-0.013^2))*sin(atan((sqrt((2*0.013+dl)^2-0.013^2)/0.013)))>0)
            Z(i,j)=0;
        end
    end
end

figure(9)
surf(X,Y,Z)
title('Irradiancia da Lampada UVC - Projeto EDP - Tergos - IFSP')

% Sombra da outra lampada
% Superficie de Irradiancia

X=-0.5:0.005:0.5;
Y=-0.5:0.005:0.5;
dl=0.126;
A=0;

for i=1:length(X)
    for j=1:length(Y)
        distancia(i,j)=(sqrt(X(i)^2+Y(j)^2)-0.013);
        if (distancia(i,j)>=0 & distancia(i,j)<0.5) 
            Z(i,j)=polyval(p1,distancia(i,j));
        end
        if (distancia(i,j)>=0.5) 
            Z(i,j)=polyval(p2,distancia(i,j));
        end
        if distancia(i,j)<0
            Z(i,j)=0;
        end
        if ((((Y(j)-dl)^2)+X(i)^2)-(0.013)^2)<=0
            Z(i,j)=0;
        end
        if ((Y(j)+(sqrt((2*0.013+dl)^2-0.013^2)/0.013)*X(i))>0) & ((Y(j)-(sqrt((2*0.013+dl)^2-0.013^2)/0.013)*X(i))>0)...
                & (Y(j)-(sqrt(dl^2-0.013^2))*sin(atan((sqrt((2*0.013+dl)^2-0.013^2)/0.013)))>0)
            Z(i,j)=0;
        end
    end
end

figure(10)
surf(X,Y,Z)
title('Irradiancia da Lampada UVC - Projeto EDP - Tergos - IFSP')

% Dosagem em fun??o da velocidade
% Supondo pontos em transito entre 5 e 15 cm

v=0.0003; % 0.3 mm/s
H=zeros(1,length(X));
H(1,1)=(Z(80,120)*(0.005/v))/10000;
Tempo=40*(0.005/v)
Tempo/60
for i=81:120
    H(i)=H(i-1)+(Z(i,120)*(0.005/v))/10000;
end
for i=121:201
    H(i)=H(i-1);
end
figure(11)
plot(X,H)
title('Dosagem de Irradiacao - Projeto EDP - Tergos - IFSP')
xlabel('Deslocamento em metros')
ylabel('Dosagem de Irradiacao IUVG - J/cm2')
grid
