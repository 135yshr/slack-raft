
function NewCalendar()
	c = {
			x=0, 
			z=0, 
			month=0,
			init=Calendar.init,
			setInfos=Calendar.setInfos,
			destroy=Calendar.destroy,
			display=Calendar.display,
			addGround=Calendar.addGround
		}
	return c
end

Calendar = {x=0, z=0, month=0}

function Calendar:init(x,z,month)
	self.x = x
	self.z = z
end

function Calendar:display()

	for px = self.x, self.x+33
	do
		setBlock(UpdateQueue,px,GROUND_LEVEL+2,self.z,E_BLOCK_STONE,E_META_STONE_STONE)
	end

	for px = self.x, self.x+33
	do
		setBlock(UpdateQueue,px,GROUND_LEVEL+7,self.z,E_BLOCK_STONE,E_META_STONE_STONE)
	end
end
