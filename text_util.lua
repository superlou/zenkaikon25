function write_centered(font, x_pos, y, text, size, r, g, b, a)
  local width = font:width(text, size)
  local x = x_pos - width / 2
  font:write(x, y, text, size, r, g, b, a)
  return width
end

function split_newlines(str)
  local t = {}
  local function helper(line)
    table.insert(t, line)
    return ""
  end
  helper((str:gsub("(.-)\r?\n", helper)))
  return t
end

function wrap_text(text, font, size, width)
  local lines = split_newlines(text)

  local wrapped_lines = {}

  for i, line in ipairs(lines) do
    local current_line = ''

    for word in line:gmatch("%S+") do
      if current_line == '' then
          current_line = word
      else
        local check_line = current_line .. ' ' .. word
        local check_width = font:width(check_line, size)

        if check_width < width then
          current_line = check_line
        else
          table.insert(wrapped_lines, current_line)
          current_line = word
        end
      end
    end

    if line ~= '' then
      table.insert(wrapped_lines, current_line)
    end
  end

  return wrapped_lines
end

function size_text_to_width(text, font, width, max_size)
  local text_width = font:width(text, max_size)

  local ratio = width / text_width
  local new_size = math.min(max_size, max_size * ratio)
  local y_offset = (max_size - new_size) / 2

  return new_size, y_offset
end

function draw_text_in_window(text, x, y, w, h, max_size, font, r, g, b, a, pad)
  local font_size, y_offset = size_text_to_width(text, font, w - 2 * pad, max_size)
  font:write(x + pad, y + y_offset, text, font_size, r, g, b, a)
end
