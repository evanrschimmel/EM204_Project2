%****************************************************************
%   Schimmel_Evan_EM204_project_2.m
%
%   PROGRAM DESCRIPTION
%   Add before submitting
%
%   WRITTEN BY: Evan Schimmel
%               10/11/2021
%
%****************************************************************

clear all
close all
clc

round_tube_data = readmatrix('RoundTube_Options');
round_bar_data = readmatrix('RoundBar_Options');

sigma_yield = 37; % ksi
FOS_beam = 5.0; % unitless
sigma_max = sigma_yield / FOS_beam; % ksi
m_beam = 12000; % in-lb

j=0;
for ind=1:length(round_tube_data)
    OD = round_tube_data(ind,1);
    wall = round_tube_data(ind,2);
    ID = round_tube_data(ind,3);    
    I = pi*((OD/2)^4-(ID/2)^4)/4;
    sigma_beam = (1/1000) * (m_beam * (OD/2)) / I; % ksi
    round_tube_data(ind,4) = sigma_beam;
    
    if sigma_beam < sigma_max
        j=j+1;
        round_tube_valid(j,1) = OD;
        round_tube_valid(j,2) = wall;
        round_tube_valid(j,3) = ID;
        round_tube_valid(j,4) = sigma_beam;
    end
end
writematrix(round_tube_valid,'RoundTube_Export.xlsx','Sheet',1,'Range','A2')

j=0;
for ind=1:length(round_bar_data)
    OD = round_bar_data(ind,1);  
    I = pi*((OD/2)^4)/4;
    sigma_beam = (1/1000) * (m_beam * (OD/2)) / I; % ksi
    round_bar_data(ind,4) = sigma_beam;
    
    if sigma_beam < sigma_max
        j=j+1;
        round_bar_valid(j,1) = OD;
        round_bar_valid(j,4) = sigma_beam;
    end
end
writematrix(round_bar_valid,'RoundBar_Export.xlsx','Sheet',1,'Range','A2')

round_tube_valid = readmatrix('RoundTube_Valid');
for ind=1:length(round_tube_valid)
    wt = round_tube_valid(ind,5) * (124/12);
    PF = wt/100 + round_tube_valid(ind,6) / 1000;
    round_tube_valid(ind,7) = PF;
    [best_PF_tube,loc] = min(round_tube_valid(:,7));
end

% round_bar_valid = readmatrix('RoundBar_Valid');
% for ind=1:length(round_bar_valid)
%     wt = round_bar_valid(ind,5) * (124/12);
%     PF = wt/100 + round_bar_valid(ind,6) / 1000;
%     round_bar_valid(ind,7) = PF;
% end

best_OD = round_tube_valid(loc,1);
best_wall = round_tube_valid(loc,2);
best_ID = round_tube_valid(loc,3);
best_sigma = round_tube_valid(loc,4);
best_FOS = sigma_yield / best_sigma;

fprintf('Ideal support dimensions: \n');
fprintf('OD: %5.3f in \nWall: %5.3f in \nID: %5.3f in \n\n',best_OD,best_wall,best_ID);
fprintf('Loading measurements: \n');
fprintf('Flexural stress: %5.3f ksi \nFOS: %5.3f \n\n',best_sigma,best_FOS);

