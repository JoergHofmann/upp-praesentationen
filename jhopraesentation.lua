
-- Befehle um Präsentationen zu erstellen
--
-- Globale Variablen

modus = ""
slideno = 1


function Slide (content)

	if (modus == "slides") then
		return content
	else
		local s = "\externalfigure[berami-personal-handout.pdf][frame=on, page=" .. slideno .. ", width=0.8\textwidth]"
		slideno = slideno + 1
		return s
	end

end



function Handout (content)

	if (modus == "handout") then
		return upp(content)
	end
end



function Note (content)

	if (modus == "note") then
		return upp(content)
	end
end

-- **}
