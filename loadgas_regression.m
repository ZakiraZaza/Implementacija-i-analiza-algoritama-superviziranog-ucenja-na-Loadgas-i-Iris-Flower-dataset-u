function results = loadgas_regression()

    data = readtable('loadgas.csv');

    X = data{:, 1:end-1}; % sve osim zadnje kolone
    Y = data.GasLoad; % target

    % Podjela na trening i test
    cv = cvpartition(size(X,1), 'HoldOut', 0.3);
    idxTrain = training(cv);
    idxTest  = test(cv);

    XTrain = X(idxTrain,:);
    YTrain = Y(idxTrain);
    XTest  = X(idxTest,:);
    YTest  = Y(idxTest);

    % Standardizacija
    mu = mean(XTrain,1);
    sigma = std(XTrain,0,1);
    sigma(sigma == 0) = 1;

    XTrain = (XTrain - mu) ./ sigma;
    XTest  = (XTest - mu) ./ sigma;

    %% Linearna regresija
    linModel = fitlm(XTrain, YTrain);
    YPredLin = predict(linModel, XTest);
    metricsLin = computeRegressionMetrics(YTest, YPredLin);

    %% Regression Tree
    treeModel = fitrtree(XTrain, YTrain);
    YPredTree = predict(treeModel, XTest);
    metricsTree = computeRegressionMetrics(YTest, YPredTree);

    %% Support Vector Regression
    svrModel = fitrsvm(XTrain, YTrain, ...
        'KernelFunction', 'gaussian', ...
        'Standardize', false);
    YPredSVR = predict(svrModel, XTest);
    metricsSVR = computeRegressionMetrics(YTest, YPredSVR);

    %% Ispis rezultata
    fprintf('\nLOAD GAS DATASET RESULTS:\n');

    fprintf('\nLinear Regression:\n');
    fprintf('MSE  = %.4f\n', metricsLin.MSE);
    fprintf('RMSE = %.4f\n', metricsLin.RMSE);
    fprintf('MAE  = %.4f\n', metricsLin.MAE);
    fprintf('R^2  = %.4f\n', metricsLin.R2);

    fprintf('\nRegression Tree:\n');
    fprintf('MSE  = %.4f\n', metricsTree.MSE);
    fprintf('RMSE = %.4f\n', metricsTree.RMSE);
    fprintf('MAE  = %.4f\n', metricsTree.MAE);
    fprintf('R^2  = %.4f\n', metricsTree.R2);

    fprintf('\nSupport Vector Regression:\n');
    fprintf('MSE  = %.4f\n', metricsSVR.MSE);
    fprintf('RMSE = %.4f\n', metricsSVR.RMSE);
    fprintf('MAE  = %.4f\n', metricsSVR.MAE);
    fprintf('R^2  = %.4f\n', metricsSVR.R2);

    %% Grafovi
    figure;
    plot(YTest, 'o-'); hold on;
    plot(YPredLin, '*-');
    legend('Real Values', 'Predicted Values');
    title('Load Gas - Linear Regression');
    xlabel('Test Sample');
    ylabel('Gas Load');
    grid on;

    figure;
    plot(YTest, 'o-'); hold on;
    plot(YPredTree, '*-');
    legend('Real Values', 'Predicted Values');
    title('Load Gas - Regression Tree');
    xlabel('Test Sample');
    ylabel('Gas Load');
    grid on;

    figure;
    plot(YTest, 'o-'); hold on;
    plot(YPredSVR, '*-');
    legend('Real Values', 'Predicted Values');
    title('Load Gas - Support Vector Regression');
    xlabel('Test Sample');
    ylabel('Gas Load');
    grid on;

    results.LinearRegression = metricsLin;
    results.RegressionTree = metricsTree;
    results.SVR = metricsSVR;
end