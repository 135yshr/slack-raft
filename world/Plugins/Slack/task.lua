TaskContainer = {}

function TaskContainer.new(name,priority,cost)
	local t = {
		x=TASK_START_X,
		y=GROUND_LEVEL,
		z=TASK_START_Z+priority*7,
		name=name,
		priority=priority,
		cost=cost
	}
	return setmetatable(t, {__index = TaskContainer})
end

function TaskContainer.display(self)
	for px = self.x-3, self.x+3 do
		for pz = self.z-3, self.z+3 do
			setBlock(UpdateQueue, px, self.y, pz, E_BLOCK_STONE, E_META_STONE_STONE)
		end
	end

	for px = self.x-1, self.x+1 do
		for pz = self.z-1, self.z+1 do
			setBlock(UpdateQueue, px, self.y+1, pz, E_BLOCK_STONE, E_META_STONE_STONE)
			setBlock(UpdateQueue, px, self.y+2+self.cost, pz, E_BLOCK_STONE, E_META_STONE_STONE)
		end
	end

	for py = 2, self.cost+1 do
		for px = self.x-1, self.x+1 do
			for pz = self.z-1, self.z+1 do
				setBlock(UpdateQueue, px, self.y+py, pz, E_BLOCK_STONE, E_META_STONE_STONE)
			end
		end
		setBlock(UpdateQueue, self.x, self.y+py, self.z, E_BLOCK_TNT, E_META_STONE_STONE)
	end
	setBlock(UpdateQueue, self.x+1, self.y+self.cost+1, self.z-2, E_BLOCK_WALLSIGN, E_META_CHEST_FACING_ZM)
	updateSign(UpdateQueue, self.x+1, self.y+self.cost+1, self.z-2, "", self.name, "", "", 2)
	setBlock(UpdateQueue, self.x, self.y+self.cost+1, self.z-2, E_BLOCK_STONE_BUTTON, E_BLOCK_BUTTON_ZM)
end
