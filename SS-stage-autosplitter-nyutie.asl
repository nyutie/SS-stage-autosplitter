// state("ThankYouVeryCool-Win64-Shipping", "epic patch 5.2") {
//     float levelTimer: 0x5DCAF40, 0x118, 0xB64;
//     bool isOnMainMenu: 0x5C838E0, 0x8F0, 0xA0, 0x3E0, 0x320;
//     // int stage:
//     // uint isFFx4WhenLevelIsNewType:
// }

state("ThankYouVeryCool-Win64-Shipping", "steam patch 5.1") {
    float levelTimer: 0x5B1A2C0, 0x118, 0xB64;
    bool isOnMainMenu: 0x59D2C60, 0x2190, 0x0, 0xEA0, 0x27C;
    int stage: 0x5B1A2C0, 0x118, 0xD80, 0x2E0, 0x360;
    uint isFFx4WhenLevelIsNewType: 0x5B1A2C0, 0x118, 0xD80, 0x2E0, 0x398; // I know, it's dirty but it works. if you got a better way dm me
}

state("ThankYouVeryCool-Win64-Shipping", "steam patch 5.2") {
    float levelTimer: 0x5B1A300, 0x118, 0xB64;
    bool isOnMainMenu: 0x59D2CA0, 0x8F0, 0xA0, 0x3E0, 0x320;
    int stage: 0x5B1A300, 0x118, 0xD80, 0x2E0, 0x360;
    uint isFFx4WhenLevelIsNewType: 0x5B1A300, 0x118, 0xD80, 0x2E0, 0x398;
}

state("ThankYouVeryCool-Win64-Shipping", "steam patch 5.3") {
    float levelTimer: 0x5B28C00, 0x118, 0xB64;
    bool isOnMainMenu: 0x59E15A0, 0xF70, 0xA0, 0x3E0, 0x320;
    int stage: 0x5B28C00, 0x118, 0xD80, 0x2E0, 0x360;
    uint isFFx4WhenLevelIsNewType: 0x5B28C00, 0x118, 0xD80, 0x2E0, 0x398;
}

state("ThankYouVeryCool-Win64-Shipping", "steam patch 5.3.1") {
    float levelTimer: 0x5B28C80, 0x118, 0xB64;
    bool isOnMainMenu: 0x59E1620, 0xF70, 0xA0, 0x3E0, 0x320;
    int stage: 0x5B28C80, 0x118, 0xD80, 0x2E0, 0x360;
    uint isFFx4WhenLevelIsNewType: 0x5B28C80, 0x118, 0xD80, 0x2E0, 0x398;
}

state("ThankYouVeryCool-Win64-Shipping", "steam patch 5.3.2") {
    float levelTimer: 0x5B1E480, 0x118, 0xB64;
    bool isOnMainMenu: 0x59D6E20, 0xF70, 0xA0, 0x3E0, 0x320;
    int stage: 0x5B1E480, 0x118, 0xD80, 0x2E0, 0x360;
    uint isFFx4WhenLevelIsNewType: 0x5B1E480, 0x118, 0xD80, 0x2E0, 0x398;
}

startup
{
    if(timer.CurrentTimingMethod == TimingMethod.RealTime) // copied this from somewhere lmao
    {
        var timingMessage = MessageBox.Show
        (
            "This game uses Game Time (time without loads) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (time INCLUDING loads).\n"+
            "Would you like the timing method to be set to Game Time for you?",
            vars.aslName+" | LiveSplit",
            MessageBoxButtons.YesNo,
            MessageBoxIcon.Question
        );
        if (timingMessage == DialogResult.Yes) timer.CurrentTimingMethod = TimingMethod.GameTime;
    }
}

init
{
    string MD5Hash;
    using (var md5 = System.Security.Cryptography.MD5.Create())
    using (var s = File.Open(modules.First().FileName, FileMode.Open, FileAccess.Read, FileShare.ReadWrite))
    MD5Hash = md5.ComputeHash(s).Select(x => x.ToString("X2")).Aggregate((a, b) => a + b);

    switch (MD5Hash)
    {
        // case "37C6CE6B3C0C0399424250CC7EF3457F":
        //     version = "epic patch 5.2";
        //     break;
        case "A8C57AD035ED26B6E1DCED0499EBFA22":
            version = "steam patch 5.1";
            break;
        case "76EAB92EF3754360BAB05B7D535C6956":
            version = "steam patch 5.2";
            break;
        case "5CB50DA54A0E6718DDE1E1767261E1E1":
            version = "steam patch 5.3";
            break;
        case "A2A6EF0B983BC581FB7BEF6CA712DF93":
            version = "steam patch 5.3.1";
            break;
        case "E07998E54FE179C0BD9B6FA8B47A37D9":
            version = "steam patch 5.3.2";
            break;
        default:
            MessageBox.Show
            (
                "Unsupported version of the game! If you're on GOG, sorry, I don't have it.\n" +
                "If you're on Steam/Epic, I'm probably already working on the update!\n\n" +
                "If you have any questions you can find me on the official Greylock Discord server, or the official SS/EPN speedrun Discord server.\n\n" +
                "modules.first().ModuleMemorySize: 0x" + modules.First().ModuleMemorySize.ToString("X") + "\n" +
                "new FileInfo(modules.First().FileName).Length): 0x" + new FileInfo(modules.First().FileName).Length.ToString("X") + "\n" +
                "MD5Hash: " + MD5Hash,
                "SS-stage-autosplitter | LiveSplit",
                MessageBoxButtons.OK,
                MessageBoxIcon.Warning
            );
            print("Hash is: " + MD5Hash);
            return false;
    }
}

start
{
    if (current.isOnMainMenu || !(current.levelTimer < 0.1f && current.levelTimer > 0f)) {
        return false;
    }

    if (current.isFFx4WhenLevelIsNewType != 0xFFFFFFFF) {
        MessageBox.Show
        (
            "This level seems to be the old type. This autosplitter isn't meant for campaign levels, and will not work.\n" +
            "It should work for any single bonus or workshop level.",
            "SS-stage-autosplitter | LiveSplit", // caption
            MessageBoxButtons.OK,
            MessageBoxIcon.Warning
        );
        return false;
    }

    if (current.stage == 0)
    {
        return true;
    }
}

split
{
    if (current.stage == old.stage + 1)
    {
        return true;
    }
}

reset
{
    if (current.isOnMainMenu || old.levelTimer > current.levelTimer)
    {
        return true;
    }
}

isLoading
{
    if (current.levelTimer == old.levelTimer)
    {
        return true;
    }

    return false;
}

gameTime
{
    return TimeSpan.FromSeconds(current.levelTimer);
}
