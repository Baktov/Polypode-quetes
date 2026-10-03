-- Polypode Quêtes: TeamQuests — addon OBSOLÈTE : ses fonctions sont dans Polypode Suivi

-- La fenêtre « Quêtes de l'équipe » (quêtes du leader manquantes chez les membres) est reprise par
-- le panneau « Quêtes » de Polypode Suivi (1.23.0), avec la commande /poly quetes. Cet addon ne
-- fait plus rien (ni bouton, ni fenêtre, ni commande, qui entreraient en conflit avec Suivi) :
-- il rappelle seulement, à la connexion, qu'il peut être désactivé.

local REMINDER_DELAY = 8 -- secondes après la connexion (après les messages de chargement)

local reminder = CreateFrame("Frame")
reminder:RegisterEvent("PLAYER_LOGIN")
reminder:SetScript("OnEvent", function(self)
	self:UnregisterEvent("PLAYER_LOGIN")
	C_Timer.After(REMINDER_DELAY, function()
		UIErrorsFrame:AddMessage("Polypode Quêtes est obsolète : ses quêtes sont dans Polypode Suivi "
			.. "(bouton « Quêtes »). Vous pouvez le désactiver.", 1, 0.82, 0)
	end)
end)
