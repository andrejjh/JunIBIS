Date: 2015-03-21 21:11
Title: Comment tout cela marche-t-il?

Ce projet utilise principalement des logiciels libres (Open Source Software). Contrairement aux logiciels propriètaires, ils sont gratuits et fonctionnent sur presque toutes les plateformes.
La figure suivante indique les principaux outils utilisés.

* Les données (unités, positions, localités...) sont tout d'abord encodées dans le tableur de [LibreOffice](http://www.libreoffice.org/)
* Tout ceci est ensuite transféré dans une base de données [SQLite](http://www.sqlite.org/) afin de structurer et de contrôler les données.
* Les lieux et positions d'unités sont visualisés avec [QuantumGIS](http://www2.qgis.org/)
* Finalement, les données sont envoyées dans [CartoDB](http://cartodb.com/) qui crée les cartes web.

![OSS.png](https://dl.dropboxusercontent.com/u/17878888/junibis/img/OSS.png)

Voilà, vous voyez ce n'est pas très sorcier et le secret de fabrication, s'il y en a un, se trouve plutôt dans l'originalité du sujet et la manière de l'aborder que dans de coûteux logiciels.

A bientôt,




