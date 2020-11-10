# Question 1. voir notebook veille


# Question 2. Récuperer les deux DataSet


# Question 3. Créer la base de données

## "Connection au server mysql (bien spécifier --local-infile lorsqu'on se log pour load un BD)"
## "Toujours TOURJOURS load en local"
mysql -u anthony -p --local-infile

# "sinon rajouter SET GLOBAL local_infile = 1;"

## "Créer la base de donnée"
drop database Netflix;
CREATE DATABASE Netflix;


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


# Question 6. Afficher tous les titres de films de la table netflix_titles dont l’ID est inférieur strict à 80000000

SELECT title FROM NetflixTitle WHERE show_id < 80000000;

## "On obtient 1346 lignes retournées, donc 1346 titres de films dont l' ID est inférieur strict à 80000000


# Question 7. Afficher toutes les durée des TV Show

SELECT duration FROM NetflixTitle WHERE NetflixTitle.type = 'TV Show'

## "On obtient l'affichage des nombres de saison pour les 1969 lignes correcpondant à des TV Show


# Question 9. Afficher tous les noms de films communs aux 2 tables (netflix_titles et netflix_shows)

SELECT DISTINCT NetflixShows.title FROM NetflixShows, NetflixTitle WHERE NetflixShows.title = NetflixTitle.title;

## "Affiche 242 titres en commun dans les deux tables, il y a aussi une possibilité de le faire avec une jointure"

SELECT NetflixShows.title FROM NetflixShows INNER JOIN NetflixTitle ON NetflixShows.title = NetflixTitle.title GROUP BY NetflixShows.title ORDER BY NetflixShows.title; ## "On peux rajouter la fonction ORDER BY qui range les titres par ordre alphabetique Mais ce n'est pas obligatoire."


# Question 10. Calculer la durée totale de tous les films (Movie)S de votre table netflix_titles

SELECT SUM(duration) FROM NetflixTitle WHERE NetflixTitle.type = 'Movie'

"A creuser"


# Question 11. Compter le nombre de TV Shows de votre table ‘netflix_shows’ dont le ‘ratingLevel’ est renseigné.

SELECT COUNT(NetflixShows.title)
FROM NetflixShows INNER JOIN NetflixTitle ON NetflixShows.title = NetflixTitle.title
WHERE NetflixShows.ratingLevel !='' AND NetflixTitle.type = 'TV Show' 

##"compte 374 lignes où la colone ratingLevel n'est pas renseigné dans la table NetflixShows et qui corresponde à de TV Show"
## "En revanche certain programme apparaisent plusieurs fois, il se peux que ce soit les differentes saisons qui sont diffusés"


# Question 12. Compter les films et TV Shows pour lesquels les noms (title) sont les mêmes sur les 2 tables et dont le ‘release year’ est supérieur à 2016.

SELECT COUNT(NetflixShows.title) FROM NetflixShows INNER JOIN NetflixTitle ON NetflixShows.title = NetflixTitle.title WHERE NetflixTitle.release_year > 2016 GROUP BY NetflixShows.title;

## "Avec cette requette, il y a une petite erreur que je ne trouve pas puisqu'il me sort le nombre d'ocurrence de chaque film ayant un release > 2016"

SELECT COUNT(DISTINCT NetflixShows.title)
FROM NetflixShows, NetflixTitle
WHERE NetflixShows.title = NetflixTitle.title AND NetflixTitle.release_year > 2016;

## "Avec cette requette, le résultats semble correcte. Nous avons 37 films commun au deux tables et ayant un release_year > 2016"


# Question 13. Supprimer la colonne ‘rating’ de votre table ‘netflix_shows’

ALTER TABLE NetflixShows DROP COLUMN rating


# Question 14. Supprimer les 100 dernières lignes de la table ‘netflix_shows’

DELETE FROM NetflixShows ORDER BY id DESC LIMIT 100;

## "Efface les 100 lignes en partant de la fin basé sur les Id"


# Question 15. Le champs “ratingLevel” pour le TV show “Marvel Iron Fist” de la table ‘netflix_shows’ est vide, pouvez-vous ajouter un commentaire ?

SELECT * FROM NetflixShows where NetflixShows.title ="Marvel\'s Iron Fist";
SET SQL_SAFE_UPDATES = 0;
UPDATE NetflixShows 
SET NetflixShows.ratingLevel = "Le commentaire ajouté" 
WHERE NetflixShows.title ="Marvel\'s Iron Fist";
SELECT * FROM NetflixShows where NetflixShows.title ="Marvel\'s Iron Fist";

##" Ajoute le commentaire à toutes les lignes contenant le meme titre mais à priori nous n'avons pas de manière de differentier les différentes lignes"


# Question 16. Réaliser une veille sur le modèle d’analyse et de conception Merise

# Question 17. Modéliser (Merise) votre Base de données netflix. Que pouvez-vous dire de cette modélisation ?


