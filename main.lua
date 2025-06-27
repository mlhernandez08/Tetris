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
      if canMove(pieceX - 1, pieceY, currentPiece) then
        pieceX = pieceX - 1
      end
    elseif key == "right" then
      if canMove(pieceX + 1, pieceY, currentPiece) then
        pieceX = pieceX + 1
      end
    elseif key == "down" then
      if canMove(pieceX, pieceY + 1, currentPiece) then
        pieceY = pieceY + 1
      else
        lockPiece()
      end
    elseif key == "up" then
      local rotated = rotate(currentPiece)
      if canMove(pieceX, pieceY, rotated) then
        currentPiece = rotated
      end
    end
  end

  function rotate(shape)
    local newShape = {}
    for y = 0, 3 do
      for x = 0, 3 do
        newShape[y * 4 + x + 1] = shape[(3 - x) * 4 + y + 1]
      end
    end
    return newShape
  end

  function lockPiece()
    for i = 0, 15 do
      if currentPiece[i + 1] == 1 then
        local x = pieceX + (i % 4)
        local y = pieceY + math.floor(i / 4)
        if y >= 0 then
          field[y + 1][x + 1] = 1
        end
      end
    end
  
    -- Spawn a new piece
    spawnPiece()
  end

  function canMove(newX, newY, shape)
    for i = 0, 15 do
      if shape[i + 1] == 1 then
        local x = newX + (i % 4)
        local y = newY + math.floor(i / 4)
  
        -- Check if it's outside the field boundaries
        if x < 0 or x >= fieldWidth or y >= fieldHeight then
          return false
        end
  
        -- Check if it's colliding with something in the field
        if y >= 0 and field[y + 1] and field[y + 1][x + 1] ~= 0 then
          return false
        end
      end
    end
    return true
  end