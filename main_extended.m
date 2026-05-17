clc;
clear;
close all;

disp('PROJEKAT: Implementacija i analiza algoritama superviziranog ucenja na Loadgas i Iris Flower dataset-u');
disp('DODATNI EKSPERIMENTI: rucni KNN i validacijski skup');

%% Osnovna Iris Flower klasifikacija
disp(' ');
disp('Running Iris Flower classification analysis...');
irisResults = iris_classification();

%% Load Gas regresiona analiza
disp(' ');
disp('Running Load Gas regression analysis...');
loadgasResults = loadgas_regression();

%% Dodatak 1: poredjenje ugradjenog i rucnog KNN-a
disp(' ');
disp('Running KNN built-in vs manual comparison...');
knnComparisonResults = iris_knn_builtin_vs_manual();

%% Dodatak 2: podjela 60/20/20 i izbor najboljeg k preko validacije
disp(' ');
disp('Running KNN validation experiment with 60/20/20 split...');
knnValidationResults = iris_knn_validation_60_20_20();

disp(' ');
disp('Project execution completed successfully.');
