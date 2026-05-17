function YPred = manual_knn_predict(XTrain, YTrain, XTest, k)
%MANUAL_KNN_PREDICT Rucna implementacija K-Nearest Neighbors algoritma.
%
%   YPred = manual_knn_predict(XTrain, YTrain, XTest, k)
%
%   Ulazi:
%   - XTrain: matrica trening osobina, dimenzije broj_uzoraka x broj_osobina
%   - YTrain: vektor poznatih klasa za trening uzorke
%   - XTest : matrica test/validacijskih osobina
%   - k     : broj najblizih susjeda koji ucestvuju u glasanju
%
%   Izlaz:
%   - YPred : predikovane klase za sve uzorke iz XTest
%
%   Napomena:
%   Ova funkcija namjerno ne koristi MATLAB funkciju fitcknn, jer je cilj
%   pokazati osnovnu logiku KNN algoritma: racunanje udaljenosti, sortiranje
%   susjeda i vecinsko glasanje.

    % Osigurava se da su labele kategoricke, jer se radi o klasifikaciji.
    % Na ovaj nacin se lakse porede stvarne i predikovane klase.
    YTrain = categorical(YTrain);

    % Broj testnih uzoraka za koje treba odrediti klasu.
    numTestSamples = size(XTest, 1);

    % Inicijalizacija izlaznog vektora. Koristi se isti skup kategorija kao
    % kod trening labela, da bi rezultat bio kompatibilan sa YTest.
    YPred = categorical(repmat(string(YTrain(1)), numTestSamples, 1), ...
        categories(YTrain));

    % KNN se izvrsava za svaki testni uzorak posebno.
    for i = 1:numTestSamples

        % Racunanje euklidske udaljenosti od trenutnog testnog uzorka
        % do svih trening uzoraka.
        %
        % Udaljenost se racuna kao:
        % d = sqrt((x1-a1)^2 + (x2-a2)^2 + ... + (xn-an)^2)
        %
        % Korijen nije neophodan za sortiranje, jer sqrt ne mijenja poredak,
        % pa se koristi kvadrat udaljenosti radi jednostavnijeg racunanja.
        distances = sum((XTrain - XTest(i, :)).^2, 2);

        % Sortiranje trening uzoraka od najblizeg do najudaljenijeg.
        [~, sortedIdx] = sort(distances, 'ascend');

        % Izdvajanje k najblizih susjeda.
        nearestIdx = sortedIdx(1:k);
        nearestLabels = YTrain(nearestIdx);

        % Vecinsko glasanje:
        % klasa koja se najcesce pojavljuje medju k susjeda postaje
        % predikovana klasa za dati testni uzorak.
        YPred(i) = mode(nearestLabels);
    end
end
