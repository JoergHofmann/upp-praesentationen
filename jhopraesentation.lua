-- Befehle um Präsentationen zu erstellen
--
-- Globale Variablen

modus = ""
projectname = ""
ratio = "1680x1050"

slideno = 1 




-- Funktionen
-- 

function Slide (content)

	if (modus == "slides") then
		return content
	else
		local s = "\\externalfigure[" .. projectname .. "-handout" .. "_" .. slideno+1 .. "_" .. ratio .. ".png][frame=on, width=0.8\\textwidth]"
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

	if (zielformat = "html5") then
		local s1 = [[<aside class="notes">]]
		local s2 = "</aside>"
	else
		local s1 = "\\note{"
		local s2 = "}"
	end

	if (modus == "slides") then
		s = s1 .. content .. s2
		return s
	elseif (modus = "notes") then
		return content
	else
		return ""
	end
end


-- **}
