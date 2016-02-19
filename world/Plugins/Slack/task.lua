TaskContainer = {}

function TaskContainer.new(name,priority,cost)
	local t = {
		x=TASK_START_X,
		y=GROUND_LEVEL,
		z=TASK_START_Z+(priority-1)*7,
		offset=0,
		name=name,
		priority=priority,
		cost=cost
	}
	return setmetatable(t, {__index = TaskContainer})
end

function TaskContainer.display(self)
	base_x=self.x+self.offset*7
	base_z=self.z+(self.priority-1)*7

	for px = base_x-3, base_x+3 do
		for pz = base_z-3, base_z+3 do
			setBlock(UpdateQueue, px, self.y, pz, E_BLOCK_STONE, E_META_STONE_STONE)
		end
	end

	for px = base_x-1, base_x+1 do
		for pz = base_z-1, base_z+1 do
			setBlock(UpdateQueue, px, self.y+1, pz, E_BLOCK_STONE, E_META_STONE_STONE)
			setBlock(UpdateQueue, px, self.y+2+self.cost, pz, E_BLOCK_STONE, E_META_STONE_STONE)
		end
	end

	for py = 2, self.cost+1 do
		for px = base_x-1, base_x+1 do
			for pz = base_z-1, base_z+1 do
				setBlock(UpdateQueue, px, self.y+py, pz, E_BLOCK_STONE, E_META_STONE_STONE)
			end
		end
		setBlock(UpdateQueue, base_x, self.y+py, base_z, E_BLOCK_TNT, E_META_STONE_STONE)
	end
	setBlock(UpdateQueue, base_x+1, self.y+self.cost+1, base_z-2, E_BLOCK_WALLSIGN, E_META_CHEST_FACING_ZM)
	updateSign(UpdateQueue, base_x+1, self.y+self.cost+1, base_z-2, "", self.name, "", "", 2)
	setBlock(UpdateQueue, base_x, self.y+self.cost+1, base_z-2, E_BLOCK_STONE_BUTTON, E_BLOCK_BUTTON_ZM)
end
