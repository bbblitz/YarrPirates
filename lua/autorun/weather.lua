windstrongness = 10 //How rapidly wind changes; measured in MPH

windforce = Vector(0,0,0)

function WeatherMain()
timer.Create("weatherswitcher",5,0,WindSwitch, nil)
end
hook.Add("Initialize", "WeatherMainFunc", WeatherMain)

/*local Wind = function()
windforce = windforce + Vector(windirx,windiry,math.random(-1,1))

local sails = ents.FindByClass("gmod_sail")

for k,v in pairs (sails) do
	v:GetTable():WindForce(windforce)
end


end*/

function WindSwitch()
/*local randnumx = math.random(1,5)
local randnumy = math.random(1,5)

if randnumx == 1 or randnumx == 3 or randnumx == 5 then
windirx = math.random(1,windstrongness)
else
windirx = math.random(-windstrongness,-1)
end

if randnumy == 1 or randnumy == 3 or randnumy == 5 then
windiry = math.random(1,windstrongness)
else
windiry = math.random(-windstrongness,-1)
end
*/

windirx = math.random(-(windstrongness), windstrongness)
windiry = math.random(-(windstrongness), windstrongness)

windforce = Vector(windirx,windiry,0) //Fixed :D

local sails = ents.FindByClass("gmod_sail")

for k,v in pairs (sails) do
	v:GetTable():WindForce(windirx,windiry)
	local enttable = v:GetTable()
	local ttable = { windirx = windirx, windiry = windiry }
			
	table.Merge( enttable, ttable )
end


end


function WindSpeed(ply, rofl, args)
local windspeed = math.Round((math.abs(windforce.x) + math.abs(windforce.y)))
local northsouth = "rofl"
local eastwest = "waffles"

if windforce.x > 0 then northsouth = "south"
else
northsouth = "north"
end

if windforce.y > 0 then eastwest = "east"
else
eastwest = "west"
end


ply:PrintMessage(3, "The current windspeed is "..windspeed.." MPH, blowing from the "..northsouth.."-"..eastwest..".")

end

concommand.Add("windspeed",WindSpeed)
