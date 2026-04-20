# Implementacija-i-analiza-algoritama-superviziranog-ucenja-na-Loadgas-i-Iris-Flower-dataset-u

# Implementacija i analiza algoritama superviziranog učenja na Loadgas i Iris Flower dataset-u

Ovaj projekat prikazuje implementaciju i analizu algoritama superviziranog učenja u MATLAB okruženju na dva različita problema:

- **Iris Flower dataset** – klasifikacioni problem
- **Loadgas dataset** – regresioni problem

Cilj projekta je pokazati razliku između klasifikacije i regresije, kao i način na koji se različiti modeli treniraju, testiraju i evaluiraju u MATLAB-u.

## Korišteni algoritmi

### Iris Flower dataset
Za klasifikaciju su korišteni sljedeći modeli:
- **K-Nearest Neighbors (KNN)**
- **Support Vector Machine (SVM)**
- **Decision Tree**

### Loadgas dataset
Za regresiju su korišteni sljedeći modeli:
- **Linear Regression**
- **Regression Tree**
- **Support Vector Regression (SVR)**

## Sadržaj repozitorija

Repozitorij sadrži sljedeće glavne fajlove: `main.m`, `iris_classification.m`, `loadgas_regression.m`, `computeRegressionMetrics.m`, `generate_dateset.m` i `loadgas.csv`. :contentReference[oaicite:1]{index=1}

Kratak opis:
- **main.m** – glavni fajl za pokretanje kompletnog projekta
- **iris_classification.m** – implementacija klasifikacije nad Iris datasetom
- **loadgas_regression.m** – implementacija regresije nad Loadgas datasetom
- **computeRegressionMetrics.m** – funkcija za računanje regresionih metrika
- **generate_dateset.m** – skripta za generisanje sintetičkog Loadgas dataseta
- **loadgas.csv** – spremljeni dataset za regresioni dio projekta

## Zahtjevi

Za pokretanje projekta potrebno je imati:
- **MATLAB** (preporučeno R2021a ili noviji)
- Statistics and Machine Learning Toolbox

## Kako pokrenuti projekat

### 1. Kloniranje repozitorija

U Command Window-u ili terminalu pokreni:

```bash
git clone <URL_REPOZITORIJA>
