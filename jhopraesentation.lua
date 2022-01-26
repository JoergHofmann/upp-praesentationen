-- Befehle um Präsentationen zu erstellen
--
-- Globale Variablen

modus = ""
slideno = 1




-- Funktionen
-- 

function Slide (content)

	if (modus == "slides") then
		return content
	else
		local s = "\\externalfigure[berami-personal-handout.pdf][frame=on, page=" .. slideno .. ", width=0.8\\textwidth]"
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
	end

	if (modus == "notes") then
		return content
	end
end


-- **}
