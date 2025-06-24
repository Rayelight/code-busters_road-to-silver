# code-busters_road-to-silver


## Améliorations

- Rendre avoir des lambdas qui n'ont pas bsn d'être redéployée (avec un code qu'elle récupère directement d'une librairie externe)
- Avoir des versions préchargées des libs dans les reqs pour éviter tout problème de sécurité lié à la réimportation d'une lib
- Avoir des libs communes pour ne pas pip la meme librairies plusieurs fois pour chaque lambda
- Avoir un event bridge qui rajoute automatiquement des event a la lambda avec un certain interval pour avoir un semblant de real time
- Traiter automatiquement les données gérer sur le bucket pour créer une couche silver
- Rajouter un dashboard pour visualiser ces données traitées
- Ne pas détruire les bucket lorsque l'infra est redéployée (Pour ne pas perdre les données et executions)