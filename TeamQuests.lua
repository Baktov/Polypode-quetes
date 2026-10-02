-- Polypode Quêtes: TeamQuests — fenêtre des quêtes du leader manquantes chez les membres

local P = Polypode -- dépendance obligatoire (## Dependencies: Polypode), chargée avant nous

-- Addon compagnon de Polypode, indépendant : il ajoute son bouton « Quêtes » à la barre de titre
-- de la fenêtre Polypode (P.AddTitleButton) et la commande /poly quetes (P.RegisterSlashCommand) ;
-- désactivé dans la liste des AddOns, Polypode fonctionne sans lui. Les journaux de quêtes restent
-- échangés par Polypode (message QLOG, P.GetCharacterQuests), qui appelle P.RefreshTeamQuests à
-- chaque journal reçu ou modifié et à chaque rafraîchissement de sa fenêtre.
-- Bouton « Quêtes » ou /poly quetes (P.ToggleTeamQuests). Liste
-- défilante des quêtes du leader de l'équipe sélectionnée (soi-même si l'équipe n'a pas de
-- leader) ; pour chacune, les membres de l'équipe qui ne l'ont pas (en rouge), ou « toute
-- l'équipe ». Les journaux viennent du Polypode de chaque membre (QLOG, Sync.lua de Polypode) : un membre
-- dont aucun journal n'a été reçu est « inconnu ». Les quêtes qui manquent au plus de
-- membres viennent en premier. Rafraîchie à chaque journal reçu ou modifié. Échap la ferme.
-- Clic sur une quête de son propre journal : l'ouvre dans le journal de quêtes.

local FRAME_WIDTH, FRAME_HEIGHT = 440, 320

local frame, listPanel
local titleRequested = {} -- [questID] = true : chargement déjà demandé (une fois par session)

local function MemberName(key)
	return P.GetDisplayName(key)
end

-- Titre d'une quête ; inconnu (quête d'un autre personnage), il est demandé une seule fois
-- au serveur et la fenêtre se rafraîchit à son arrivée (QUEST_DATA_LOAD_RESULT, Quests.lua).
local function QuestTitle(questID)
	local title = C_QuestLog.GetTitleForQuestID and C_QuestLog.GetTitleForQuestID(questID)
	if not title and not titleRequested[questID] and C_QuestLog.RequestLoadQuestByID then
		titleRequested[questID] = true
		C_QuestLog.RequestLoadQuestByID(questID)
	end
	return title or ("Quête n° " .. questID)
end

-- Lignes de la liste, texte d'en-tête et texte de liste vide.
local function BuildItems()
	local team = P.GetSelectedTeam()
	if not team then
		return {}, "Quêtes de l'équipe", "Sélectionnez une équipe."
	end
	local reference = P.GetTeamLeader(team) or P.GetCharKey()
	local header = "Quêtes de " .. MemberName(reference) .. " (équipe « " .. team .. " »)"
	local quests = P.GetCharacterQuests(reference)
	if not quests then
		return {}, header, "Journal de quêtes du leader pas encore reçu."
	end

	local others = {}
	for key in pairs(P.GetTeamMembers(team) or {}) do
		if key ~= reference then
			others[#others + 1] = key
		end
	end
	table.sort(others)

	local items = {}
	for questID in pairs(quests) do
		local item = { questID = questID, title = QuestTitle(questID), missing = {}, having = {}, unknown = {} }
		for _, key in ipairs(others) do
			local memberQuests = P.GetCharacterQuests(key)
			local list = not memberQuests and item.unknown or memberQuests[questID] and item.having or item.missing
			list[#list + 1] = MemberName(key)
		end
		items[#items + 1] = item
	end
	table.sort(items, function(a, b)
		if #a.missing ~= #b.missing then
			return #a.missing > #b.missing
		end
		return a.title < b.title
	end)
	return items, header, "Aucune quête dans le journal du leader."
end

local function FormatQuest(item)
	local text = item.title .. "  "
	if #item.missing > 0 then
		text = text .. "|cffff5555manque : " .. table.concat(item.missing, ", ") .. "|r"
	elseif #item.unknown == 0 then
		text = text .. "|cff40ff40toute l'équipe|r"
	end
	if #item.unknown > 0 then
		text = text .. " |cff999999(inconnu : " .. table.concat(item.unknown, ", ") .. ")|r"
	end
	return text
end

-- Vrai si la quête est dans le journal du personnage joué (seules celles-ci s'ouvrent en détail).
local function InOwnLog(questID)
	return C_QuestLog.GetLogIndexForQuestID and C_QuestLog.GetLogIndexForQuestID(questID) ~= nil
end

-- Clic sur une quête : ouvre le journal de quêtes (carte du monde) sur son détail ; journal simple
-- si l'API manque. La fenêtre se ferme, pour ne pas masquer la carte (strate supérieure).
local function OpenInQuestLog(item)
	if not InOwnLog(item.questID) then
		UIErrorsFrame:AddMessage("« " .. item.title .. " » n'est pas dans votre journal de quêtes.", 1, 0.1, 0.1)
		return
	end
	frame:Hide()
	-- Différé d'une image : la carte s'ouvre après le traitement du clic.
	C_Timer.After(0, function()
		if QuestMapFrame_OpenToQuestDetails then
			QuestMapFrame_OpenToQuestDetails(item.questID)
		else
			if C_QuestLog.SetSelectedQuest then
				C_QuestLog.SetSelectedQuest(item.questID)
			end
			if ToggleQuestLog then
				ToggleQuestLog()
			end
		end
	end)
end

local function QuestTooltip(item)
	local lines = { item.title, "|cff999999Quête n° " .. item.questID .. "|r" }
	if InOwnLog(item.questID) then
		lines[#lines + 1] = "Clic : ouvrir dans le journal de quêtes"
	else
		lines[#lines + 1] = "|cff999999Absente de votre journal (ne s'ouvre pas au clic)|r"
	end
	local function Section(title, names)
		if #names > 0 then
			lines[#lines + 1] = " "
			lines[#lines + 1] = title
			for _, name in ipairs(names) do
				lines[#lines + 1] = "  " .. name
			end
		end
	end
	Section("|cffff5555Ne l'ont pas :|r", item.missing)
	Section("|cff40ff40L'ont :|r", item.having)
	Section("|cff999999Inconnu (journal pas reçu de leur Polypode) :|r", item.unknown)
	return lines
end

local function Build()
	frame = CreateFrame("Frame", "PolypodeTeamQuestsFrame", UIParent, "BackdropTemplate")
	frame:SetSize(FRAME_WIDTH, FRAME_HEIGHT)
	frame:SetPoint("CENTER")
	frame:SetFrameStrata("DIALOG")
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", frame.StartMoving)
	frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
	frame:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 },
	})
	frame:SetBackdropColor(0, 0, 0, 0.9)
	frame:Hide()
	tinsert(UISpecialFrames, "PolypodeTeamQuestsFrame") -- Échap ferme la fenêtre

	local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	title:SetPoint("TOP", 0, -14)
	title:SetText("Quêtes de l'équipe")
	frame.TitleText = title

	local closeBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
	closeBtn:SetPoint("TOPRIGHT", -4, -4)
	frame.CloseButton = closeBtn

	listPanel = P.CreatePanel(frame, "")
	listPanel:SetPoint("TOPLEFT", 12, -36)
	listPanel:SetPoint("BOTTOMRIGHT", -12, 12)
	P.CreateScrollList(listPanel, FormatQuest, nil, {
		tooltip = QuestTooltip,
		onClick = function(item)
			OpenInQuestLog(item)
		end,
	})

	P.ui.teamQuestsFrame = frame
	P.ui.teamQuestsPanel = listPanel

	P.SkinFrame(frame)
	P.SkinPanel(listPanel)
end

-- Remplit la liste, si la fenêtre est ouverte (appelé par P.RefreshUI et à chaque journal
-- de quêtes reçu ou modifié).
function P.RefreshTeamQuests()
	if not frame or not frame:IsShown() then
		return
	end
	if P.IsSoloMode and P.IsSoloMode() then
		frame:Hide() -- pas d'équipe en mode solo de Polypode (0.54.0)
		return
	end
	local items, header, emptyText = BuildItems()
	listPanel.header:SetText(header)
	listPanel.emptyText:SetText(emptyText)
	P.SetListData(listPanel, items)
end

-- Ouvre / ferme la fenêtre (bouton « Quêtes », /poly quetes).
function P.ToggleTeamQuests()
	if P.IsSoloMode and P.IsSoloMode() then
		UIErrorsFrame:AddMessage("Quêtes de l'équipe : indisponible en mode solo.", 1, 0.1, 0.1)
		return
	end
	if not frame then
		Build()
	end
	if frame:IsShown() then
		frame:Hide()
	else
		frame:Show()
		P.RefreshTeamQuests()
	end
end

-- INTÉGRATION À POLYPODE -----------------------------------------------------------------

if P.AddTitleButton then
	P.AddTitleButton({
		text = "Quêtes",
		width = 60,
		hideInSolo = true, -- sans objet en mode solo (Polypode 0.54.0)
		onClick = function()
			P.ToggleTeamQuests()
		end,
		tooltip = {
			"Quêtes de l'équipe",
			"Liste les quêtes du leader de l'équipe sélectionnée et, pour chacune, les membres qui ne "
				.. "l'ont pas.",
		},
		onCreate = function(button)
			P.ui.questsButton = button
		end,
	})
end

if P.RegisterSlashCommand then
	P.RegisterSlashCommand("quetes", P.ToggleTeamQuests,
		"quêtes du leader manquantes chez les membres de l'équipe")
	P.RegisterSlashCommand("quêtes", P.ToggleTeamQuests) -- alias, absent de l'aide
end
