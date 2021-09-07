
scenes.game = {}

function initialize()
	game.bubbles = {}
	for x = 0,4 do
		for y = 0,5 do
			table.insert(game.bubbles, {
				x = 32 + 64 * x,
				y = 64 + 64 * y,
				state = love.math.random(1,4)
			})
		end
	end
end

function breakBubble(key)
	local bubble = game.bubbles[key]

	if bubble.state < 4 then
		game.bubbles[key].state = bubble.state + 1
	else
		game.bubbles[key] = nil

		local dirs = { 'up', 'left', 'down', 'right' }

		for _,dir in pairs(dirs) do
			table.insert(game.particles, {
				x = bubble.x,
				y = bubble.y,
				dir = dir
			})
		end
	end
end

function scenes.game.init()
	initialize()
end

function scenes.game.update()
	if (love.keyboard.isDown('n') and not oldndown) or CheckMouseCollision(320, 0, 32, 32) then
		initialize()
	end
	oldndown = love.keyboard.isDown('n')

	for key,bubble in pairs(game.bubbles) do
		if CheckMouseCollision(bubble.x, bubble.y, 32, 32) then
			breakBubble(key)

			break
		end
	end

	for key,particle in pairs(game.particles) do
		local speed = 3
		local deltaX, deltaY

		if particle.dir == 'up' then
			deltaX = 0
			deltaY = -speed
		elseif particle.dir == 'left' then
			deltaX = -speed
			deltaY = 0
		elseif particle.dir == 'down' then
			deltaX = 0
			deltaY = speed
		elseif particle.dir == 'right' then
			deltaX = speed
			deltaY = 0
		end

		game.particles[key].x = game.particles[key].x + deltaX
		game.particles[key].y = game.particles[key].y + deltaY

		if not CheckCollision(particle.x, particle.y, 32, 32, 0, 0, game.resolution.x, game.resolution.y) then
			game.particles[key] = nil
		end
	end

	for particleKey,particle in pairs(game.particles) do
		for bubbleKey,bubble in pairs(game.bubbles) do
			if CheckCollision(particle.x +7, particle.y +7, 18, 18, bubble.x, bubble.y, 32, 32) then
				breakBubble(bubbleKey)
				game.particles[particleKey] = nil
			end
		end
	end
end

function scenes.game.draw()
	for _,bubble in pairs(game.bubbles) do
		love.graphics.draw(assets.bubble[bubble.state], bubble.x, bubble.y)
	end

	for _,particle in pairs(game.particles) do
		love.graphics.draw(assets.particle, particle.x, particle.y)
	end

	love.graphics.draw(assets.refresh, 320, 0)
end
