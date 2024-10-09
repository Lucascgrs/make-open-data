# Bienvenue sur Make Open Data.


### Des données publiques exploitables déployées sur une BDD Postgres/PostGIS accessibles depuis l'outil de votre choix.

- Présentation du projet ou contactez nous pour une démo : https://make-open-data.fr/ 
- Catalogue des données : https://data.make-open-data.fr/


Make Open Data est ELT Open Source pour données publiques :

- *Extrait* les fichiers sources (data.gouv, INSEE, Etalab, etc.) les plus adaptés et les récents ; 
- *Transforme* ces données selon des règles transparentes et le moins irréversibles possibles ;
- *Stocke* ces données dans une base de données PostgreSQL (avec PostGIS) ;
- *Teste* des présupposés sur ces données. Un prix par transaction immobilière sur DVF par exemple.

<img src="assets/make-open-data-flow.png" width="600">



Données spatiales intégrables dans QGIS et autres SIG.

<img src="assets/demo-qgis.png" width="600">






## Déploiement managé par Make Open Data

Nous fournissons les accès à une Postgres dans le cloud avec des données à jour.

Contactez-nous https://make-open-data.fr/ 


## Déploiement avec GitHub Actions


**_Prérequis:_** : Instance Postgres > 15, **cloud uniquement**, avec 40 Go de disque et 4 Go de mémoire.


- Foucher (*fork*) le projet dans un nouveau Repo [ici](https://github.com/make-open-data/make-open-data/fork)  

- Renseigner les clés d'une BDD Postgres dans le Cloud 

- Exécuter le workflow "Manually Deploy Data in a Postgres Database" 

- Les tables sources et préparées sont disponibles dans la BDD


## Déploiement sur une machine

**_Prérequis:_** : Instance Postgres > 15, cloud ou local, avec 40 Go de disque et 4 Go de mémoire.


Idéal pour déployer les nouvelles tables de données publiques sans tracas une BDD Postgres hébergée dans le cloud.

- Cloner le repo

```
git clone git@github.com:make-open-data/make-open-data.git
``` 
- Installer et activer un environnement virtuel


```
python3.11 -m venv dbt-env 
source dbt-env/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
``` 



- Exporter les clés d'une instance PostgreSQL avec l’extension PostGIS de 10 GB min

```
export POSTGRES_USER=<YOUR_POSTGRES_USER>  
export POSTGRES_PASSWORD=<YOUR_POSTGRES_PASSWORD> 
export POSTGRES_HOST=<YOUR_POSTGRES_HOST> 
export POSTGRES_PORT=<YOUR_POSTGRES_PORT>  
export POSTGRES_DB=<YOUR_POSTGRES_DB>
``` 

- Installer PostGis :

```
psql postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DB
CREATE EXTENSION postgis;  
```

- Extraire les données sources dans le schema `sources`:

```
python -m load
```

Etape temporaire : 
    - Une extraction automatique ne vaut pas le coup étant donné la diversité des fichiers sources (zip, csv, json, 7z, etc) et la mise à jour non fréquente des sources ;
    - Une solution du type Lakehouse est en cours d'analyse (`SELECT * FROM "red_parquet(<URL>.parquet)"`)


- Connecter DBT à la base de données

```
export DBT_PROFILES_DIR=.  
dbt debug
dbt deps
``` 


- Réaliser et tester les transformations pour obtenir les tables finales

```
dbt seed
dbt run --target dev #Table logement sur région Occitanie et dvf sur Hérault. Utile pour tester rapidement. 
dbt run --target production
dbt test
``` 

- Les tables sources et préparées sont disponibles dans la BDD
