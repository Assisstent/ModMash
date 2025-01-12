﻿--[[
	local profilers = {}

	Profiler = {}
	Profiler.__index = Profiler

	function Profiler:create(name)
		local p = {}
		setmetatable(p,Profiler)
		p.profiler = nil
		p.name = name
		p.ticks = 0 
		p.do_dump = false
		return p
		end

	function Profiler:update(tick)   
		self.ticks = self.ticks + 1
		if self.profile == nil then
			self.profiler = game.create_profiler()
		else
			self.profiler.restart()
		end
		if type(tick) == "function" then tick() end
		self.profiler.stop()
		if self.do_dump == true  and self.ticks >= 100 then
			self.profiler.divide(self.ticks)
			log{"recipe-name.concatenationstring","PROFILER: "..self.name.."=",self.profiler}
			self.do_dump = false
			self.profiler.reset()
			self.profiler.stop()
			self.ticks = 0
		end
		end

	function Profiler:dump()
		self.do_dump = true
		end

	local local_dump_profilers = function(event)
		for k, v in pairs(profilers) do
			v:dump()
		end
		end

	local local_get_profiler = function(name)
		if profilers[name] then return profilers[name] end
		local p = Profiler:create(name)
		log("PROFILER CREATED: "..p.name)
		profilers[name] = p
		return p
	end

	modmash.util.get_profiler = local_get_profiler

	script.on_event("profiler-dump",local_dump_profilers)
]]
local profilers = {}

local local_profiler_create = function(name)
	local p = {}
	p.profiler = nil
	p.name = name
	p.ticks = 0 
	p.do_dump = false
	p.dump = function() p.do_dump = true end
	p.update = function(tick)
		p.ticks = p.ticks + 1
		if p.profile == nil then
			p.profiler = game.create_profiler()
		else
			p.profiler.restart()
		end
		if type(tick) == "function" then tick() end
		p.profiler.stop()
		if p.do_dump == true  and p.ticks >= 1 then
			p.profiler.divide(p.ticks)
			log{"recipe-name.concatenationstring","PROFILER: "..p.name.."=",p.profiler}
			p.do_dump = false
			p.profiler.reset()
			p.profiler.stop()
			p.ticks = 0
		end
		end
	return p
	end

local local_dump_profilers = function(event)
	for k, v in pairs(profilers) do
		v.dump()
	end
	end

local local_get_profiler = function(name)
	if profilers[name] then return profilers[name] end
	local p = local_profiler_create(name)
	log("PROFILER CREATED: "..p.name)
	profilers[name] = p
	return p
end

modmash.util.get_profiler = local_get_profiler

script.on_event("profiler-dump",local_dump_profilers)