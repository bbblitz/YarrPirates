
require("navmeshigation")

navmesh = navmesh.Create(128)
navmesh.setDiagonal(true)
navmesh:SetupMaxDistance(Vector(0,0,0), 99999)
navmesh:ClearGroundSeeds()
navmesh:ClearAirSeeds()
HitWorld, Pos, Normal = TraceDown(Vector(0, 0, 0))
navmesh:AddGroundSeed(Pos, Normal)
navmesh:AddGroundSeed(Pos, NormalUp)
navmesh:AddGroundSeed(Pos, NormalUp)
local Alpha = 200
local ColNORMAL = Color(255, 255, 255, Alpha) -- White
local ColNORTH = Color(255, 255, 0, Alpha) -- Pink?
local ColSOUTH = Color(255, 0, 0, Alpha) -- RED
local ColEAST = Color(0, 255, 0, Alpha) -- GREEN
local ColWEST = Color(0, 0, 255, Alpha) -- BLUE
local ColOTHER = Color(0, 255, 255, Alpha) -- Black
local ColDisabled = Color(50, 50, 50, Alpha)

local PathOffset = Vector(0, 0, 10)
local ColPath = Color(255, 0, 0, 255)

local function DrawNodeLines(Table, PlyPos)
	for k,v in pairs(Table) do
		local pos = v:GetPosition()
		if(PlyPos:Distance(pos) <= 512) then
			local connections = v:GetConnections()
			for k2,v2 in pairs(connections) do
				local Col = ColOTHER
				if(k2 == nav.NORTH) then
					Col = ColNORTH
				elseif(k2 == nav.SOUTH) then
					Col = ColSOUTH
				elseif(k2 == nav.EAST) then
					Col = ColEAST
				elseif(k2 == nav.WEST) then
					Col = ColWEST
				end
				
				render.DrawBeam(pos, pos + (v2:GetPosition() - pos) * 0.3, 4, 0.25, 0.75, Col)
			end
			
			local ColNorm = ColNORMAL
			if(v:IsDisabled()) then
				ColNorm = ColDisabled
			end
			
			local normal = v:GetNormal()
			if(normal != 0 and normal.y != 0 and normal.z != 0) then
				render.DrawBeam(pos, pos + (normal * 13), 4, 0.25, 0.75, ColNorm)
			end
		end
	end
end