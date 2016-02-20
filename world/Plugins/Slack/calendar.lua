CALENDAR_GOOD = 0
CALENDAR_FAIR = 1
CALENDAR_BAD  = 2

Calendar = {}

function Calendar.new(month)
	local c = {
			x=0,
			y=0,
			z=0,
			month=month,
			users={},
		}
	return setmetatable(c, {__index = Calendar})
end

function Calendar.display(self)

	uc=self.userCount()
	for px = self.x-5, self.x+38 do
		for pz = self.z-5, self.z+5 do
			setBlock(UpdateQueue, px, self.y, pz, E_BLOCK_STONE, E_META_STONE_STONE)
		end
	end 

	-- y = 1
	setBlock(UpdateQueue, self.x-1, self.y+1, self.z, E_BLOCK_SIGN_POST, E_META_CHEST_FACING_ZP)
	updateSign(UpdateQueue, self.x-1, self.y+1, self.z, "", "current", "month", "", 2)
	setBlock(UpdateQueue, self.x, self.y+1, self.z, E_BLOCK_STONE, E_META_STONE_STONE)
	setBlock(UpdateQueue, self.x+33, self.y+1, self.z, E_BLOCK_STONE, E_META_STONE_STONE)

	-- y = 2 and 7
	for px=self.x, self.x+33 do
		setBlock(UpdateQueue, px, self.y+2, self.z, E_BLOCK_STONE, E_META_STONE_STONE)
		setBlock(UpdateQueue, px, self.y+uc+3, self.z, E_BLOCK_STONE, E_META_STONE_STONE)
	end
	no=0
	for py = self.y+3, self.y+uc+2 do
		setBlock(UpdateQueue, self.x, py, self.z, E_BLOCK_STONE, E_META_STONE_STONE)
		setBlock(UpdateQueue, self.x+1, py, self.z, E_BLOCK_WOOL, E_META_WOOL_GREEN)
		setBlock(UpdateQueue, self.x+1, py, self.z+1, E_BLOCK_WALLSIGN, E_META_CHEST_FACING_ZP)
		updateSign(UpdateQueue, self.x+1, py, self.z+1, "", Calendar:userName(self.users, no), "", "", 2)
		for px=self.x+2, self.x+32 do
			setBlock(UpdateQueue, px, py, self.z, E_BLOCK_WOOL, E_META_WOOL_LIGHTGRAY)
		end
		setBlock(UpdateQueue, self.x+33 , py, self.z, E_BLOCK_STONE, E_META_STONE_STONE)
		no=no+1
	end
end

function Calendar.addUser(self, name)
	if self.users[name] == nil then
		self.users[name] = self.userCount()
	end
end

function Calendar.userName(self, users, no)
	for k, v in pairs(users) do
		if v==no then
			return k
		end
	end
	return ""
end

function Calendar.updateFeel(self,name,day,feel)
	local no = self.users[name]
	if no == nil then
		return
	end

	local blockColor = E_META_WOOL_LIGHTGRAY
	if feel == CALENDAR_GOOD then
		blockColor = E_META_WOOL_PINK
	elseif feel == CALENDAR_FAIR then
		blockColor = E_META_WOOL_ORANGE
	elseif feel == CALENDAR_BAD then
		blockColor = E_META_WOOL_LIGHTBLUE
	end
	setBlock(UpdateQueue, self.x+day+1, self.y+no+3, self.z, E_BLOCK_WOOL, blockColor)
end

function Calendar.userCount(self)
	if self == nil then return 0 end

	local count = 0
	for _ in pairs(self.users) do count = count + 1 end
	return count
end