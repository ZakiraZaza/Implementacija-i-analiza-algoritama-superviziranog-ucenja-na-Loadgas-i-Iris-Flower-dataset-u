function results = iris_classification()

    %% Ucitavanje ugradjenog Iris dataseta
    load fisheriris
    X = meas; % numericke ulazne osobine (4 po uzorku)
    Y = species; % tekstualne oznake klasa

    %% Pretvaranje labela u kategoricki tip
    Y = categorical(Y);

    %% Podjela podataka na trening i test skup
    cv = cvpartition(Y, 'HoldOut', 0.3); % HoldOut podjela 70%/30%
    idxTrain = training(cv);
    idxTest = test(cv);

    XTrain = X(idxTrain, :);
    YTrain = Y(idxTrain);

    XTest = X(idxTest, :);
    YTest = Y(idxTest);

    %% Standardizacija ulaznih osobina
    % od svake vrijednosti se oduzima srednja vrijednost i dijeli standardnom devijacijom
    mu = mean(XTrain);
    sigma = std(XTrain);

    XTrain = (XTrain - mu) ./ sigma;
    XTest = (XTest - mu) ./ sigma;

    %% MODEL 1: K-Nearest Neighbors (KNN)
    knnModel = fitcknn(XTrain, YTrain, ...
        'NumNeighbors', 5, ... % k je optimalno 5
        'Standardize', false); % vec rucno standardizovano

    % Predikcija klasa za test skup
    YPredKNN = predict(knnModel, XTest);

    % Tacnost klasifikacije izrazena u procentima
    accKNN = mean(YPredKNN == YTest) * 100;

    %% MODEL 2: Support Vector Machine (SVM)
    svmModel = fitcecoc(XTrain, YTrain); % Iris ima tri klase, koristi se funkcija fitcecoc, koja
    % prosiruje binarni SVM na viseklasni problem pomocu ECOC pristupa

    % Predikcija na test skupu
    YPredSVM = predict(svmModel, XTest);

    % Racunanje tacnosti
    accSVM = mean(YPredSVM == YTest) * 100;

    %% MODEL 3: Stablo odlučivanja (Decision Tree)
    treeModel = fitctree(XTrain, YTrain);

    % Predikcija klasa
    YPredTree = predict(treeModel, XTest);

    % Racunanje tacnosti
    accTree = mean(YPredTree == YTest) * 100;

    %% Ispis rezultata
    fprintf('\nREZULTATI ZA IRIS DATASET:\n');
    fprintf('Tacnost KNN modela            = %.2f %%\n', accKNN);
    fprintf('Tacnost SVM modela            = %.2f %%\n', accSVM);
    fprintf('Tacnost stabla odlucivanja    = %.2f %%\n', accTree);

    %% Matrice konfuzije
    figure('Name','Konfuziona matrica - KNN');
    confusionchart(YTest, YPredKNN);
    title('Iris Dataset - KNN konfuziona matrica');

    figure('Name','Konfuziona matrica - SVM');
    confusionchart(YTest, YPredSVM);
    title('Iris Dataset - SVM konfuziona matrica');

    figure('Name','Konfuziona matrica - Stablo odlučivanja');
    confusionchart(YTest, YPredTree);
    title('Iris Dataset - konfuziona matrica stabla odlučivanja');

    %% Vizualizacija prve dvije osobina (duzina i sirina sepala)
    figure('Name','Vizualizacija Iris podataka');
    gscatter(X(:,1), X(:,2), Y);
    xlabel('Duzina sepala');
    ylabel('Sirina sepala');
    title('Iris Dataset - vizualizacija osobina');
    grid on;

    %% Pohrana rezultata u izlaznu strukturu
    results.KNN_Accuracy = accKNN;
    results.SVM_Accuracy = accSVM;
    results.Tree_Accuracy = accTree;

    results.YTest = YTest;
    results.YPredKNN = YPredKNN;
    results.YPredSVM = YPredSVM;
    results.YPredTree = YPredTree;

end