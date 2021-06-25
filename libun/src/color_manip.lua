------------
-- Color manipulation, calculations and conversions
-- @module color_manip
-- @license ICS 
-- @copyright 2019–2020 Thiadmer Riemersma, CompuPhase
-- @copyright 2020 Quentin Rossetti <code@bleu.gdn>
local color_manip = {}

--- Convert a RGB color in decimal reprensentation into it's 3 values (red, 
-- green and blue)
-- @tparam number c_dec RGB color as a decimal reprensentation.
-- @return number Red value [0, 255]
-- @return number Green value [0, 255]
-- @return number Blue value [0, 255]
-- @usage
-- dec_to_rgb(0xb3310)
-- --> 11      51      16
function color_manip.dec_to_rgb(c_dec)
  local r = math.floor(c_dec/256^2)
  local g = math.floor(c_dec/256)%256
  local b = c_dec % 256
  return r, g, b
end

--- Calculate the distance between two colors in RGB space using the low-cost 
-- approximation without gamma correction. Algorithm based on [CompuPhase article](https://www.compuphase.com/cmetric.htm)
-- @tparam number c1_dec Color 1 as a decimal reprensentation.
-- @tparam number c2_dec Color 2 as a decimal reprensentation.
-- @return number Distance between color A and B. The max distance is `442.40365741453`
-- @usage
-- distance(0xb3310, 0x174bff)
-- --> 412.24779221665
function color_manip.distance(c1_dec, c2_dec)
  local r1, g1, b1 = color_manip.dec_to_rgb(c1_dec)
  local r2, g2, b2 = color_manip.dec_to_rgb(c2_dec)
  local r_mean = (r1+r2)/2
  local dR = r2-r1
  local dG = g2-g1
  local dB = b2-b1
  return math.sqrt((2+r_mean/256)*dR^2+4*dG^2+(2+(255-r_mean)/256)*dB^2)
end

--- Convert a RGB color in decimal reprensentation into it's clostest ANSI code
-- Colors based on [xterm](Whttps://en.wikipedia.org/wiki/ANSI_escape_code#3/4_bit).
-- Algorithm based on [CompuPhase article](https://www.compuphase.com/cmetric.htm).
-- @tparam number c_dec RGB color as a decimal reprensentation.
-- @return number Clostest ANSI color code.
-- @usage
-- local ansi_foreground = "\27["..tostring(dec_to_ansi(0x174bff)).."m"
-- local ansi_background = "\27["..tostring(dec_to_ansi(0x174bff)+10).."m"
-- print("\27[0m") -- reset
function color_manip.dec_to_ansi(c_dec)
  local ansi_dec = {0x0, 0xcd0000, 0xcd00, 0xcdcd00, 0xee, 0xcd00cd, 0xcdcd, 0xe5e5e5, 0x7f7f7f, 0xff0000, 0xff00, 0xffff00, 0x5c5cff, 0xff00ff, 0xffff, 0xffffff}
  local ansi_codes = {30, 31, 32, 33, 34, 35, 36, 37, 90, 91, 92, 93, 94, 95, 96, 97}
  local clostest_code = ansi_codes[1]
  local distance_min = 1000
  for k, dec in ipairs(ansi_dec) do
    local distance = color_manip.distance(c_dec, dec)
    if distance < distance_min then
      distance_min = distance
      clostest_code = ansi_codes[k]
    end
  end
  return clostest_code
end

return color_manip