-- Befehle um Präsentationen zu erstellen
--
-- Globale Variablen

modus = ""
projectname = "upp_praesentation"
ratio = "1680x1050"

slideno = 1 




-- Funktionen
-- 

function Slide (content)

	if (modus == "slides") then
		return content
	else
		local s = "\\externalfigure[handout" .. "_" .. slideno+1 .. "_" .. ratio .. ".png][frame=on, width=0.8\\textwidth]"
		slideno = slideno + 1
		return s
	end

end



function Handout (content)

	if (modus == "handout") then
		return content
	else
		return ""
	end
end



function Note (content)

	local s = [[<aside class="notes">]]

	if (modus == "slides") then
		s = s .. content .. "</aside>"
		return s
	else
		return ""
	end

	if (modus == "notes") then
		return content
	end
end


-- **}
