local colors = {}

for line in io.lines(os.getenv("HOME") .. "/.config/colors/colors.conf") do
    local name, value = line:match("^%$(%w+)%s*=%s*(%S+)")
    if name then colors[name] = value end
end

return colors
