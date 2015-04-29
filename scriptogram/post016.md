Date: 2015-03-21 21:11
Title: A propos des outils

Je voudrais revenir un instant sur les logiciels [Open Source](http://fr.wikipedia.org/wiki/Open_source) que nous utilisons dans ce projet. 
La figure suivante vous permettra d'en prendre connaissance:

![OSS2.png](https://dl.dropboxusercontent.com/u/17878888/junibis/img/OSS2.png)

* Les données de base (unités, positions, localités...) sont tout d'abord encodées dans le tableur de [LibreOffice](http://www.libreoffice.org/)
* Ces données sont, dans un premier temps, transférées dans une base de données locale [SQLite](http://www.sqlite.org/) afin de les structurer et de les vérifier.
* Pour le site web, on fait plutôt appel à [PostgreSQL](http://www.postgres.org/) pour le stockage des données.
* Les données géo-référencées (lieux de combat et positions d'unités) sont contrôlées avec [QuantumGIS](http://www2.qgis.org/), le meilleur logiciel GIS client Open Source.
* Les données de déplacement sont publiées sur [CartoDB](http://cartodb.com/) qui crée les cartes.
* Pour le site JunIBIS.be, le back-end est écrit en [Ruby on Rails](http://www.rubyonrails.org). Le front-end est en [Javascript](http://www.w3schools.com/js/) avec le framework [Bootstrap](http://getbootstrap.com/) .

Voilà, n'hésitez pas à suivre les liens de cet article afin d'en savoir plus. Et si vous voulez essayer par vous-même, il vous suffit de les télécharger, ils sont gratuits! Un conseil : Commencez par LibreOffice et QuantumGIS, vous allez déjà pouvoir faire localement vos premières cartes.

A bientôt,




