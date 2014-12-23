


m = Map("wifidog", translate("WifiDog Client"), translate("Configure WifiDog client."))

-- Client Settings
s = m:section(TypedSection, "main",  translate("Portal Client Settings"))
s.addremove = false
s.anonymous = true

s:tab("general", translate("General Settings"))
s:tab("advanced", translate("Advanced Settings"))

int_if = s:taboption("general", ListValue, "gatewayinterface", 
	translate("<abbr title=\"The Internal Interface\">GatewayInterface</abbr>"), 
	translate("If you don't know which to choose, typically selecting br-lan."))
for k, v in ipairs(luci.sys.net.devices()) do
	if v ~= "lo" then
		int_if:value(v)
	end
end

ext_if = s:taboption("general", ListValue, "externalinterface", 
	translate("<abbr title=\"The External Interface External\">ExternalInterface</abbr>"), 
	translate("If you don't know which to choose, typically selecting eth0."))
for k, v in ipairs(luci.sys.net.devices()) do
	if v ~= "lo" then
		ext_if:value(v)
	end
end

gw_id = s:taboption("general", Value, "gatewayid", 
	translate("<abbr title=\"The node ID on the auth server\">NodeID</abbr>"), 
	translate("Default value: NONE; optional<br />"..
		"This is used to give a customized login page to the clients and for monitoring/statistics purpose.<br />"..
		"If you run multiple gateways on the same machine each gateway needs to have a different gateway id.<br />"..
		"If leaves it blank, the mac address of the GatewayInterface interface will be used, without the : separators"))
gw_id.optional = true
gw_id.datatype = string
gw_id.placeholder = translate("Automatically detected from GatewayInterface")

gw_addr = s:taboption("general", Value, "gatewayaddress", 
	translate("<abbr title=\"the internal IPV4 address of the gateway\">GatewayAddress</abbr>"))
gw_addr.optional = true
gw_addr.datatype = ip4addr
gw_addr.placeholder = translate("Automatically detected from GatewayInterface")

gw_port = s:taboption("general", Value, "gatewayport", 
	translate("<abbr title=\"the Port ID for Gateway use\">GatewayPort</abbr>"), 
	translate("Default value: 2060, optional"))
gw_port.optional = true
gw_port.datatype = port
gw_port.placeholder = 2060

client_timeout = s:taboption("general", Value, "clienttimeout", translate("ClientTimeout"), 
	translate("How many minute should wait before an inactive client to be logged out"))
client_timeout.optional = true
client_timeout.datatype = uinteger
client_timeout.placeholder = 5

proxyport = s:taboption("advanced", Value, "proxyport", translate("ProxyPort"), 
	translate(
		"Default value: 0 or disabled, optional<br />"..
		"Redirect HTTP traffic of knowns & probations users to a local transparent proxy listening on this port,"))
proxyport.optional = true
proxyport.datatype = port
proxyport.placeholder = 0

html_msgfile = s:taboption("advanced", Value, "htmlmessagefile", translate("HTMLMessageFile"), 
	translate("Default value: /etc/wifidog-msg.html, optional"..
		"This allows you to specify a custome HTML file which will be used for"..
		"system errors by the gateway. Any $title, $message and $node variables"..
		"used inside the file will be replaced.")	)
proxyport.optional = true
proxyport.datatype = string
proxyport.placeholder = "/etc/wifidog-msg.html"

daemon = s:taboption("advanced", Flag, "daemon", translate("Run as daemon"))

-- interval = s:taboption("advanced", Value, "checkinterval", translate("CheckInterval"),
-- 	translate(
-- 		"Default value: 60<br />"..
-- 		"How many seconds should we wait between timeout checks.  This is also "..
-- 		"how often the gateway will ping the auth server and how often it will "..
-- 		"update the traffic counters on the auth server.  Setting this too low "..
-- 		"wastes bandwidth, setting this too high will cause the gateway to take "..
-- 		"a long time to switch to it's backup auth server(s)."))

httpd_name = s:taboption("advanced", Value, "httpdname", translate("HTTPDName"), 
	translate("# Default: WiFiDog, Optional# Define what name the HTTPD server will respond"))

httpd_maxconn = s:taboption("advanced", Value, "httpdmaxconn", translate("HTTPDMaxConn"), 
	translate("# Default: 10, Optional# How many sockets to listen to"))

httpd_realm = s:taboption("advanced", Value, "httpdrealm", translate("httpdrealm"), 
	translate("# Default: WiFiDog, Optional # The name of the HTTP authentication realm. This only used when a user # tries to access a protected WiFiDog internal page. See HTTPUserName."))

httpd_usrname =  s:taboption("advanced", Value, "httpdusername", translate("HTTPd_UserName"), 
	translate("# Default: unset, Optional # The gateway exposes some information such as the status page through its web # interface. This information can be protected with a username and password,# which can be set through the HTTPDUserName and HTTPDPassword parameters."))

httpd_usrpasswd = s:taboption("advanced", Value, "httpdpassword", translate("HTTPd_UserPassword"), 
	translate("# Default: unset, Optional # The gateway exposes some information such as the status page through its web# interface. This information can be protected with a username and password,# which can be set through the HTTPDUserName and HTTPDPassword parameters."))


serv = m:section(TypedSection, "authserver",  translate("Portal Server Settings"))
serv.addremove = false
serv.anonymous = false

serv:tab("general", translate("General Settings"))
serv:tab("advanced", translate("Advanced Settings"))

host = serv:taboption("general", Value, "hostname", translate("Host"))
host.datatype = host

sslavailable = serv:taboption("general", Flag, "sslavailable", translate("Use SSL"))
sslport = serv:taboption("general", Value, "sslport", translate("SSL Port"))
sslport:depends({sslavailable=true})
sslport.datatype = port
sslport.placeholder = 443

httpport = serv:taboption("general", Value, "httpport", translate("HTTP Port"))
httpport.datatype = port
sslport.placeholder = 80

webpath = serv:taboption("general", Value, "path", tranlsate("www Web Path"), 
	translate("Note:  The path must be both prefixed and suffixed by /.  Use a single / for server root."))
webpath.datatype = directory
webpath.placeholder = "/wifidog/"

frag_login = serv:taboption("advanced", Value, "loginscriptpathfragment", translate("LoginScriptPathFragment"), 
	translate("This is the script the user will be sent to for login"))
frag_login.datatype = string
frag_login.placeholder = "login/?"

frag_portal = serv:taboption("advanced", Value, "portalscriptpathfragment", translate("PortalScriptPathFragment"), 
	translate("This is the script the user will be sent to after a successfull login"))
frag_portal.datatype = string
frag_portal.placeholder = "portal/?"

frag_msg = serv:taboption("advanced", Value, "msgscriptpathfragment", translate("MsgScriptPathFragment"), 
	translate("This is the script the user will be sent to upon error to read a readable message"))
frag_msg.datatype = string
frag_msg.placeholder = "gw_message.php?"

frag_ping = serv:taboption("advanced", Value, "pingscriptpathfragment", translate("PingScriptPathFragment"), 
	translate("This is the script the user will be sent to upon error to read a readable message"))
frag_ping.datatype = string
frag_ping.placeholder = "ping/?"

frag_auth = serv:taboption("advanced", Value, "authscriptpathfragment", translate("AuthScriptPathFragment"), 
	translate("This is the script the user will be sent to upon error to read a readable message"))
frag_auth.datatype = string
frag_auth.placeholder = "auth/?"


whitelist = m:section(TypedSection, "alloweddomains",  translate("White List"), 
	translate("Host that allowed to be accessed without authentication"))
whitelist.addremove = true
whitelist.anonymous = false

wl_host = whitelist:option(DynamicList, "domain", translate("Host")) 
wl_host.optional = true
wl_host.datatype = "host"
wl_host.placeholder = "www.openrouter.com"


-- todo: add firewall rule support