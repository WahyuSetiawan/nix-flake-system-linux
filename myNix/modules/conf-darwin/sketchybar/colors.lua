return {
	Rosewater = 0xff5e0dc, -- #f5e0dc	rgb(245, 224, 220)	hsl(10, 56%, 91%)
	Flamingo = 0xfff2cdcd, --	#f2cdcd	rgb(242, 205, 205)	hsl(0, 59%, 88%)
	Pink = 0xfff5c2e7, --	#f5c2e7	rgb(245, 194, 231)	hsl(316, 72%, 86%)
	Mauve = 0xffcba6f7, --	#cba6f7	rgb(203, 166, 247)	hsl(267, 84%, 81%)
	Red = 0xff38ba8, --	#f38ba8	rgb(243, 139, 168)	hsl(343, 81%, 75%)
	Maroon = 0xffeba0ac, --	#eba0ac	rgb(235, 160, 172)	hsl(350, 65%, 77%)
	Peach = 0xfffab387, --	#fab387	rgb(250, 179, 135)	hsl(23, 92%, 75%)
	Yellow = 0xfff9e2af, --	#f9e2af	rgb(249, 226, 175)	hsl(41, 86%, 83%)
	Green = 0xffa6e3a1, --	#a6e3a1	rgb(166, 227, 161)	hsl(115, 54%, 76%)
	Teal = 0xff94e2d5, --	#94e2d5	rgb(148, 226, 213)	hsl(170, 57%, 73%)
	Sky = 0xff89dceb, --	#89dceb	rgb(137, 220, 235)	hsl(189, 71%, 73%)
	Sapphire = 0xff74c7ec, --	#74c7ec	rgb(116, 199, 236)	hsl(199, 76%, 69%)
	Blue = 0xff89b4fa, --	#89b4fa	rgb(137, 180, 250)	hsl(217, 92%, 76%)
	Lavender = 0xffb4befe, --	#b4befe	rgb(180, 190, 254)	hsl(232, 97%, 85%)
	Text = 0xffcdd6f4, --	#cdd6f4	rgb(205, 214, 244)	hsl(226, 64%, 88%)
	Subtext1 = 0xffbac2de, --	#bac2de	rgb(186, 194, 222)	hsl(227, 35%, 80%)
	Subtext0 = 0xffa6adc8, --	#a6adc8	rgb(166, 173, 200)	hsl(228, 24%, 72%)
	Overlay2 = 0xff9399b2, --	#9399b2	rgb(147, 153, 178)	hsl(228, 17%, 64%)
	Overlay1 = 0xff7f849c, --	#7f849c	rgb(127, 132, 156)	hsl(230, 13%, 55%)
	Overlay0 = 0xff6c7086, --	#6c7086	rgb(108, 112, 134)	hsl(231, 11%, 47%)
	Surface2 = 0xff585b70, --	#585b70	rgb(88, 91, 112)	hsl(233, 12%, 39%)
	Surface1 = 0xff45475a, --	#45475a	rgb(69, 71, 90)	hsl(234, 13%, 31%)
	Surface0 = 0xff313244, --	#313244	rgb(49, 50, 68)	hsl(237, 16%, 23%)
	Base = 0xff1e1e2e, --	#1e1e2e	rgb(30, 30, 46)	hsl(240, 21%, 15%)
	Mantle = 0xff181825, --	#181825	rgb(24, 24, 37)	hsl(240, 21%, 12%)
	Crust = 0xff11111b, --	#11111b

	black = 0xff181819,
	white = 0xffe2e2e3,
	red = 0xfffc5d7c,
	green = 0xff9ed072,
	blue = 0xff76cce0,
	yellow = 0xffe7c664,
	orange = 0xfff39660,
	magenta = 0xffb39df3,
	grey = 0xff7f8490,
	transparent = 0x00000000,

	bar = {
		bg = 0xf02c2e34,
		border = 0xff2c2e34,
	},
	popup = {
		bg = 0xc02c2e34,
		border = 0xff7f8490,
	},
	bg1 = 0xff363944,
	bg2 = 0xff414550,

	with_alpha = function(color, alpha)
		if alpha > 1.0 or alpha < 0.0 then
			return color
		end
		return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
	end,
}
