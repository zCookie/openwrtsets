


m = Map("wifidog", translate(
    "Auth Portal"), translate("Configure Auth Portal."))

-- auth weixin - whitelist
sec_wl_wexin = m:section(
    TypedSection, "allowedwexin", translate("Wexin whitelist"),
    translate("Wexin account that authoried for free access"))
sec_wl_weixin:addremove = false
sec_wl_weixin.anonymous = true

opt_wl_wexin = sec_wl_weixin:option(DynamicList, "weixin", 
    translate("Weixin account"))
opt_wl_weixin.optional = true
opt_wl_host.datatype = 'string'
opt_wl_host.palceholder = 'openap'

-- host whitelist
sec_wl_host = m:section(
    TypedSection, "alloweddomains", translate("Domain whitelist"), 
    translate("Host that allowed to be accessed without authentication"))
sec_wl_host.addremove = true
sec_wl_host.anonymous = false

opt_wl_host = sec_wl_host:option(DynamicList, "domain", translate("Host")) 
opt_wl_host.optional = true
opt_wl_host.datatype = "host"
opt_wl_host.placeholder = "www.openrouter.com"
