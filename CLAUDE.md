# CLAUDE.md — Polypode Quêtes (Addon WoW)

Conventions communes et procédure de documentation de tous les modules Polypode (chargées
automatiquement, quel que soit le dossier ouvert) :

@../Polypode/MODULES.md

**ADDON OBSOLÈTE** (1.3.0) : ses fonctions sont reprises par le panneau « Quêtes » de Polypode
Suivi (1.23.0, `../Polypode_Suivi`), rafraîchi par `P.RegisterQuestLogCallback` (Polypode 0.58.0).
Ne plus le faire évoluer ; le dépôt peut être archivé sur GitHub.

## Architecture

| Fichier | Rôle |
|---|---|
| `Polypode_Quetes.toc` | Titre « Polypode Quêtes (obsolète) », `## Dependencies: Polypode`, pas de SavedVariables |
| `TeamQuests.lua` | Rappel seulement : à `PLAYER_LOGIN` + `REMINDER_DELAY` (8 s), message `UIErrorsFrame` « obsolète, à désactiver ». Plus de bouton (`P.AddTitleButton`), de fenêtre ni de commande `/poly quetes` (reprise par Suivi : les deux en conflit). Le code de la fenêtre (1.2.0) est dans l'historique git |

## Dépendances vers Polypode (API publique utilisée)

Aucune (seule `## Dependencies: Polypode` reste, pour être rangé avec les modules).

## Après chaque modification

Appliquer la procédure de `../Polypode/MODULES.md` (« Après chaque modification d'un module »),
sans attendre qu'on le demande : version du `.toc` et du commit, ligne en tête de la section
« Version » du `README.md` et sections d'utilisation, ce fichier (architecture, dépendances),
Polypode si le périmètre change, puis commit et push sur `origin` (https://github.com/Baktov/Polypode-quetes).
