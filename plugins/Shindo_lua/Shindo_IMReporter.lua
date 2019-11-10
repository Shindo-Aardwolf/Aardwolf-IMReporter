-- Colour Stuff
local ansi = "\27["
local dred = "\27[0;31m"
local dgreen = "\27[0;32m"
local dyellow = "\27[0;33m"
local dblue = "\27[0;34m"
local dmagenta = "\27[0;35m"
local dcyan = "\27[0;36m"
local dwhite = "\27[0;37m"
local bred = "\27[31;1m"
local bgreen = "\27[32;1m"
local byellow = "\27[33;1m"
local bblue = "\27[34;1m"
local bmagenta = "\27[35;1m"
local bcyan = "\27[36;1m"
local bwhite = "\27[37;1m"

-- make an array of colours using "bred" etc as key and the ansi codes as the data
local colourArray = {
	["dred"] = "\27[0;31m",
	["dgreen"] = "\27[0;32m",
	["dyellow"] = "\27[0;33m",
	["dblue"] = "\27[0;34m",
	["dmagenta"] = "\27[0;35m",
	["dcyan"] = "\27[0;36m",
	["dwhite"] = "\27[0;37m",
	["bred"] = "\27[31;1m",
	["bgreen"] = "\27[32;1m",
	["byellow"] = "\27[33;1m",
	["bblue"] = "\27[34;1m",
	["bmagenta"] = "\27[35;1m",
	["bcyan"] = "\27[36;1m",
	["bwhite"] = "\27[37;1m",
}

-- Local Variables
local version = "0.0.3"
local InstinctSkills = {}
local MasteryDamtypes = {}
local AvailableGold = "0"
local AvailableQP = "0"
local AvailableTrains = "0"
local ReportingChannel = ""

--[[Processing INSTINCT]]
function processInstinctDataLine(name, line, wildcards)
	tempdata = {}
	skillname = wildcards["1"]
	skillamount = wildcards["3"]
	if skillamount ~= "0" then
		tempdata[skillname] = skillamount
		table.insert(InstinctSkills, tempdata)
	end
end

function processInstinctTrainsLine(name, line, wildcards)
	AvailableTrains = wildcards["1"]
end

function processInstinctGoldLine(name, line, wildcards)
	AvailableGold = wildcards["1"]
	EnableTriggerGroup("instinct_capture", false)
	showInstincts()
end

function showInstincts()
	local outstring = ""
	for number, SubTable in pairs(InstinctSkills) do
		for SkillName, SkillAmount in pairs(SubTable) do
			if outstring == "" then
				outstring = string.format("[%s, %s]", SkillName, SkillAmount)
			else
				outstring = string.format("%s, [%s, %s]", outstring, SkillName, SkillAmount)
			end
		end
	end
	--Note(outstring .. "\n")
	--Note(string.format("%s\n%s trains and %s gold available for instinct.\n",
	--outstring, AvailableTrains, AvailableGold))
	SendToServer(string.format("%s %s %s trains and %s gold available for instinct.",
	ReportingChannel, outstring, AvailableTrains, AvailableGold))
end

function startInstinctReport()
	startInstinctReportC("say")
end

function startInstinctReportC(channel)
	InstinctSkills = {}
	ReportingChannel = channel
	EnableTriggerGroup("instinct_capture", true)
	SendToServer("instinct")
end

--[[ Processing Mastery ]]
function processMasteryDataLine(name, line, wildcards)
	tempdata = {}
	masteryType = wildcards["1"]
	masteryAmount  = wildcards["2"]
	if masteryAmount ~= "0" then
		tempdata[masteryType] = masteryAmount
		table.insert(MasteryDamtypes, tempdata)
	end
end

function processMasteryQPLine(name, line, wildcards)
	AvailableQP = wildcards["1"]
end

function processMasteryGoldLine(name, line, wildcards)
	AvailableGold = wildcards["1"]
	EnableTriggerGroup("mastery_capture", false)
	showMastery()
end

function showMastery()
	local outstring = ""
	for number, SubTable in pairs(MasteryDamtypes) do
		for MasteryType, MasteryAmount in pairs(SubTable) do
			if outstring == "" then
				outstring = string.format("[%s, %s]", MasteryType, MasteryAmount)
			else
				outstring = string.format("%s, [%s, %s]", outstring, MasteryType, MasteryAmount)
			end
		end
	end
	SendToServer(string.format("%s %s %s qp and %s gold available for instinct.",
	ReportingChannel, outstring, AvailableQP, AvailableGold))
end

function startMasteryReport()
	startMasteryReportC("say")
end

function startMasteryReportC(channel)
	MasteryDamtypes = {}
	ReportingChannel = channel
	EnableTriggerGroup("mastery_capture", true)
	SendToServer("mastery")
end

function OnBackgroundStartup()
	Note(string.format("%sShindo's Instinct and Mastery Reporting Plugin version: %s%s%s\n" ,
	dgreen, bgreen, version, dwhite))
	EnableTriggerGroup("instinct_capture", false)
	EnableTriggerGroup("mastery_capture", false)
end

Note(string.format("%sShindo's IMReporting Plugin installed%s\n", dgreen, dwhite))
