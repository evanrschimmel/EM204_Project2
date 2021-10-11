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

writematrix(round_tube_valid,'RoundTube_Export.xlsx','Sheet',1)