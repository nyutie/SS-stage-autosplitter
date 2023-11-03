// state("ThankYouVeryCool-Win64-Shipping", "steam oldleaderboards") {
//     float levelTimer: 0x5B0F540, 0x118, 0xB54;
//     bool isOnMainMenu: 0x59C7EE0, 0x8D0, 0x0, 0x16B0, 0xD8
// }

// state("ThankYouVeryCool-Win64-Shipping", "epic oldleaderboards") {
//     float levelTimer: 0x5DC0380, 0x118, 0xB54;
//     bool isOnMainMenu: 0x5D52E90, 0x30, 0x60, 0x560, 0x320;
// }

// state("ThankYouVeryCool-Win64-Shipping", "steam patch 5.0") {
//     float levelTimer: 0x5B19140, 0x118, 0xB64;
//     bool isOnMainMenu: 0x59D1AE0, 0x2190, 0x0, 0xEA0, 0x27C;
// }

state("ThankYouVeryCool-Win64-Shipping", "steam patch 5.1") {
    float levelTimer: 0x5B1A2C0, 0x118, 0xB64;
    bool isOnMainMenu: 0x5940940, 0x18, 0x40, 0x0, 0x1D0, 0x38, 0xE0; // long ass pointer
    int stage: 0x5B1A2C0, 0x118, 0xD80, 0x2E0, 0x360;
    uint isFFx4WhenLevelIsNewType: 0x5B1A2C0, 0x118, 0xD80, 0x2E0, 0x398; // I know, it's dirty but it works. if you got a better way dm me
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
    switch ((long)modules.First().ModuleMemorySize) {
        // case 0x605D000:
        //     version = "steam oldleaderboards";
        //     break;
        // case 0x6380000:
        //     version = "epic oldleaderboards";
        //     break;
        // case 0x60B0000:
        //     version = "steam patch 5.0";
        //     break;
        case 0x60B2000:
            version = "steam patch 5.1";
            break;
        default:
            MessageBox.Show
            (
                "Unsupported version of the game! If you're on GOG, sorry, I don't have it.\n" +
                "If you're on Steam/Epic, I'm probably already working on the update!\n\n" +
                "If you have any questions you can find me on the official Greylock Discord server, or the official SS/EPN speedrun Discord server.\n\n" +
                "modules.First().BaseAddress: 0x" + modules.First().BaseAddress.ToString("X") + "\n" + 
                "modules.first().ModuleMemorySize: 0x" + modules.First().ModuleMemorySize.ToString("X") + "\n",
                "SS-stage-autosplitter", // caption
                MessageBoxButtons.OK,
                MessageBoxIcon.Warning
            );
            return;
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
            "It should work for bonus levels and any workshop level.",
            "SS-stage-autosplitter", // caption
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
