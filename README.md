# MP3-SLICER

## But du projet

### Passer un fichier audio contenant plusieurs séquences audio et de pouvoir obtenir un fichier audio par séquences

#### Le fichier audio doit pouvoir être accompagné de

- timecodes pour vérifier que le découpage est cohérent
- noms pour pouvoir nommer les fichiers audio automatiquement
- métadonnées pour pouvoir les ajouter aux fichier audio automatiquement

## Etapes du programme

### 1 : Recupérer les données en input

- la liste des temps de début et les noms en input dans le fichier "src/input/starts-and-titles.txt"

### 2 : faire une boucle qui va tenter de retouver les morceaux a partir des silences, pour trouver les silences il faudra effectuer la commande ffmpeg en faisant varier la valeur db et temps de silence. Dans un premier temps on fera varier seulement la variable db de 0 a 100 avec des palier de 5 en 5

### 3 : dans la boucle il faudra comparer si le nombre de morceaux trouvé correspond au nombre de morceaux en input, si les nombres coincide alors on peut supposer que les morceaux ont été trouvés

### 4 : découper la longue chanson "src/data/input.mp3" en sous morceaux en fonction des temps debut - fin et lui donner le bon nom "num chanson-titre.mp3" par exemple "1-rivière.mp3"
