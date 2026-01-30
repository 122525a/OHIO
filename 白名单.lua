local v1 = Instance.new("ScreenGui")
v1.Name = "NewGui"

local function Notify(v2, v3, v4, v5)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = v2,
        Text = v3,
        Icon = v4,
        Duration = v5
    })
end

local v6 = game:GetService("StarterGui")
local v7 = game:GetService("Players")
local v8 = {
    shcghjhcfs = true,
    CN_zwp22 = true,
    CN_zwp2 = true,
    CN_zwp = true,
    CN_zwp2222 = true,
    CN_zwp22221 = true,
    CN_zwp22222 = true,
    CN_zwp222222 = true,
    CN_zwp2222222 = true,
    CN_Shi66 = true,
    ["66666niuma"] = true,
    diduna5 = true,
    wcnm_noob = true,
    lHy1985 = true,
    ["11451423xx"] = true,
    Charahfhh = true,
    aosouftb = true,
    awwen15 = true,
    sanskevin111 = true,
    TAT917813 = true,
    isjdnwk = true,
    qwertyui110927 = true,
    cangyingtou = true,
    XDNBYYDS = true,
    mmwcnm8 = true,
    shousi5 = true,
    asda1223e234 = true,
    ZENMBANAAAAAAAAAAA = true,
    qsheepsN1 = true,
    WESBMP = true,
    jhhgfttyhhhgggh = true,
    bear_scriptyyds = true,
    liulian_yyds = true,
    CN_sheepsN1 = true,
    qqqgggddd8 = true,
    lajsans_1 = true,
    wuai030 = true,
    suyuanys = true,
    gsgg4890 = true,
    yttttttyyt8 = true,
    ["91k476881"] = true,
    hightyzdhhh = true,
    sansandcharaQAQQAQ = true,
    gfcgtdhq = true,
    Singsong52000 = true,
    doian0_0 = true,
    tgb54155555555 = true,
    mybsdsb = true,
    ["wzcdhjb "] = true
}

local v9 = v7.LocalPlayer

if v8[v9.Name] then
    local v11 = {
        Title = "白名单",
        Text = "玩家:" .. v9.Name .. "，欢迎使用YV脚本",
        Duration = 7
    }
    v6:SetCore("SendNotification", v11)
    Notify("已通过", nil, 3)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/122525a/OHIO/refs/heads/main/YV.lua"))()
    Notify("失败", "请购买YV脚本", nil, 5)
end
