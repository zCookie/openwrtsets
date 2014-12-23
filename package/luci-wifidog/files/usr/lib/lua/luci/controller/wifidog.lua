module("luci.controller.wifidog", package, seeall)

function index()
	entry(
		{"admin", "network", "wifidog"},  
		cbi("wifidog"),
		translate("Portal"),
		100
	)
end

