local M = {}

-- Document state
local document = {
    content = {},
    fonts = {},
    current_font = "Helvetica",
    current_size = 12
}

-- TeX-like commands
function M.cmd(name, handler)
    M[name] = function(...)
        table.insert(document.content, {cmd = name, args = {...}})
        if handler then handler(...) end
    end
end

-- Basic commands
M.cmd("text", function(text)
    -- Default text handler
end)

M.cmd("font", function(name, size)
    document.current_font = name or document.current_font
    document.current_size = size or document.current_size
end)

M.cmd("paragraph", function()
    -- Paragraph break
end)

-- PDF generation bridge using os.execute
local function generate_pdf(filename)
    -- Create temporary command file
    local cmd_file = os.tmpname()
    local f = io.open(cmd_file, "w")
    
    -- Serialize commands
    f:write("FONT Helvetica 12\n")  -- Default font
    
    for _, item in ipairs(document.content) do
        if item.cmd == "text" then
            f:write("TEXT " .. table.concat(item.args, " ") .. "\n")
        elseif item.cmd == "font" then
            local name = item.args[1] or "Helvetica"
            local size = item.args[2] or 12
            f:write("FONT " .. name .. " " .. size .. "\n")
        elseif item.cmd == "paragraph" then
            f:write("PARAGRAPH\n")
        end
    end
    
    f:close()
    
    -- Call C executable
    os.execute("./texlike_pdf " .. filename .. " < " .. cmd_file)
    
    -- Clean up
    os.remove(cmd_file)
end

M.generate = generate_pdf

return M