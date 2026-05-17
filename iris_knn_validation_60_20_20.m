function results = iris_knn_validation_60_20_20()
%IRIS_KNN_VALIDATION_60_20_20 Izbor najboljeg k pomocu validacijskog skupa.
%
%   U osnovnoj verziji projekta koristi se HoldOut podjela 70/30, gdje se
%   podaci dijele samo na trening i test skup.
%
%   U ovom eksperimentu uvodi se validacijski skup:
%   - 60% podataka za trening
%   - 20% podataka za validaciju
%   - 20% podataka za finalno testiranje
%
%   Validacijski skup se koristi za izbor najboljeg parametra k kod KNN
%   algoritma. Test skup se ne koristi tokom izbora k, nego samo na kraju,
%   kako bi se dobila objektivnija procjena performansi finalnog modela.

    %% Ucitavanje Iris dataseta
    load fisheriris
    X = meas;
    Y = categorical(species);

    %% Prva podjela: 60% trening, 40% privremeni skup
    % Privremeni skup ce se zatim podijeliti na validaciju i test.
    cv1 = cvpartition(Y, 'HoldOut', 0.4);

    idxTrain = training(cv1);
    idxTemp = test(cv1);

    XTrain = X(idxTrain, :);
    YTrain = Y(idxTrain);

    XTemp = X(idxTemp, :);
    YTemp = Y(idxTemp);

    %% Druga podjela: 40% privremenog skupa na 20% validacija i 20% test
    % Posto je XTemp 40% ukupnog dataseta, njegova HoldOut podjela 50/50
    % daje validacijski i test skup od po 20% ukupnih podataka.
    cv2 = cvpartition(YTemp, 'HoldOut', 0.5);

    idxValLocal = training(cv2);
    idxTestLocal = test(cv2);

    XVal = XTemp(idxValLocal, :);
    YVal = YTemp(idxValLocal);

    XTest = XTemp(idxTestLocal, :);
    YTest = YTemp(idxTestLocal);

    %% Standardizacija
    % Srednja vrijednost i standardna devijacija racunaju se samo na
    % trening skupu. Isti parametri se zatim koriste za validacijski i
    % test skup. Ovo je vazno jer validacijski i test podaci treba da
    % simuliraju nevidjene podatke.
    mu = mean(XTrain);
    sigma = std(XTrain);
    sigma(sigma == 0) = 1;

    XTrainStd = (XTrain - mu) ./ sigma;
    XValStd = (XVal - mu) ./ sigma;
    XTestStd = (XTest - mu) ./ sigma;

    %% Validacija razlicitih vrijednosti parametra k
    % Koriste se neparne vrijednosti k da bi se smanjila mogucnost
    % nerijesenog glasanja izmedju klasa.
    kValues = 1:2:15;
    validationAccuracyManual = zeros(length(kValues), 1);
    validationAccuracyBuiltin = zeros(length(kValues), 1);

    for i = 1:length(kValues)
        k = kValues(i);

        %% Rucna KNN implementacija na validacijskom skupu
        YPredValManual = manual_knn_predict(XTrainStd, YTrain, XValStd, k);
        validationAccuracyManual(i) = mean(YPredValManual == YVal) * 100;

        %% Ugradjeni KNN na validacijskom skupu
        knnModel = fitcknn(XTrainStd, YTrain, ...
            'NumNeighbors', k, ...
            'Standardize', false);

        YPredValBuiltin = predict(knnModel, XValStd);
        validationAccuracyBuiltin(i) = mean(YPredValBuiltin == YVal) * 100;
    end

    %% Izbor najboljeg k
    % Najbolji k se bira na osnovu najvece tacnosti na validacijskom skupu.
    % Ako vise vrijednosti k daju istu tacnost, MATLAB funkcija max vraca
    % prvu od njih, odnosno manji k. To je prihvatljivo jer manji k cesto
    % zadrzava lokalniju strukturu podataka.
    [bestValAccManual, bestIdxManual] = max(validationAccuracyManual);
    bestKManual = kValues(bestIdxManual);

    [bestValAccBuiltin, bestIdxBuiltin] = max(validationAccuracyBuiltin);
    bestKBuiltin = kValues(bestIdxBuiltin);

    %% Finalno testiranje nakon izbora k
    % Test skup se koristi tek sada, nakon sto je k izabran. Na taj nacin
    % test tacnost predstavlja realniju procjenu rada modela na novim
    % podacima.
    YPredTestManual = manual_knn_predict(XTrainStd, YTrain, XTestStd, bestKManual);
    testAccuracyManual = mean(YPredTestManual == YTest) * 100;

    finalBuiltinModel = fitcknn(XTrainStd, YTrain, ...
        'NumNeighbors', bestKBuiltin, ...
        'Standardize', false);

    YPredTestBuiltin = predict(finalBuiltinModel, XTestStd);
    testAccuracyBuiltin = mean(YPredTestBuiltin == YTest) * 100;

    %% Ispis rezultata
    fprintf('\nKNN SA PODJELOM 60/20/20 I VALIDACIJSKIM SKUPOM:\n');
    fprintf('Broj trening uzoraka      = %d\n', size(XTrain, 1));
    fprintf('Broj validacijskih uzoraka = %d\n', size(XVal, 1));
    fprintf('Broj testnih uzoraka       = %d\n', size(XTest, 1));

    fprintf('\nNajbolji k za rucni KNN     = %d\n', bestKManual);
    fprintf('Validacijska tacnost        = %.2f %%\n', bestValAccManual);
    fprintf('Test tacnost rucnog KNN-a   = %.2f %%\n', testAccuracyManual);

    fprintf('\nNajbolji k za ugradjeni KNN = %d\n', bestKBuiltin);
    fprintf('Validacijska tacnost        = %.2f %%\n', bestValAccBuiltin);
    fprintf('Test tacnost ugradjenog KNN-a = %.2f %%\n', testAccuracyBuiltin);

    %% Tabela validacijskih rezultata
    validationTable = table( ...
        kValues', ...
        validationAccuracyManual, ...
        validationAccuracyBuiltin, ...
        'VariableNames', {'k', 'Rucni_KNN_validacija', 'Ugradjeni_KNN_validacija'});

    disp(validationTable);

    %% Graf validacijske tacnosti za razlicite k vrijednosti
    figure('Name','Validacija KNN parametra k');
    plot(kValues, validationAccuracyManual, 'o-', 'LineWidth', 1.2);
    hold on;
    plot(kValues, validationAccuracyBuiltin, '*-', 'LineWidth', 1.2);
    xlabel('Broj najblizih susjeda k');
    ylabel('Validacijska tacnost [%]');
    title('Izbor parametra k pomocu validacijskog skupa');
    legend('Rucni KNN', 'Ugradjeni KNN', 'Location', 'best');
    grid on;

    %% Konfuzione matrice finalnih modela na test skupu
    figure('Name','Finalni rucni KNN - test konfuziona matrica');
    confusionchart(YTest, YPredTestManual);
    title(['Rucni KNN, finalni test, k = ', num2str(bestKManual)]);

    figure('Name','Finalni ugradjeni KNN - test konfuziona matrica');
    confusionchart(YTest, YPredTestBuiltin);
    title(['Ugradjeni KNN, finalni test, k = ', num2str(bestKBuiltin)]);

    %% Pohrana rezultata
    results.kValues = kValues;
    results.ValidationAccuracyManual = validationAccuracyManual;
    results.ValidationAccuracyBuiltin = validationAccuracyBuiltin;

    results.BestKManual = bestKManual;
    results.BestKBuiltin = bestKBuiltin;

    results.BestValidationAccuracyManual = bestValAccManual;
    results.BestValidationAccuracyBuiltin = bestValAccBuiltin;

    results.TestAccuracyManual = testAccuracyManual;
    results.TestAccuracyBuiltin = testAccuracyBuiltin;

    results.YTest = YTest;
    results.YPredTestManual = YPredTestManual;
    results.YPredTestBuiltin = YPredTestBuiltin;
end
