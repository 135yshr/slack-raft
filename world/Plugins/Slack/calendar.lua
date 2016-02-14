CALENDAR_GOOD = 0
CALENDAR_FAIR = 1
CALENDAR_BAD  = 2

function NewCalendar()
	c = {
			x=0, 
			z=0, 
			month=0,
			users={},
			init=Calendar.init,
			setInfos=Calendar.setInfos,
			destroy=Calendar.destroy,
			display=Calendar.display,
			addUser=Calendar.addUser,
			updateFeel=Calendar.updateFeel
		}
	return c
end

Calendar = {x=0, z=0, month=0, users={}}

function Calendar:init(x,z,month)
	self.x = x
	self.z = z
	self.month = month
	self.users = {}
end

function Calendar:display()

	setBlock(UpdateQueue, self.x, GROUND_LEVEL+1, self.z, E_BLOCK_STONE, E_META_STONE_STONE)
	for px = self.x, self.x+33
	do
		setBlock(UpdateQueue, px, GROUND_LEVEL+2, self.z, E_BLOCK_STONE, E_META_STONE_STONE)
	end

	for py = GROUND_LEVEL+3, GROUND_LEVEL+6
	do
		setBlock(UpdateQueue, self.x,   py,self.z, E_BLOCK_STONE, E_META_STONE_STONE)
		setBlock(UpdateQueue, self.x+1, py,self.z, E_BLOCK_WOOL,  E_META_WOOL_GREEN)
		for px = self.x+2, self.x+32
		do
				setBlock(UpdateQueue, px, py, self.z, E_BLOCK_WOOL, E_META_WOOL_LIGHTGRAY)
		end
		setBlock(UpdateQueue, self.x+33, py, self.z, E_BLOCK_STONE, E_META_STONE_STONE)
	end

	for px = self.x, self.x+33
	do
		setBlock(UpdateQueue, px, GROUND_LEVEL+7, self.z, E_BLOCK_STONE, E_META_STONE_STONE)
	end
	setBlock(UpdateQueue, self.x+33, GROUND_LEVEL+1, self.z, E_BLOCK_STONE, E_META_STONE_STONE)
end

function Calendar:addUser(name)
	if self.users[name] == nil
	then
		self.users[name] = Calendar:userCount(self.users)
	end
end

function Calendar:updateFeel(name,day,feel)
	local no = self.users[name]
	if no == nil
	then
		return
	end

	local blockColor = E_META_WOOL_LIGHTGRAY
	if feel == CALENDAR_GOOD
	then
		blockColor = E_META_WOOL_PINK
	elseif feel == CALENDAR_FAIR
	then
		blockColor = E_META_WOOL_ORANGE
	elseif feel == CALENDAR_BAD
	then
		blockColor = E_META_WOOL_LIGHTBLUE
	end
	setBlock(UpdateQueue, self.x+day+1, GROUND_LEVEL+no+3, self.z, E_BLOCK_WOOL, blockColor)
end

function Calendar:userCount(users)
	local count = 0
	for _ in pairs(users) do count = count + 1 end
	return count
end