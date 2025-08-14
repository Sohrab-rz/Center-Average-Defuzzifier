%_____________________________________________________________________%

    %                 Authour       :      Sohrab Rezaei                %
    
%                 Sample code for Center Average Defuzzifier         %
%                  A Course in Fuzzy Systems and Control
%                        Book by Li-Xin Wang
%                           Problem 10 . 2 

%_____________________________________________________________________%
%% init
clc; close all; clear;

%% Data Set
h=0.04;
xx=-1:h:1;
N=numel(xx);
yy=sin(xx.*pi)+cos(xx.*pi)+sin(xx.*pi).*cos(xx.*pi);
yy_sort=sort(yy);
x_sort=[];
yy_sort=unique(yy_sort);
yy_sort=[yy_sort(1:13) yy_sort(15:end)];
Ny=numel(yy_sort);
for i=1:Ny
    j=find(yy==yy_sort(i));
    x_sort=[x_sort j(end)];
end
dd=1*(yy_sort(2:end)-yy_sort(1:end-1));
dd=max(dd)/2;

%% Defining the Fuzzy Interface System
fis_10_2=mamfis;
fis_10_2=addInput(fis_10_2,[min(xx) max(xx)],"Name","x");
fis_10_2=addOutput(fis_10_2,[min(yy) max(yy)],"Name","y");
fis_10_2.AndMethod='prod';
fis_10_2.OrMethod='probor';
fis_10_2.ImplicationMethod='prod';
fis_10_2.AggregationMethod='sum';
fis_10_2.DefuzzificationMethod='CA_defuzz'; 

%% Input membership functions
fis_10_2=addMF(fis_10_2,'x','trimf',[xx(1),xx(1),xx(1)+h]);
for i=1:N-2
    fis_10_2=addMF(fis_10_2,'x','trimf',[xx(i:i+2)]);
end
fis_10_2=addMF(fis_10_2,'x','trimf',[xx(end-1),xx(end),xx(end)+0.1*h]);

%% Output membership functions
for i=1:Ny
    fis_10_2=addMF(fis_10_2,'y','trimf',[yy_sort(i)-dd yy_sort(i) yy_sort(i)+dd ]);
end


%% Defining Rules
%Each row of the array contains one rule in the following format.
    % Column 1 - Index of membership function for input
    % Column 2 - Index of membership function for output
    % Column 3 - Rule weight (from 0 to 1)
    % Column 4 - Fuzzy operator (1 for AND, 2 for OR)
fis_10_2.Rules=[]; % reset Rules
for i=1:Ny
    rule=[x_sort(i) i 1 1];
    fis_10_2 = addRule(fis_10_2,rule);
end
% Due to the sorting output values and removing repeated parameters these
% two rules should added to the rules; 
rule=[1 1 1 1];
fis_10_2 = addRule(fis_10_2,rule);
rule=[5 13 1 1];
fis_10_2 = addRule(fis_10_2,rule);
%% Approximation 
N_p_fis=15000; % number of plot points
x_app=-1:h:1;
y_exact=sin(x_app.*pi)+cos(x_app.*pi)+sin(x_app.*pi).*cos(x_app.*pi);
y_app=zeros(1,numel(x_app));
opt_eval=evalfisOptions('NumSamplePoints',N_p_fis);
for i=1:numel(x_app)
    y_app(i)=evalfis(fis_10_2,x_app(i),opt_eval); 
end
error=y_app-y_exact;
e_max=max(abs(error));

%% Plotting results 
figure()
    plotmf(fis_10_2,"input",1,N_p_fis/15)
figure()
    plotmf(fis_10_2,"output",1,5*N_p_fis)
figure()
    plot(x_app,y_exact,'--','LineWidth',3)
    hold on
    plot(x_app,y_app,'LineWidth',2.5)
    legend('Actual function','Approximation')
    grid
figure()
    plot(x_app,y_app,'LineWidth',1.5)
    hold on
    plot(xx,yy,'rX','MarkerSize',9)
    grid
    legend('Approximation','Data Base')


