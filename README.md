# Polypode Quêtes

Fenêtre **« Quêtes de l'équipe »** de [Polypode](https://github.com/Baktov/polypode), sous forme
d'addon séparé : il se charge ou non comme n'importe quel addon (liste des AddOns de WoW, par
personnage). Désactivé, Polypode fonctionne normalement, sans bouton « Quêtes » ni commande
`/poly quetes`.

---

## Installation

1. Installer d'abord **Polypode** (dépendance obligatoire).
2. Placer le dossier `Polypode_Quetes` dans `World of Warcraft/_retail_/Interface/AddOns/`
   (et, pour **WoW Forever**, dans `World of Warcraft/_classic_beta_/Interface/AddOns/`, par
   exemple par une jonction `mklink /J`).
3. Cocher « Polypode Quêtes » dans la liste des AddOns.

---

## Utilisation

Le bouton **Quêtes** (barre de titre de la fenêtre Polypode) ou `/poly quetes` ouvre une fenêtre
qui liste les quêtes du **leader de l'équipe sélectionnée** (les vôtres si l'équipe n'a pas de
leader) et, pour chacune, les membres de l'équipe qui **ne l'ont pas** (en rouge), ou « toute
l'équipe ». Les quêtes qui manquent au plus de membres viennent en premier ; au survol,
l'infobulle détaille qui l'a et qui ne l'a pas. La liste défile ; Échap ferme la fenêtre.

Les journaux de quêtes sont échangés par **Polypode** lui-même (à la connexion et à chaque quête
acceptée, rendue ou abandonnée) : la fenêtre se met à jour d'elle-même. Un membre dont le journal
n'a pas été reçu (pas de Polypode, pas encore vu cette session) apparaît comme « inconnu ». Les
expéditions, objectifs bonus et quêtes cachées ne sont pas listés.

Cet addon n'a pas d'options. L'acceptation, la validation et le partage automatiques des quêtes
restent dans Polypode (et dans ses options).

---

## Version

`1.0.0` : fenêtre « Quêtes de l'équipe » sortie de Polypode 0.48.3.
