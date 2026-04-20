clc;
clear;
close all;

%% Number of samples
N = 300;

%% Generate input variables
Temperature_C   = 5  + 30*rand(N,1);     % 5 do 35 °C
Pressure_bar    = 0.9 + 0.4*rand(N,1);   % 0.9 do 1.3 bar
Humidity_pct    = 20 + 70*rand(N,1);     % 20 do 90 %
FlowRate_m3h    = 50 + 250*rand(N,1);    % 50 do 300 m^3/h
HourOfDay       = randi([0 23], N, 1);   % 0 do 23
DayOfWeek       = randi([1 7], N, 1);    % 1 do 7
IndustrialDemand = 30 + 70*rand(N,1);    % 30 do 100

%% Daily usage effect
dailyEffect = 8*sin((HourOfDay/24)*2*pi - pi/2) + 10;

%% Weekly effect
weeklyEffect = zeros(N,1);
weeklyEffect(DayOfWeek >= 1 & DayOfWeek <= 5) = 8;   % radni dani
weeklyEffect(DayOfWeek == 6 | DayOfWeek == 7) = -3;  % vikend

%% Random noise
noise = randn(N,1) * 4;

%% Target variable: Gas Load
GasLoad = ...
    120 ...
    - 1.8*Temperature_C ...      % veca temperatura -> manja potrosnja
    + 25*Pressure_bar ...
    + 0.15*Humidity_pct ...
    + 0.30*FlowRate_m3h ...
    + 0.90*IndustrialDemand ...
    + dailyEffect ...
    + weeklyEffect ...
    + noise;

%% Make sure target stays positive
GasLoad(GasLoad < 0) = 0;

%% Create table
data = table(Temperature_C, Pressure_bar, Humidity_pct, FlowRate_m3h, ...
             HourOfDay, DayOfWeek, IndustrialDemand, GasLoad);

%% Save dataset
writetable(data, 'loadgas.csv');

%% Show first rows
disp('First 10 rows of generated dataset:');
disp(data(1:10,:));

%% Optional plots
figure;
scatter(Temperature_C, GasLoad, 'filled');
xlabel('Temperature (°C)');
ylabel('Gas Load');
title('Gas Load vs Temperature');
grid on;

figure;
scatter(FlowRate_m3h, GasLoad, 'filled');
xlabel('Flow Rate (m^3/h)');
ylabel('Gas Load');
title('Gas Load vs Flow Rate');
grid on;