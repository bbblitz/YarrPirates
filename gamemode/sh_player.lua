local meta = FindMetaTable("Player") --Get the meta table of player

function meta:AddGold(num)
	local current_cash = self:GetGold()
	self:SetGold( current_cash + num )
end

function meta:SetGold(num)
	self:SetNetworkedInt( "Gold", num )
	self:SaveStats()
end

function meta:SaveGold()
	local cash = self:GetGold()
	self:SetPData("gold", cash)
end

function meta:SaveGoldTXT()
	file.Write(gmod.GetGamemode().Name .."/Gold/".. string.gsub(self:SteamID(), ":", "_") ..".txt", self:GetGoldString())
end

function meta:GetGold()
	return self:GetNetworkedInt("Gold")
end

function meta:AddNotority(num)
	local current_notority = self:GetNotority()
	self:SetNotority( current_notority + num )
end

function meta:SetNotority(num)
	self:SetNetworkedInt( "Notority", num)
	self:SaveStats()
end

function meta:SaveNotority()
	local notority = self:GetNotority()
	self:SetPData("notority", notority)
end

function meta:SaveNotorityTXT()
	file.Write(gmod.GetGamemode().Name .. "/Notority/" .. string.gsub(self:SteamID(), ":", "_") .. ".txt", self:GetGoldString())
end

function meta:GetNotority()
	return self:GetNetworkedInt("Notority")
end

function meta:SaveStats()
	self:SaveGold()
	self:SaveNotority()
	self:SaveSkill()
end

function meta:SetSkill(str)
	self:SetNetworkedString( "Skill", str)
	self:SaveStats()
end

function meta:SaveSkill()
	local skill = self:GetSkill()
	self:SetPData("skill",skill)
end

function meta:SaveSkillTXT()
	file.Write(gmod.GetGamemode().Name .. "/Skill/" .. string.gsub(self:SteamID(), ":", "_") .. ".txt", self:GetGoldString())
end

function meta:GetSkill()
	return self:GetNetworkedString("Skill")
end