# CLAUDE.md — Polypode Quêtes (Addon WoW)

Conventions communes et procédure de documentation de tous les modules Polypode (chargées
automatiquement, quel que soit le dossier ouvert) :

@../Polypode/MODULES.md

Addon compagnon de **Polypode** (dossier voisin `../Polypode`, dépôt séparé) : la fenêtre
« Quêtes de l'équipe » et son bouton, sortis de Polypode 0.48.3 pour pouvoir être chargés ou non.
Seule l'interface est ici : l'échange des journaux de quêtes (`QLOG`) et l'acceptation / validation
/ partage automatiques des quêtes restent dans Polypode. Les conventions de Polypode s'appliquent
(voir `../Polypode/CLAUDE.md`) : commentaires en français, code en anglais, pas de librairie
externe, pas de `print()`, bloc `-- Polypode Quêtes: Fichier — rôle` en tête de fichier, tout
contenu de taille variable défile, Retail (120000) et WoW Forever (16001).

## Architecture

| Fichier | Rôle |
|---|---|
| `Polypode_Quetes.toc` | `## Dependencies: Polypode` ; pas de SavedVariables (aucune option) |
| `TeamQuests.lua` | Fenêtre `PolypodeTeamQuestsFrame` (`P.ToggleTeamQuests`, `P.RefreshTeamQuests` — fonctions ajoutées à la table `Polypode`, `P.ui.teamQuestsFrame` / `P.ui.teamQuestsPanel`) : quêtes du leader de l'équipe sélectionnée (`P.GetCharacterQuests`), membres qui ne l'ont pas / l'ont / inconnus, liste défilante (`P.CreateScrollList`), Échap ferme ; clic sur une quête du journal du joueur (`C_QuestLog.GetLogIndexForQuestID`) → `QuestMapFrame_OpenToQuestDetails` (repli `ToggleQuestLog`), fenêtre fermée. Intégration : bouton par `P.AddTitleButton` (`P.ui.questsButton`, `hideInSolo` : masqué en mode solo de Polypode 0.54.0 ; `P.IsSoloMode` → `P.RefreshTeamQuests` ferme la fenêtre, `P.ToggleTeamQuests` refuse), commande `P.RegisterSlashCommand("quetes")` + alias `quêtes` |

## Dépendances vers Polypode (API publique utilisée)

`P.AddTitleButton`, `P.RegisterSlashCommand`, `P.CreatePanel`, `P.CreateScrollList`,
`P.SetListData`, `P.SkinFrame`, `P.SkinPanel`, `P.GetSelectedTeam`, `P.GetTeamLeader`,
`P.GetTeamMembers`, `P.GetCharKey`, `P.GetDisplayName`, `P.GetCharacterQuests`. Polypode appelle
`P.RefreshTeamQuests` (si défini) à chaque journal de quêtes reçu ou modifié, à chaque titre de
quête chargé et à chaque `P.RefreshUI`. Toute évolution de ces fonctions dans Polypode doit rester
compatible, ou ce fichier doit suivre.

## Après chaque modification

Appliquer la procédure de `../Polypode/MODULES.md` (« Après chaque modification d'un module »),
sans attendre qu'on le demande : version du `.toc` et du commit, ligne en tête de la section
« Version » du `README.md` et sections d'utilisation, ce fichier (architecture, dépendances),
Polypode si le périmètre change, puis commit et push sur `origin` (https://github.com/Baktov/Polypode-quetes).
