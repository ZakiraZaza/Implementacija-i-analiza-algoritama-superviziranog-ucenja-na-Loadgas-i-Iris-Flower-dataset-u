function metrics = computeRegressionMetrics(yTrue, yPred)

    yTrue = double(yTrue);
    yPred = double(yPred);

    mseVal = mean((yTrue - yPred).^2);
    rmseVal = sqrt(mseVal);
    maeVal = mean(abs(yTrue - yPred));

    ssRes = sum((yTrue - yPred).^2);
    ssTot = sum((yTrue - mean(yTrue)).^2);
    r2Val = 1 - (ssRes / ssTot);

    metrics.MSE = mseVal;
    metrics.RMSE = rmseVal;
    metrics.MAE = maeVal;
    metrics.R2 = r2Val;

end