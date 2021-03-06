# Question 1. voir notebook veille -> Veille_SGBD.ipynb


# ---------------------------------------------------------------------------
# Question 2. Récuperer les deux DataSet


# ---------------------------------------------------------------------------
# Question 3. Créer la base de données
## "Avant de créer la base de donnée, il faut étudier les données en python, notamant pour connaitre les longeurs de chacune des"
## "chaines de caractère du tableau -> voir Lecture_fichiers_netflix.ipynb"

## "Connection au server mysql (bien spécifier --local-infile lorsqu'on se log pour load un BD)"
## "Toujours TOURJOURS load en local"
mysql --local-infile=1 -u anthony -p 

# "sinon rajouter SET GLOBAL local_infile = 1;"

## "Créer la base de donnée"
drop database Netflix;
CREATE DATABASE Netflix;


# ------------------------------------------------------------------------------
# Question 4. Créer la table NetflixShows et la remplir à partir du fichier Netflix_Shows.csv

## "Créer la table"
drop table if exists NetflixShows;
CREATE TABLE NetflixShows(
  title             VARCHAR(63) NOT NULL
  ,rating            VARCHAR(9) NOT NULL
  ,ratingLevel       VARCHAR(126)
  ,ratingDescription INTEGER  NOT NULL
  ,release_year      INTEGER  NOT NULL
  ,user_rating_score FLOAT NOT NULL
  ,user_rating_size  INTEGER  NOT NULL
  ,id INT NOT NULL AUTO_INCREMENT
  ,PRIMARY KEY(id)
);

## "Puis on remplis les valeurs"
# LOAD DATA LOCAL INFILE '/home/anthony/Documents/Briefs/20201109_SGBDR/Datas/Netflix_Shows.csv' 
LOAD DATA LOCAL INFILE './Datas/Netflix_Shows.csv'
INTO TABLE NetflixShows
CHARACTER SET latin1
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


# ------------------------------------------------------------------------------
# Question 5. Créer la table NetflixTitle et la remplir à partir du fichier Netflix_Title.csv

## "Pour la seconde"
drop table if exists NetflixTitle;
CREATE TABLE NetflixTitle(
   show_id      INTEGER  NOT NULL PRIMARY KEY 
  ,type         VARCHAR(8) NOT NULL
  ,title        VARCHAR(105) NOT NULL
  ,director     VARCHAR(209)
  ,cast         VARCHAR(772)
  ,country      VARCHAR(124)
  ,date_added   VARCHAR(20) 
  ,release_year INTEGER  NOT NULL
  ,rating       VARCHAR(9)
  ,duration     VARCHAR(11) NOT NULL
  ,listed_in    VARCHAR(80) NOT NULL
  ,description  VARCHAR(249) NOT NULL
);

## "Puis on remplis les valeurs"
# LOAD DATA LOCAL INFILE '/home/anthony/Documents/Briefs/20201109_SGBDR/Datas/netflix_titles.csv' 
LOAD DATA LOCAL INFILE './Datas/netflix_titles.csv' 
INTO TABLE NetflixTitle 
CHARACTER SET latin1
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


# ---------------------------------------------------------------------
# Question 6. Afficher tous les titres de films de la table netflix_titles dont l’ID est inférieur strict à 
# 80000000

USE Netlix;
SELECT title FROM NetflixTitle WHERE show_id < 80000000;
## "On obtient 1346 lignes retournées, donc 1346 titres de films dont l' ID est inférieur strict à 80000000

### CORRECTION
SELECT title FROM netflix_titles WHERE (type="Movie" AND show_id<80000000);
## car il faut afficher que les films


# ---------------------------------------------------------------------
# Question 7. Afficher toutes les durée des TV Show

USE Netlix;
SELECT duration FROM NetflixTitle WHERE NetflixTitle.type = 'TV Show';

## "On obtient l'affichage des nombres de saison pour les 1969 lignes correcpondant à des TV Show


# ---------------------------------------------------------------------
# Question 9. Afficher tous les noms de films communs aux 2 tables (netflix_titles et netflix_shows)

USE Netlix;
SELECT DISTINCT NetflixShows.title 
FROM NetflixShows, NetflixTitle 
WHERE NetflixShows.title = NetflixTitle.title;

## "Affiche 242 titres en commun dans les deux tables, il y a aussi une possibilité de le faire avec 
## une jointure"

USE Netlix;
SELECT NetflixShows.title 
FROM NetflixShows INNER JOIN NetflixTitle ON NetflixShows.title = NetflixTitle.title 
GROUP BY NetflixShows.title
ORDER BY NetflixShows.title; 
## "On peux rajouter la fonction ORDER BY qui range les titres par ordre alphabetique Mais ce n'est 
## pas obligatoire."


# ----------------------------------------------------------------------
# Question 10. Calculer la durée totale de tous les films (Movie)S de votre table netflix_titles

USE Netlix;
SELECT SUM(duration) FROM NetflixTitle WHERE NetflixTitle.type = 'Movie';

## "A creuser car la durée n'est pas mise en forme, ici on est en presence de string qu'on pourrait 
## caster mais il y a aussi l'inité ->min" 
## SELECT duration, SUBSTR(duration, 1, 3), LENGTH(SUBSTR(duration, 1, 3))
## FROM NetflixTitle WHERE NetflixTitle.type = 'Movie'

### CORRECTION
## SELECT sum(SUBSTR(duration, 1, 3)) from netflix_titles WHERE type = 'Movie';
#ALTER TABLE netflix_titles
#ADD COLUMN durnum INT 
#GENERATED ALWAYS AS (
#CASE
#    WHEN type='Movie' AND length(duration)=6 THEN (LEFT(duration,2))
#    WHEN type='Movie' AND length(duration)=7 THEN (LEFT(duration,3))
#    WHEN type='TV Show' AND length(duration)=10 THEN (LEFT(duration,2)* 10 *50)
#    ELSE LEFT(duration,1) * 10 *50 END) STORED; 
-- We suppose each season of a TV show is composed of ten 50 min episodes 
USE Netflix;
SELECT sum( SUBSTR(duration , 1, 3)) from NetflixTitle WHERE type = 'Movie'; ## fonctionne !!!!
##SELECT sum(CAST(SUBSTR(duration , 1, 3) AS INT)) from NetflixTitle WHERE type = 'Movie'; # Ne fonctionne 
# pas et pourtant c'est la structure complete

#SELECT SUM(durnum) FROM netflix_titles WHERE type='Movie';


# -----------------------------------------------------------------------
# Question 11. Compter le nombre de TV Shows de votre table ‘netflix_shows’ dont le ‘ratingLevel’ est 
# renseigné.

USE Netlix;
SELECT COUNT(NetflixShows.title)
FROM NetflixShows INNER JOIN NetflixTitle ON NetflixShows.title = NetflixTitle.title
WHERE NetflixShows.ratingLevel !='' AND NetflixTitle.type = 'TV Show';

## "compte 374 lignes où la colone ratingLevel n'est pas renseigné dans la table NetflixShows et qui 
## corresponde à de TV Show"
## "En revanche certain programme apparaisent plusieurs fois, il se peux que ce soit les differentes 
## saisons qui sont diffusés"


# -----------------------------------------------------------------------
# Question 12. Compter les films et TV Shows pour lesquels les noms (title) sont les mêmes sur les 2 
# tables et dont le ‘release year’ est supérieur à 2016.

USE Netflix;
SELECT COUNT(DISTINCT NetflixShows.title) 
FROM NetflixShows 
INNER JOIN NetflixTitle ON NetflixShows.title = NetflixTitle.title 
WHERE NetflixTitle.release_year > 2016 AND NetflixTitle.release_year>2016;
## "fonctionne : attention à ne pas utiliser GROUP BY car il compte le nombre d'occurrance de chaque doublon

USE Netlix;
SELECT COUNT(DISTINCT NetflixShows.title)
FROM NetflixShows, NetflixTitle
WHERE NetflixShows.title = NetflixTitle.title AND NetflixTitle.release_year > 2016;

## "Avec cette requette, le résultats semble correcte. Nous avons 37 films commun au deux tables et ayant 
## un release_year > 2016"


# ------------------------------------------------------------------------
# Question 13. Supprimer la colonne ‘rating’ de votre table ‘netflix_shows’

USE Netlix;
ALTER TABLE NetflixShows DROP COLUMN rating;

# -------------------------------------------------------------------------
# Question 14. Supprimer les 100 dernières lignes de la table ‘netflix_shows’

USE Netlix;
# ajouter avant le code suivant si on a pas deja l'index
# ALTER TABLE netflix_shows ADD id INT NOT NULL AUTO_INCREMENT primary key first
DELETE FROM NetflixShows ORDER BY id DESC LIMIT 100;
## "Efface les 100 lignes en partant de la fin basé sur les Id"

## pour supprimer au milieu
Use Netflix;
DELETE FROM netflix_shows WHERE id BETWEEN 200 AND 300;

### AUTRE POSIBILITE sans avoir d'Id
# SELECT * 
# FROM netflix_shows
# LIMIT 100 OFFSET 900;
# DELETE FROM NetflixShows
# WHERE LIMIT 100 OFFSET 900 ;


# -------------------------------------------------------------------------
# Question 15. Le champs “ratingLevel” pour le TV show “Marvel Iron Fist” de la table ‘netflix_shows’ 
# est vide, pouvez-vous ajouter un commentaire ?

USE Netflix;
SELECT * FROM NetflixShows where NetflixShows.title ="Marvel\'s Iron Fist";
SET SQL_SAFE_UPDATES = 0;
UPDATE NetflixShows 
SET NetflixShows.ratingLevel = "Le commentaire ajouté" 
WHERE NetflixShows.title ="Marvel\'s Iron Fist";
SELECT * FROM NetflixShows where NetflixShows.title ="Marvel\'s Iron Fist";
## " Ajoute le commentaire à toutes les lignes contenant le meme titre mais à priori nous n'avons 
## pas de manière de differentier les différentes lignes"


# -----------------------------------------------------------------------------
# Question 16. Réaliser une veille sur le modèle d’analyse et de conception Merise
### CORRECTION


# ------------------------------------------------------------------------------
# Question 17. Modéliser (Merise) votre Base de données netflix. Que pouvez-vous dire de cette modélisation ?
### CORRECTION

