clc;
clear;
close all;

disp('PROJEKAT: Implementacija i analiza algoritama superviziranog ucenja na Loadgas i Iris Flower dataset-u');

%% Iris Flower Classification
disp(' ');
disp('Running Iris Flower classification analysis...');
irisResults = iris_classification();

%% Load Gas Regression
disp(' ');
disp('Running Load Gas regression analysis...');
loadgasResults = loadgas_regression();

disp(' ');
disp('Project execution completed successfully.');