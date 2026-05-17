function results = iris_knn_builtin_vs_manual()
%IRIS_KNN_BUILTIN_VS_MANUAL Poredjenje ugradjene i rucne KNN implementacije.
%
%   Ovaj eksperiment koristi isti Iris dataset i istu HoldOut podjelu kao
%   osnovna analiza, ali se fokusira samo na KNN algoritam.
%
%   Cilj je pokazati da se KNN moze implementirati i bez gotove MATLAB
%   funkcije fitcknn, te zatim uporediti rezultate rucne implementacije sa
%   ugradjenom MATLAB implementacijom.

    %% Ucitavanje Iris dataseta
    load fisheriris
    X = meas;
    Y = categorical(species);

    %% HoldOut podjela na trening i test skup
    % Koristi se ista logika kao u osnovnoj skripti: 70% trening i 30% test.
    % Na ovaj nacin je poredjenje fer, jer oba modela rade nad istim
    % trening i test uzorcima.
    cv = cvpartition(Y, 'HoldOut', 0.3);
    idxTrain = training(cv);
    idxTest = test(cv);

    XTrain = X(idxTrain, :);
    YTrain = Y(idxTrain);

    XTest = X(idxTest, :);
    YTest = Y(idxTest);

    %% Standardizacija podataka
    % KNN zavisi od udaljenosti izmedju tacaka, pa osobine koje imaju vece
    % numericke vrijednosti mogu nepravedno dominirati racunanjem udaljenosti.
    % Zato se standardizacija radi prije treniranja/predikcije.
    %
    % Parametri standardizacije se racunaju samo na trening skupu.
    mu = mean(XTrain);
    sigma = std(XTrain);
    sigma(sigma == 0) = 1;

    XTrainStd = (XTrain - mu) ./ sigma;
    XTestStd = (XTest - mu) ./ sigma;

    %% Izbor broja susjeda
    % U ovom eksperimentu koristi se k = 5, kao u osnovnoj klasifikaciji.
    k = 5;

    %% Ugradjeni MATLAB KNN model
    % fitcknn predstavlja gotovu MATLAB implementaciju KNN algoritma.
    % Standardize je false jer je standardizacija vec uradjena rucno.
    knnBuiltinModel = fitcknn(XTrainStd, YTrain, ...
        'NumNeighbors', k, ...
        'Standardize', false);

    YPredBuiltin = predict(knnBuiltinModel, XTestStd);
    accBuiltin = mean(YPredBuiltin == YTest) * 100;

    %% Rucna KNN implementacija
    % Ovdje se koristi posebno napisana funkcija manual_knn_predict,
    % koja sama racuna udaljenosti, pronalazi k najblizih susjeda i
    % dodjeljuje klasu vecinskim glasanjem.
    YPredManual = manual_knn_predict(XTrainStd, YTrain, XTestStd, k);
    accManual = mean(YPredManual == YTest) * 100;

    %% Poredjenje rezultata
    fprintf('\nPOREDJENJE KNN IMPLEMENTACIJA NA IRIS DATASETU:\n');
    fprintf('Broj susjeda k                       = %d\n', k);
    fprintf('Tacnost ugradjene MATLAB KNN funkcije = %.2f %%\n', accBuiltin);
    fprintf('Tacnost rucne KNN implementacije      = %.2f %%\n', accManual);

    % Broj uzoraka kod kojih se dvije implementacije razlikuju.
    % Ako je sve implementirano konzistentno, ovaj broj je cesto 0.
    numDifferentPredictions = sum(YPredBuiltin ~= YPredManual);
    fprintf('Broj razlicitih predikcija            = %d\n', numDifferentPredictions);

    %% Tabelarni prikaz
    resultsTable = table( ...
        [accBuiltin; accManual], ...
        'VariableNames', {'Tacnost_u_procentima'}, ...
        'RowNames', {'Ugradjeni_KNN', 'Rucni_KNN'});

    disp(resultsTable);

    %% Konfuzione matrice za vizuelno poredjenje
    figure('Name','Ugradjeni KNN - konfuziona matrica');
    confusionchart(YTest, YPredBuiltin);
    title('Iris Dataset - ugradjeni KNN');

    figure('Name','Rucni KNN - konfuziona matrica');
    confusionchart(YTest, YPredManual);
    title('Iris Dataset - rucna KNN implementacija');

    %% Pohrana rezultata
    results.k = k;
    results.AccuracyBuiltin = accBuiltin;
    results.AccuracyManual = accManual;
    results.NumberOfDifferentPredictions = numDifferentPredictions;
    results.YTest = YTest;
    results.YPredBuiltin = YPredBuiltin;
    results.YPredManual = YPredManual;
end
