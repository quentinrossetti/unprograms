local dec_to_ansi = require("utils/colors_approx").dec_to_ansi

return {
  setBackground = function (c_dec)
    io.write("\27["..tostring(dec_to_ansi(c_dec)+10).."m")
  end,
  setForeground = function (c_dec)
    io.write("\27["..tostring(dec_to_ansi(c_dec)).."m")
  end,
}
