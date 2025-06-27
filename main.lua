local fieldWidth = 10
local fieldHeight = 20
local blockSize = 30
local field = {}
local currentPiece
local pieceX, pieceY
local Pieces = require("pieces")

function love.load()
  -- Create an empty field
  for y = 1, fieldHeight do
    field[y] = {}
    for x = 1, fieldWidth do
      field[y][x] = 0
    end
  end

  -- Pick a random tetromino
  spawnPiece()
end

function spawnPiece()
  local id = love.math.random(#Pieces)
  currentPiece = Pieces[id][1]
  pieceX, pieceY = 3, 0
end

function love.draw()
  -- Draw the field
  for y = 1, fieldHeight do
    for x = 1, fieldWidth do
      if field[y][x] ~= 0 then
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", (x-1)*blockSize, (y-1)*blockSize, blockSize-1, blockSize-1)
      end
    end
  end

  -- Draw the current piece
  love.graphics.setColor(1, 0, 0)
  for i = 0, 15 do
    if currentPiece[i+1] == 1 then
      local x = i % 4
      local y = math.floor(i / 4)
      love.graphics.rectangle("fill", (pieceX + x)*blockSize, (pieceY + y)*blockSize, blockSize-1, blockSize-1)
    end
  end
end

function love.keypressed(key)
    if key == "left" then
      pieceX = pieceX - 1
    elseif key == "right" then
      pieceX = pieceX + 1
    elseif key == "down" then
      pieceY = pieceY + 1
    elseif key == "up" then
      rotatePiece()
    end
  end
  
  function rotatePiece()
    local newPiece = {}
    for y = 0, 3 do
      for x = 0, 3 do
        newPiece[y*4 + x + 1] = currentPiece[(3 - x)*4 + y + 1]
      end
    end
    currentPiece = newPiece
  end