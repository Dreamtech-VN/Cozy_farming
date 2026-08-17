using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using MyZoo;

// Dựng toàn bộ scene bằng code: menu MyZoo → Dựng scene.
// Chạy lại lúc nào cũng được — nó tạo scene mới đè lên, không sợ dựng nửa vời.
public static class SceneBuilder
{
    const int W = 960, H = 540;

    static readonly Color Bg = new Color(0.17f, 0.29f, 0.18f);
    static readonly Color Panel = new Color(1f, 0.97f, 0.90f);
    static readonly Color Primary = new Color(0.55f, 0.76f, 0.29f);
    static readonly Color Dark = new Color(0.24f, 0.18f, 0.11f);
    static readonly Color Soil = new Color(0.63f, 0.49f, 0.38f);

    static Font font;

    [MenuItem("MyZoo/Dựng scene")]
    public static void Build()
    {
        font = Resources.GetBuiltinResource<Font>("LegacyRuntime.ttf");
        if (font == null) font = Resources.GetBuiltinResource<Font>("Arial.ttf");

        var scene = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);

        var canvasGo = new GameObject("Canvas", typeof(Canvas), typeof(CanvasScaler), typeof(GraphicRaycaster));
        var canvas = canvasGo.GetComponent<Canvas>();
        canvas.renderMode = RenderMode.ScreenSpaceOverlay;
        var scaler = canvasGo.GetComponent<CanvasScaler>();
        scaler.uiScaleMode = CanvasScaler.ScaleMode.ScaleWithScreenSize;
        scaler.referenceResolution = new Vector2(W, H);
        scaler.matchWidthOrHeight = 0.5f;

        new GameObject("EventSystem", typeof(EventSystem), typeof(StandaloneInputModule));

        var camGo = new GameObject("Main Camera", typeof(Camera));
        camGo.tag = "MainCamera";
        var cam = camGo.GetComponent<Camera>();
        cam.clearFlags = CameraClearFlags.SolidColor;
        cam.backgroundColor = Bg;
        cam.orthographic = true;

        var prefabs = BuildPrefabs();

        var screens = Empty("Screens", canvasGo.transform);
        Stretch(screens);

        var hud = BuildHud(canvasGo.transform);
        var toast = BuildToast(canvasGo.transform);

        BuildSplash(screens.transform);
        BuildLogin(screens.transform);
        BuildRegister(screens.transform);
        BuildServerSelect(screens.transform, prefabs);
        BuildCharacterCreate(screens.transform);
        BuildLoading(screens.transform);
        BuildLobby(screens.transform);
        BuildFarm(screens.transform, prefabs);
        BuildZoo(screens.transform, prefabs);
        BuildMissions(screens.transform, prefabs);
        BuildMinigame(screens.transform, prefabs);
        BuildSocial(screens.transform, prefabs);
        BuildVisitFriend(screens.transform, prefabs);
        BuildLeaderboard(screens.transform, prefabs);
        BuildMail(screens.transform, prefabs);
        BuildAchievements(screens.transform, prefabs);

        var app = new GameObject("App", typeof(Api), typeof(App), typeof(ScreenManager));
        var manager = app.GetComponent<ScreenManager>();
        manager.screensRoot = screens.transform;
        manager.hud = hud;

        // Bật S01, tắt phần còn lại
        foreach (Transform child in screens.transform) child.gameObject.SetActive(child.name == "S01_Splash");
        hud.SetActive(false);
        toast.SetActive(true);

        System.IO.Directory.CreateDirectory("Assets/Scenes");
        EditorSceneManager.SaveScene(scene, "Assets/Scenes/Main.unity");
        EditorSceneManager.MarkSceneDirty(scene);

        ApplyPlayerSettings();
        EditorBuildSettings.scenes = new[] { new EditorBuildSettingsScene("Assets/Scenes/Main.unity", true) };
        AssetDatabase.SaveAssets();

        Debug.Log("MyZoo: dựng scene xong → Assets/Scenes/Main.unity. Bật server rồi bấm Play.");
    }

    [MenuItem("MyZoo/Cấu hình Player Settings (ngang + cho phép HTTP)")]
    public static void ApplyPlayerSettings()
    {
        PlayerSettings.defaultInterfaceOrientation = UIOrientation.AutoRotation;
        PlayerSettings.allowedAutorotateToPortrait = false;
        PlayerSettings.allowedAutorotateToPortraitUpsideDown = false;
        PlayerSettings.allowedAutorotateToLandscapeLeft = true;
        PlayerSettings.allowedAutorotateToLandscapeRight = true;
#if UNITY_2022_1_OR_NEWER
        // Cho phép gọi http:// khi dev; lên production dùng https thì đổi lại NotAllowed
        PlayerSettings.insecureHttpOption = InsecureHttpOption.AlwaysAllowed;
#endif
        Debug.Log("MyZoo: đã khoá màn hình ngang và cho phép HTTP.");
    }

    // ---------------- Prefabs ----------------
    class Prefabs
    {
        public GameObject row, plotCell, habitatCard, animalIcon, serverCard, boardCell, speciesCard;
    }

    static Prefabs BuildPrefabs()
    {
        System.IO.Directory.CreateDirectory("Assets/Prefabs");
        var p = new Prefabs();
        p.speciesCard = SavePrefab(MakeSpeciesCard(), "SpeciesCard");
        p.row = SavePrefab(MakeRow(), "Row");
        p.plotCell = SavePrefab(MakePlotCell(), "PlotCell");
        p.animalIcon = SavePrefab(MakeAnimalIcon(), "AnimalIcon");
        p.habitatCard = SavePrefab(MakeHabitatCard(p.animalIcon), "HabitatCard");
        p.serverCard = SavePrefab(MakeServerCard(), "ServerCard");
        p.boardCell = SavePrefab(MakeBoardCell(), "BoardCell");
        return p;
    }

    static GameObject SavePrefab(GameObject go, string name)
    {
        string path = "Assets/Prefabs/" + name + ".prefab";
        var saved = PrefabUtility.SaveAsPrefabAsset(go, path);
        Object.DestroyImmediate(go);
        return saved;
    }

    static GameObject MakeRow()
    {
        var go = Button("Row", null, Panel, 420, 40);
        var label = Text("Label", go.transform, "", 14, Dark, TextAnchor.MiddleLeft);
        Stretch(label, 10, 0);
        return go;
    }

    static GameObject MakePlotCell()
    {
        var go = Button("PlotCell", null, Soil, 92, 74);
        var crop = Image("Crop", go.transform, Color.white, 48, 48);
        Center(crop, 0, 6);
        var glow = Image("ReadyGlow", go.transform, new Color(1f, 0.95f, 0.4f, 0.35f), 88, 70);
        Center(glow, 0, 0);
        glow.transform.SetSiblingIndex(0);
        var bar = Image("Progress", go.transform, new Color(0.2f, 0.6f, 0.1f), 68, 6);
        Center(bar, 0, -28);
        var barImage = bar.GetComponent<Image>();
        barImage.type = Image.Type.Filled;
        barImage.fillMethod = Image.FillMethod.Horizontal;
        var timer = Text("Timer", go.transform, "", 11, Color.white, TextAnchor.MiddleCenter);
        Center(timer, 0, -18);
        Size(timer, 88, 16);

        var cell = go.AddComponent<PlotCell>();
        cell.button = go.GetComponent<Button>();
        cell.cropImage = crop.GetComponent<Image>();
        cell.readyGlow = glow.GetComponent<Image>();
        cell.progressBar = barImage;
        cell.timerText = timer.GetComponent<Text>();
        return go;
    }

    static GameObject MakeAnimalIcon()
    {
        return Image("AnimalIcon", null, Color.white, 44, 44);
    }

    static GameObject MakeHabitatCard(GameObject animalIcon)
    {
        var go = Button("HabitatCard", null, new Color(0.65f, 0.84f, 0.65f), 236, 130);
        var title = Text("Name", go.transform, "Chuồng", 14, Dark, TextAnchor.UpperLeft);
        Stretch(title, 10, 0);
        var row = Empty("AnimalRow", go.transform);
        Size(row, 216, 50);
        Center(row, 0, -10);
        var layout = row.AddComponent<HorizontalLayoutGroup>();
        layout.spacing = 6;
        layout.childAlignment = TextAnchor.MiddleLeft;
        layout.childForceExpandWidth = false;
        layout.childForceExpandHeight = false;

        var card = go.AddComponent<HabitatCard>();
        card.button = go.GetComponent<Button>();
        card.nameText = title.GetComponent<Text>();
        card.animalRow = row.transform;
        card.animalIconPrefab = animalIcon;
        return go;
    }

    static GameObject MakeServerCard()
    {
        var go = Button("ServerCard", null, Panel, 420, 64);
        var name = Text("Name", go.transform, "Máy chủ", 16, Dark, TextAnchor.UpperLeft);
        Stretch(name, 12, 6);
        var status = Text("Status", go.transform, "", 12, new Color(0.3f, 0.5f, 0.2f), TextAnchor.LowerLeft);
        Stretch(status, 12, 6);
        var population = Text("Population", go.transform, "", 12, Dark, TextAnchor.LowerRight);
        Stretch(population, 12, 6);
        var badge = Text("Recommend", go.transform, "ĐỀ XUẤT", 11, new Color(0.85f, 0.45f, 0.1f), TextAnchor.UpperRight);
        Stretch(badge, 12, 6);

        var card = go.AddComponent<ServerCard>();
        card.button = go.GetComponent<Button>();
        card.nameText = name.GetComponent<Text>();
        card.statusText = status.GetComponent<Text>();
        card.populationText = population.GetComponent<Text>();
        card.recommendBadge = badge;
        return go;
    }

    static GameObject MakeSpeciesCard()
    {
        var go = Image("SpeciesCard", null, Color.white, 84, 96);
        var label = Text("Label", go.transform, "???", 12, Dark, TextAnchor.LowerCenter);
        Stretch(label, 2, 2);
        return go;
    }

    static GameObject MakeBoardCell()
    {
        return Button("BoardCell", null, Color.white, 56, 56);
    }

    // ---------------- HUD / Toast ----------------
    static GameObject BuildHud(Transform parent)
    {
        var hud = Image("HUD", parent, new Color(0.12f, 0.16f, 0.10f, 0.85f), 0, 46);
        var rt = hud.GetComponent<RectTransform>();
        rt.anchorMin = new Vector2(0, 1);
        rt.anchorMax = new Vector2(1, 1);
        rt.pivot = new Vector2(0.5f, 1);
        rt.offsetMin = new Vector2(0, -46);
        rt.offsetMax = Vector2.zero;

        var layout = hud.AddComponent<HorizontalLayoutGroup>();
        layout.padding = new RectOffset(12, 12, 6, 6);
        layout.spacing = 14;
        layout.childAlignment = TextAnchor.MiddleLeft;
        layout.childForceExpandWidth = false;

        var name = HudText(hud.transform, "NameText", "Khách", 150);
        var vang = HudText(hud.transform, "VangText", "Vàng 0", 130);
        var kc = HudText(hud.transform, "KcText", "KC 0", 100);
        var farmLv = HudText(hud.transform, "FarmLvText", "Farm Lv1", 110);
        var zooLv = HudText(hud.transform, "ZooLvText", "Zoo Lv1", 110);
        var back = Button("BackButton", hud.transform, Primary, 110, 32);
        var backLabel = Text("Label", back.transform, "◀ Về sảnh", 13, Dark, TextAnchor.MiddleCenter);
        Stretch(backLabel);
        back.AddComponent<LayoutElement>().preferredWidth = 110;

        var comp = hud.AddComponent<Hud>();
        comp.nameText = name;
        comp.vangText = vang;
        comp.kcText = kc;
        comp.farmLvText = farmLv;
        comp.zooLvText = zooLv;
        comp.backButton = back.GetComponent<Button>();
        return hud;
    }

    static Text HudText(Transform parent, string name, string value, float width)
    {
        var go = Text(name, parent, value, 15, Color.white, TextAnchor.MiddleLeft);
        go.AddComponent<LayoutElement>().preferredWidth = width;
        return go.GetComponent<Text>();
    }

    static GameObject BuildToast(Transform parent)
    {
        var go = Image("Toast", parent, new Color(0.1f, 0.1f, 0.1f, 0.9f), 620, 46);
        var rt = go.GetComponent<RectTransform>();
        rt.anchorMin = rt.anchorMax = new Vector2(0.5f, 0);
        rt.pivot = new Vector2(0.5f, 0);
        rt.anchoredPosition = new Vector2(0, 20);
        var label = Text("Label", go.transform, "", 15, Color.white, TextAnchor.MiddleCenter);
        Stretch(label, 10, 0);
        go.AddComponent<CanvasGroup>().alpha = 0;
        var toast = go.AddComponent<Toast>();
        toast.label = label.GetComponent<Text>();
        return go;
    }

    // ---------------- Screens ----------------
    static GameObject Screen(string name, Transform parent, string title)
    {
        var go = Image(name, parent, Bg, 0, 0);
        Stretch(go);
        if (title != null)
        {
            var text = Text("Title", go.transform, title, 26, Color.white, TextAnchor.UpperCenter);
            var rt = text.GetComponent<RectTransform>();
            rt.anchorMin = new Vector2(0, 1);
            rt.anchorMax = new Vector2(1, 1);
            rt.pivot = new Vector2(0.5f, 1);
            rt.offsetMin = new Vector2(0, -70);
            rt.offsetMax = new Vector2(0, -18);
        }
        return go;
    }

    static void BuildSplash(Transform parent)
    {
        var screen = Screen("S01_Splash", parent, "MyZoo");
        var status = Text("Status", screen.transform, "Đang kết nối...", 18, Color.white, TextAnchor.MiddleCenter);
        Center(status, 0, 0); Size(status, 700, 90);

        var barBg = Image("BarBg", screen.transform, new Color(1, 1, 1, 0.2f), 420, 14);
        Center(barBg, 0, -70);
        var bar = Image("Bar", barBg.transform, Primary, 420, 14);
        Stretch(bar);
        var barImage = bar.GetComponent<Image>();
        barImage.type = Image.Type.Filled;
        barImage.fillMethod = Image.FillMethod.Horizontal;
        barImage.fillAmount = 0f;

        var version = Text("Version", screen.transform, "v0.1.0", 12, new Color(1, 1, 1, 0.6f), TextAnchor.LowerRight);
        var vrt = version.GetComponent<RectTransform>();
        vrt.anchorMin = vrt.anchorMax = new Vector2(1, 0);
        vrt.pivot = new Vector2(1, 0);
        vrt.anchoredPosition = new Vector2(-16, 12);
        Size(version, 120, 20);

        var retry = Button("RetryButton", screen.transform, Primary, 180, 44);
        Center(retry, 0, -130);
        var retryLabel = Text("Label", retry.transform, "Thử lại", 16, Dark, TextAnchor.MiddleCenter);
        Stretch(retryLabel);

        var comp = screen.AddComponent<SplashScreen>();
        comp.statusText = status.GetComponent<Text>();
        comp.versionText = version.GetComponent<Text>();
        comp.progressBar = barImage;
        comp.retryButton = retry.GetComponent<Button>();
    }

    static void BuildLogin(Transform parent)
    {
        var screen = Screen("S02_Login", parent, "Đăng nhập");
        var username = InputField("UsernameInput", screen.transform, "Tên đăng nhập", 0, 60);
        var password = InputField("PasswordInput", screen.transform, "Mật khẩu", 0, 6);
        password.GetComponent<InputField>().contentType = InputField.ContentType.Password;

        var error = Text("Error", screen.transform, "", 13, new Color(0.95f, 0.45f, 0.4f), TextAnchor.MiddleCenter);
        Center(error, 0, -34); Size(error, 460, 24);

        var login = Button("LoginButton", screen.transform, Primary, 220, 46);
        Center(login, 0, -78);
        Stretch(Text("Label", login.transform, "Đăng nhập", 16, Dark, TextAnchor.MiddleCenter));

        var guest = Button("GuestButton", screen.transform, new Color(0.85f, 0.85f, 0.85f), 220, 40);
        Center(guest, 0, -130);
        Stretch(Text("Label", guest.transform, "Chơi ngay (khách)", 15, Dark, TextAnchor.MiddleCenter));

        var register = Button("RegisterLink", screen.transform, new Color(1, 1, 1, 0f), 300, 30);
        Center(register, 0, -172);
        Stretch(Text("Label", register.transform, "Chưa có tài khoản? Đăng ký", 13, new Color(0.8f, 0.9f, 0.7f), TextAnchor.MiddleCenter));

        var comp = screen.AddComponent<LoginScreen>();
        comp.usernameInput = username.GetComponent<InputField>();
        comp.passwordInput = password.GetComponent<InputField>();
        comp.loginButton = login.GetComponent<Button>();
        comp.guestButton = guest.GetComponent<Button>();
        comp.registerLink = register.GetComponent<Button>();
        comp.errorText = error.GetComponent<Text>();
    }

    static void BuildRegister(Transform parent)
    {
        var screen = Screen("S03_Register", parent, "Đăng ký");
        var username = InputField("UsernameInput", screen.transform, "Tên đăng nhập (a-z, 0-9)", 0, 90);
        var password = InputField("PasswordInput", screen.transform, "Mật khẩu (từ 6 ký tự)", 0, 38);
        password.GetComponent<InputField>().contentType = InputField.ContentType.Password;
        var confirm = InputField("ConfirmInput", screen.transform, "Nhập lại mật khẩu", 0, -14);
        confirm.GetComponent<InputField>().contentType = InputField.ContentType.Password;

        var toggleGo = new GameObject("TermsToggle", typeof(RectTransform), typeof(Toggle));
        toggleGo.transform.SetParent(screen.transform, false);
        Size(toggleGo, 360, 26);
        Center(toggleGo, 0, -50);
        var box = Image("Box", toggleGo.transform, Color.white, 22, 22);
        var boxRt = box.GetComponent<RectTransform>();
        boxRt.anchorMin = boxRt.anchorMax = new Vector2(0, 0.5f);
        boxRt.pivot = new Vector2(0, 0.5f);
        boxRt.anchoredPosition = new Vector2(0, 0);
        var check = Image("Check", box.transform, Primary, 16, 16);
        Center(check, 0, 0);
        var termsLabel = Text("Label", toggleGo.transform, "Tôi đồng ý điều khoản", 13, Color.white, TextAnchor.MiddleLeft);
        Stretch(termsLabel, 30, 0);
        var toggle = toggleGo.GetComponent<Toggle>();
        toggle.targetGraphic = box.GetComponent<Image>();
        toggle.graphic = check.GetComponent<Image>();
        toggle.isOn = true;

        var error = Text("Error", screen.transform, "", 13, new Color(0.95f, 0.45f, 0.4f), TextAnchor.MiddleCenter);
        Center(error, 0, -82); Size(error, 460, 24);

        var submit = Button("SubmitButton", screen.transform, Primary, 220, 46);
        Center(submit, 0, -122);
        Stretch(Text("Label", submit.transform, "Tạo tài khoản", 16, Dark, TextAnchor.MiddleCenter));

        var back = Button("BackLink", screen.transform, new Color(1, 1, 1, 0f), 240, 30);
        Center(back, 0, -166);
        Stretch(Text("Label", back.transform, "◀ Quay lại đăng nhập", 13, new Color(0.8f, 0.9f, 0.7f), TextAnchor.MiddleCenter));

        var comp = screen.AddComponent<RegisterScreen>();
        comp.usernameInput = username.GetComponent<InputField>();
        comp.passwordInput = password.GetComponent<InputField>();
        comp.confirmInput = confirm.GetComponent<InputField>();
        comp.termsToggle = toggle;
        comp.submitButton = submit.GetComponent<Button>();
        comp.backLink = back.GetComponent<Button>();
        comp.errorText = error.GetComponent<Text>();
    }

    static void BuildServerSelect(Transform parent, Prefabs prefabs)
    {
        var screen = Screen("S06_ServerSelect", parent, "Chọn máy chủ");
        var content = ScrollList("ServerList", screen.transform, 460, 340, 0, -20);
        var comp = screen.AddComponent<ServerSelectScreen>();
        comp.content = content;
        comp.cardPrefab = prefabs.serverCard;
    }

    static void BuildCharacterCreate(Transform parent)
    {
        var screen = Screen("S07_CharacterCreate", parent, "Tạo nhân vật");

        var preview = Image("Preview", screen.transform, Color.white, 140, 180);
        Center(preview, 0, 40);
        var lookName = Text("LookName", screen.transform, "farmer_1", 13, new Color(1, 1, 1, 0.7f), TextAnchor.MiddleCenter);
        Center(lookName, 0, -60); Size(lookName, 200, 20);

        var prev = Button("PrevButton", screen.transform, Panel, 46, 46);
        Center(prev, -130, 40);
        Stretch(Text("Label", prev.transform, "◀", 20, Dark, TextAnchor.MiddleCenter));

        var next = Button("NextButton", screen.transform, Panel, 46, 46);
        Center(next, 130, 40);
        Stretch(Text("Label", next.transform, "▶", 20, Dark, TextAnchor.MiddleCenter));

        var nameInput = InputField("NameInput", screen.transform, "Tên nhân vật", -40, -100);
        Size(nameInput, 300, 44);

        var random = Button("RandomButton", screen.transform, Panel, 60, 44);
        Center(random, 180, -100);
        Stretch(Text("Label", random.transform, "Ngẫu\nnhiên", 11, Dark, TextAnchor.MiddleCenter));

        var error = Text("Error", screen.transform, "", 13, new Color(0.95f, 0.45f, 0.4f), TextAnchor.MiddleCenter);
        Center(error, 0, -140); Size(error, 460, 24);

        var start = Button("StartButton", screen.transform, Primary, 220, 46);
        Center(start, 0, -180);
        Stretch(Text("Label", start.transform, "Vào game", 16, Dark, TextAnchor.MiddleCenter));

        var comp = screen.AddComponent<CharacterCreateScreen>();
        comp.preview = preview.GetComponent<Image>();
        comp.lookNameText = lookName.GetComponent<Text>();
        comp.prevButton = prev.GetComponent<Button>();
        comp.nextButton = next.GetComponent<Button>();
        comp.randomButton = random.GetComponent<Button>();
        comp.startButton = start.GetComponent<Button>();
        comp.nameInput = nameInput.GetComponent<InputField>();
        comp.errorText = error.GetComponent<Text>();
        // 3 ngoại hình mặc định: khác màu, thay sprite sau
        comp.looks = new CharacterCreateScreen.Look[]
        {
            new CharacterCreateScreen.Look { id = "farmer_1", tint = new Color(0.55f, 0.78f, 0.35f) },
            new CharacterCreateScreen.Look { id = "farmer_2", tint = new Color(0.95f, 0.75f, 0.35f) },
            new CharacterCreateScreen.Look { id = "keeper_1", tint = new Color(0.40f, 0.70f, 0.95f) }
        };
    }

    static void BuildLoading(Transform parent)
    {
        var screen = Screen("S08_Loading", parent, "Đang vào game...");
        var barBg = Image("BarBg", screen.transform, new Color(1, 1, 1, 0.2f), 460, 16);
        Center(barBg, 0, 0);
        var bar = Image("Bar", barBg.transform, Primary, 460, 16);
        Stretch(bar);
        var barImage = bar.GetComponent<Image>();
        barImage.type = Image.Type.Filled;
        barImage.fillMethod = Image.FillMethod.Horizontal;

        var tip = Text("Tip", screen.transform, "", 14, new Color(1, 1, 1, 0.8f), TextAnchor.MiddleCenter);
        Center(tip, 0, -50); Size(tip, 700, 50);

        var comp = screen.AddComponent<LoadingScreen>();
        comp.progressBar = barImage;
        comp.tipText = tip.GetComponent<Text>();
    }

    static void BuildLobby(Transform parent)
    {
        var screen = Screen("S09_Lobby", parent, null);

        var farm = BigButton(screen.transform, "FarmButton", "NÔNG TRẠI", -170, 40);
        var zoo = BigButton(screen.transform, "ZooButton", "SỞ THÚ", 170, 40);
        var minigame = BigButton(screen.transform, "MinigameButton", "MINI GAME", -170, -90);
        var mission = BigButton(screen.transform, "MissionButton", "NHIỆM VỤ", 170, -90);

        var social = Button("SocialButton", screen.transform, new Color(0.55f, 0.72f, 0.95f), 170, 44);
        Center(social, -180, -155);
        Stretch(Text("Label", social.transform, "BẠN BÈ", 16, Dark, TextAnchor.MiddleCenter));

        var rank = Button("RankButton", screen.transform, new Color(0.95f, 0.80f, 0.45f), 170, 44);
        Center(rank, 0, -155);
        Stretch(Text("Label", rank.transform, "XẾP HẠNG", 16, Dark, TextAnchor.MiddleCenter));

        var mail = Button("MailButton", screen.transform, new Color(0.85f, 0.70f, 0.95f), 170, 44);
        Center(mail, 180, -155);
        Stretch(Text("Label", mail.transform, "HỘP THƯ", 16, Dark, TextAnchor.MiddleCenter));
        var mailDot = Image("Dot", mail.transform, new Color(0.9f, 0.2f, 0.2f), 16, 16);
        var mailDotRt = mailDot.GetComponent<RectTransform>();
        mailDotRt.anchorMin = mailDotRt.anchorMax = new Vector2(1, 1);
        mailDotRt.pivot = new Vector2(1, 1);
        mailDotRt.anchoredPosition = new Vector2(-6, -6);
        mailDot.SetActive(false);

        var achievement = Button("AchievementButton", screen.transform, new Color(0.95f, 0.65f, 0.55f), 200, 38);
        Center(achievement, -280, -215);
        Stretch(Text("Label", achievement.transform, "Thành tựu", 14, Dark, TextAnchor.MiddleCenter));

        var checkin = Button("CheckinButton", screen.transform, new Color(0.98f, 0.80f, 0.30f), 180, 40);
        Center(checkin, -80, -215);
        Stretch(Text("Label", checkin.transform, "Điểm danh", 15, Dark, TextAnchor.MiddleCenter));

        var logout = Button("LogoutButton", screen.transform, new Color(0.75f, 0.75f, 0.75f), 140, 40);
        Center(logout, 120, -215);
        Stretch(Text("Label", logout.transform, "Đăng xuất", 14, Dark, TextAnchor.MiddleCenter));

        var comp = screen.AddComponent<LobbyScreen>();
        comp.farmButton = farm.GetComponent<Button>();
        comp.zooButton = zoo.GetComponent<Button>();
        comp.minigameButton = minigame.GetComponent<Button>();
        comp.missionButton = mission.GetComponent<Button>();
        comp.checkinButton = checkin.GetComponent<Button>();
        comp.logoutButton = logout.GetComponent<Button>();
        comp.socialButton = social.GetComponent<Button>();
        comp.rankButton = rank.GetComponent<Button>();
        comp.mailButton = mail.GetComponent<Button>();
        comp.achievementButton = achievement.GetComponent<Button>();
        comp.mailDot = mailDot;
        comp.farmDot = farm.transform.Find("Dot").gameObject;
        comp.zooDot = zoo.transform.Find("Dot").gameObject;
        comp.missionDot = mission.transform.Find("Dot").gameObject;
    }

    static GameObject BigButton(Transform parent, string name, string label, float x, float y)
    {
        var go = Button(name, parent, Primary, 280, 100);
        Center(go, x, y);
        Stretch(Text("Label", go.transform, label, 22, Dark, TextAnchor.MiddleCenter));
        var dot = Image("Dot", go.transform, new Color(0.9f, 0.2f, 0.2f), 18, 18);
        var rt = dot.GetComponent<RectTransform>();
        rt.anchorMin = rt.anchorMax = new Vector2(1, 1);
        rt.pivot = new Vector2(1, 1);
        rt.anchoredPosition = new Vector2(-8, -8);
        dot.SetActive(false);
        return go;
    }

    static void BuildFarm(Transform parent, Prefabs prefabs)
    {
        var screen = Screen("S10_Farm", parent, null);

        var grid = Empty("PlotGrid", screen.transform);
        Size(grid, 776, 476);
        Center(grid, 90, -14);
        var layout = grid.AddComponent<GridLayoutGroup>();
        layout.cellSize = new Vector2(92, 74);
        layout.spacing = new Vector2(4, 4);
        layout.constraint = GridLayoutGroup.Constraint.FixedColumnCount;
        layout.constraintCount = 8;

        var storage = ScrollList("Storage", screen.transform, 250, 380, -350, -30);

        var picker = Image("CropPickerPanel", screen.transform, Panel, 420, 420);
        Center(picker, 0, 0);
        Stretch(Text("PickerTitle", picker.transform, "Chọn cây trồng", 18, Dark, TextAnchor.UpperCenter), 0, 8);
        var pickerList = ScrollList("PickerList", picker.transform, 400, 340, 0, -20);
        var closePicker = Button("ClosePicker", picker.transform, new Color(0.9f, 0.6f, 0.6f), 34, 34);
        var closeRt = closePicker.GetComponent<RectTransform>();
        closeRt.anchorMin = closeRt.anchorMax = new Vector2(1, 1);
        closeRt.pivot = new Vector2(1, 1);
        closeRt.anchoredPosition = new Vector2(-6, -6);
        Stretch(Text("Label", closePicker.transform, "X", 16, Dark, TextAnchor.MiddleCenter));
        picker.SetActive(false);

        var comp = screen.AddComponent<FarmScreen>();
        comp.plotGrid = grid.transform;
        comp.storageContent = storage;
        comp.cropPickerContent = pickerList;
        comp.cropPickerPanel = picker;
        comp.plotPrefab = prefabs.plotCell;
        comp.rowPrefab = prefabs.row;
        comp.closePickerButton = closePicker.GetComponent<Button>();
    }

    static void BuildZoo(Transform parent, Prefabs prefabs)
    {
        var screen = Screen("S20_Zoo", parent, null);

        var status = Text("Status", screen.transform, "", 15, Color.white, TextAnchor.UpperLeft);
        Size(status, 260, 110);
        Center(status, -340, 120);

        var grid = Empty("HabitatGrid", screen.transform);
        Size(grid, 740, 400);
        Center(grid, 90, -10);
        var layout = grid.AddComponent<GridLayoutGroup>();
        layout.cellSize = new Vector2(236, 130);
        layout.spacing = new Vector2(10, 10);
        layout.constraint = GridLayoutGroup.Constraint.FixedColumnCount;
        layout.constraintCount = 3;

        var manage = Button("ManageButton", screen.transform, Panel, 240, 44);
        Center(manage, -340, 10);
        Stretch(Text("Label", manage.transform, "Xây chuồng / Chuyển đồ ăn", 14, Dark, TextAnchor.MiddleCenter));

        var action = Button("ActionButton", screen.transform, Primary, 240, 52);
        Center(action, -340, -60);
        var actionLabel = Text("Label", action.transform, "Mở cửa đón khách", 15, Dark, TextAnchor.MiddleCenter);
        Stretch(actionLabel);

        // Panel quản lý
        var managePanel = Image("ManagePanel", screen.transform, Panel, 460, 430);
        Center(managePanel, 0, 0);
        Stretch(Text("T1", managePanel.transform, "Xây chuồng", 16, Dark, TextAnchor.UpperCenter), 0, 8);
        var buildList = ScrollList("BuildList", managePanel.transform, 430, 150, 0, 80);
        Stretch(Text("T2", managePanel.transform, "Chuyển thức ăn sang Zoo", 16, Dark, TextAnchor.UpperCenter), 0, 190);
        var deliverList = ScrollList("DeliverList", managePanel.transform, 430, 150, 0, -110);
        var closeManage = CloseButton(managePanel.transform);
        managePanel.SetActive(false);

        // Panel chuồng
        var habitatPanel = Image("HabitatPanel", screen.transform, Panel, 480, 420);
        Center(habitatPanel, 0, 0);
        var habitatTitle = Text("HabitatTitle", habitatPanel.transform, "Chuồng", 18, Dark, TextAnchor.UpperCenter);
        Stretch(habitatTitle, 0, 8);
        var feed = Button("FeedButton", habitatPanel.transform, Primary, 220, 42);
        Center(feed, 0, 140);
        Stretch(Text("Label", feed.transform, "Cho cả chuồng ăn", 15, Dark, TextAnchor.MiddleCenter));
        var speciesList = ScrollList("SpeciesList", habitatPanel.transform, 450, 250, 0, -50);
        var closeHabitat = CloseButton(habitatPanel.transform);
        habitatPanel.SetActive(false);

        var comp = screen.AddComponent<ZooScreen>();
        comp.habitatGrid = grid.transform;
        comp.buildContent = buildList;
        comp.deliverContent = deliverList;
        comp.speciesContent = speciesList;
        comp.habitatPrefab = prefabs.habitatCard;
        comp.rowPrefab = prefabs.row;
        comp.managePanel = managePanel;
        comp.habitatPanel = habitatPanel;
        comp.actionButton = action.GetComponent<Button>();
        comp.manageButton = manage.GetComponent<Button>();
        comp.feedButton = feed.GetComponent<Button>();
        comp.closeManageButton = closeManage;
        comp.closeHabitatButton = closeHabitat;
        comp.statusText = status.GetComponent<Text>();
        comp.actionText = actionLabel.GetComponent<Text>();
        comp.habitatTitle = habitatTitle.GetComponent<Text>();
    }

    static void BuildMissions(Transform parent, Prefabs prefabs)
    {
        var screen = Screen("S30_Missions", parent, "Nhiệm vụ hôm nay");
        var list = ScrollList("MissionList", screen.transform, 620, 350, 0, -20);
        var comp = screen.AddComponent<MissionsScreen>();
        comp.content = list;
        comp.rowPrefab = prefabs.row;
    }

    static void BuildMinigame(Transform parent, Prefabs prefabs)
    {
        var screen = Screen("S40_Minigame", parent, null);
        var header = Text("Header", screen.transform, "", 16, Color.white, TextAnchor.MiddleCenter);
        Size(header, 700, 30);
        Center(header, 0, 190);

        var board = Empty("Board", screen.transform);
        Size(board, 372, 372);
        Center(board, 0, -10);
        var layout = board.AddComponent<GridLayoutGroup>();
        layout.cellSize = new Vector2(56, 56);
        layout.spacing = new Vector2(6, 6);
        layout.constraint = GridLayoutGroup.Constraint.FixedColumnCount;
        layout.constraintCount = 6;

        var finish = Button("FinishButton", screen.transform, Primary, 240, 44);
        Center(finish, 0, -215);
        Stretch(Text("Label", finish.transform, "Kết thúc & nhận thưởng", 15, Dark, TextAnchor.MiddleCenter));

        var comp = screen.AddComponent<MinigameScreen>();
        comp.board = board.transform;
        comp.cellPrefab = prefabs.boardCell;
        comp.headerText = header.GetComponent<Text>();
        comp.finishButton = finish.GetComponent<Button>();
    }

    static void BuildSocial(Transform parent, Prefabs prefabs)
    {
        var screen = Screen("S24_Social", parent, "Bạn bè");

        var search = InputField("SearchInput", screen.transform, "Tên người chơi muốn kết bạn", -80, 150);
        Size(search, 380, 42);
        var add = Button("AddButton", screen.transform, Primary, 120, 42);
        Center(add, 180, 150);
        Stretch(Text("Label", add.transform, "Kết bạn", 15, Dark, TextAnchor.MiddleCenter));

        var helps = Text("HelpsLeft", screen.transform, "", 13, new Color(1, 1, 1, 0.8f), TextAnchor.MiddleCenter);
        Center(helps, 0, 112); Size(helps, 600, 20);

        var friendLabel = Text("FriendLabel", screen.transform, "Bạn bè", 15, Color.white, TextAnchor.MiddleLeft);
        Center(friendLabel, -230, 82); Size(friendLabel, 300, 22);
        var friendList = ScrollList("FriendList", screen.transform, 440, 220, -230, -40);

        var requestLabel = Text("RequestLabel", screen.transform, "Lời mời", 15, Color.white, TextAnchor.MiddleLeft);
        Center(requestLabel, 230, 82); Size(requestLabel, 300, 22);
        var requestList = ScrollList("RequestList", screen.transform, 440, 220, 230, -40);

        var comp = screen.AddComponent<SocialScreen>();
        comp.friendContent = friendList;
        comp.requestContent = requestList;
        comp.rowPrefab = prefabs.row;
        comp.searchInput = search.GetComponent<InputField>();
        comp.addButton = add.GetComponent<Button>();
        comp.helpsLeftText = helps.GetComponent<Text>();
        comp.sectionFriendText = friendLabel.GetComponent<Text>();
        comp.sectionRequestText = requestLabel.GetComponent<Text>();
    }

    static void BuildVisitFriend(Transform parent, Prefabs prefabs)
    {
        var screen = Screen("S26_VisitFriend", parent, null);

        var title = Text("Title", screen.transform, "Nông trại của bạn", 20, Color.white, TextAnchor.MiddleLeft);
        Center(title, -220, 190); Size(title, 500, 26);
        var status = Text("Status", screen.transform, "", 13, new Color(1, 1, 1, 0.8f), TextAnchor.MiddleLeft);
        Center(status, -220, 165); Size(status, 500, 20);

        var grid = Empty("PlotGrid", screen.transform);
        Size(grid, 700, 260);
        Center(grid, -80, 20);
        var layout = grid.AddComponent<GridLayoutGroup>();
        layout.cellSize = new Vector2(56, 46);
        layout.spacing = new Vector2(3, 3);
        layout.constraint = GridLayoutGroup.Constraint.FixedColumnCount;
        layout.constraintCount = 12;

        var habitats = Empty("HabitatRow", screen.transform);
        Size(habitats, 900, 140);
        Center(habitats, 0, -150);
        var hlayout = habitats.AddComponent<HorizontalLayoutGroup>();
        hlayout.spacing = 10;
        hlayout.childForceExpandWidth = false;
        hlayout.childAlignment = TextAnchor.MiddleCenter;

        var help = Button("HelpButton", screen.transform, Primary, 200, 46);
        Center(help, 330, 150);
        Stretch(Text("Label", help.transform, "Giúp bạn (+Vàng)", 15, Dark, TextAnchor.MiddleCenter));

        var back = Button("BackButton", screen.transform, new Color(0.8f, 0.8f, 0.8f), 140, 36);
        Center(back, 330, 95);
        Stretch(Text("Label", back.transform, "◀ Danh sách bạn", 13, Dark, TextAnchor.MiddleCenter));

        var comp = screen.AddComponent<VisitFriendScreen>();
        comp.titleText = title.GetComponent<Text>();
        comp.statusText = status.GetComponent<Text>();
        comp.plotGrid = grid.transform;
        comp.habitatRow = habitats.transform;
        comp.plotPrefab = prefabs.plotCell;
        comp.habitatPrefab = prefabs.habitatCard;
        comp.helpButton = help.GetComponent<Button>();
        comp.backButton = back.GetComponent<Button>();
    }

    static void BuildLeaderboard(Transform parent, Prefabs prefabs)
    {
        var screen = Screen("S36_Leaderboard", parent, null);

        var title = Text("Title", screen.transform, "Xếp hạng", 24, Color.white, TextAnchor.MiddleCenter);
        Center(title, 0, 200); Size(title, 600, 30);

        var zooTab = Button("ZooTab", screen.transform, Primary, 160, 38);
        Center(zooTab, -90, 158);
        Stretch(Text("Label", zooTab.transform, "Sở thú", 14, Dark, TextAnchor.MiddleCenter));

        var farmTab = Button("FarmTab", screen.transform, Primary, 160, 38);
        Center(farmTab, 90, 158);
        Stretch(Text("Label", farmTab.transform, "Nông trại", 14, Dark, TextAnchor.MiddleCenter));

        var list = ScrollList("RankList", screen.transform, 640, 300, 0, -40);

        var comp = screen.AddComponent<LeaderboardScreen>();
        comp.content = list;
        comp.rowPrefab = prefabs.row;
        comp.zooTabButton = zooTab.GetComponent<Button>();
        comp.farmTabButton = farmTab.GetComponent<Button>();
        comp.titleText = title.GetComponent<Text>();
    }

    static void BuildMail(Transform parent, Prefabs prefabs)
    {
        var screen = Screen("S33_Mail", parent, "Hộp thư");

        var code = InputField("GiftcodeInput", screen.transform, "Nhập mã quà tặng", -110, 150);
        Size(code, 320, 42);
        var redeem = Button("RedeemButton", screen.transform, Primary, 130, 42);
        Center(redeem, 130, 150);
        Stretch(Text("Label", redeem.transform, "Đổi mã", 15, Dark, TextAnchor.MiddleCenter));

        var claimAll = Button("ClaimAllButton", screen.transform, new Color(0.98f, 0.80f, 0.30f), 150, 38);
        Center(claimAll, 280, 150);
        Stretch(Text("Label", claimAll.transform, "Nhận tất cả", 14, Dark, TextAnchor.MiddleCenter));

        var list = ScrollList("MailList", screen.transform, 660, 300, 0, -40);
        var empty = Text("Empty", screen.transform, "Hộp thư trống", 15, new Color(1, 1, 1, 0.6f), TextAnchor.MiddleCenter);
        Center(empty, 0, -40); Size(empty, 400, 24);

        var comp = screen.AddComponent<MailScreen>();
        comp.content = list;
        comp.rowPrefab = prefabs.row;
        comp.giftcodeInput = code.GetComponent<InputField>();
        comp.redeemButton = redeem.GetComponent<Button>();
        comp.claimAllButton = claimAll.GetComponent<Button>();
        comp.emptyText = empty.GetComponent<Text>();
    }

    static void BuildAchievements(Transform parent, Prefabs prefabs)
    {
        var screen = Screen("S35_Achievements", parent, "Thành tựu & Bộ sưu tập");

        var achievementList = ScrollList("AchievementList", screen.transform, 470, 320, -230, -30);

        var summary = Text("CollectionSummary", screen.transform, "Bộ sưu tập", 15, Color.white, TextAnchor.MiddleCenter);
        Center(summary, 240, 130); Size(summary, 420, 22);

        var collection = Empty("CollectionGrid", screen.transform);
        Size(collection, 420, 290);
        Center(collection, 240, -40);
        var layout = collection.AddComponent<GridLayoutGroup>();
        layout.cellSize = new Vector2(84, 96);
        layout.spacing = new Vector2(8, 8);
        layout.constraint = GridLayoutGroup.Constraint.FixedColumnCount;
        layout.constraintCount = 4;

        var comp = screen.AddComponent<AchievementScreen>();
        comp.achievementContent = achievementList;
        comp.collectionContent = collection.transform;
        comp.rowPrefab = prefabs.row;
        comp.speciesPrefab = prefabs.speciesCard;
        comp.collectionSummaryText = summary.GetComponent<Text>();
    }

    // ---------------- Helper UI ----------------
    static GameObject Empty(string name, Transform parent)
    {
        var go = new GameObject(name, typeof(RectTransform));
        go.transform.SetParent(parent, false);
        return go;
    }

    static GameObject Image(string name, Transform parent, Color color, float w, float h)
    {
        var go = new GameObject(name, typeof(RectTransform), typeof(Image));
        go.transform.SetParent(parent, false);
        go.GetComponent<Image>().color = color;
        if (w > 0 || h > 0) Size(go, w, h);
        return go;
    }

    static GameObject Text(string name, Transform parent, string value, int size, Color color, TextAnchor anchor)
    {
        var go = new GameObject(name, typeof(RectTransform), typeof(Text));
        go.transform.SetParent(parent, false);
        var text = go.GetComponent<Text>();
        text.text = value;
        text.font = font;
        text.fontSize = size;
        text.color = color;
        text.alignment = anchor;
        text.horizontalOverflow = HorizontalWrapMode.Overflow;
        text.verticalOverflow = VerticalWrapMode.Overflow;
        text.raycastTarget = false;
        return go;
    }

    static GameObject Button(string name, Transform parent, Color color, float w, float h)
    {
        var go = new GameObject(name, typeof(RectTransform), typeof(Image), typeof(Button));
        if (parent != null) go.transform.SetParent(parent, false);
        go.GetComponent<Image>().color = color;
        go.GetComponent<Button>().targetGraphic = go.GetComponent<Image>();
        Size(go, w, h);
        return go;
    }

    static GameObject InputField(string name, Transform parent, string placeholder, float x, float y)
    {
        var go = Image(name, parent, Color.white, 340, 44);
        Center(go, x, y);
        var input = go.AddComponent<InputField>();
        input.targetGraphic = go.GetComponent<Image>();

        var text = Text("Text", go.transform, "", 15, Dark, TextAnchor.MiddleLeft);
        Stretch(text, 12, 8);
        text.GetComponent<Text>().supportRichText = false;
        var hint = Text("Placeholder", go.transform, placeholder, 15, new Color(0.6f, 0.6f, 0.6f), TextAnchor.MiddleLeft);
        Stretch(hint, 12, 8);

        input.textComponent = text.GetComponent<Text>();
        input.placeholder = hint.GetComponent<Text>();
        return go;
    }

    static Transform ScrollList(string name, Transform parent, float w, float h, float x, float y)
    {
        var root = Image(name, parent, new Color(0, 0, 0, 0.15f), w, h);
        Center(root, x, y);
        var scroll = root.AddComponent<ScrollRect>();
        root.AddComponent<RectMask2D>();

        var viewport = Empty("Viewport", root.transform);
        Stretch(viewport);
        var content = Empty("Content", viewport.transform);
        var crt = content.GetComponent<RectTransform>();
        crt.anchorMin = new Vector2(0, 1);
        crt.anchorMax = new Vector2(1, 1);
        crt.pivot = new Vector2(0.5f, 1);
        crt.anchoredPosition = Vector2.zero;
        crt.sizeDelta = new Vector2(0, 0);

        var layout = content.AddComponent<VerticalLayoutGroup>();
        layout.spacing = 6;
        layout.padding = new RectOffset(8, 8, 8, 8);
        layout.childForceExpandHeight = false;
        layout.childControlHeight = false;
        layout.childForceExpandWidth = true;
        layout.childControlWidth = true;
        var fitter = content.AddComponent<ContentSizeFitter>();
        fitter.verticalFit = ContentSizeFitter.FitMode.PreferredSize;

        scroll.viewport = viewport.GetComponent<RectTransform>();
        scroll.content = crt;
        scroll.horizontal = false;
        scroll.movementType = ScrollRect.MovementType.Clamped;
        return content.transform;
    }

    static Button CloseButton(Transform parent)
    {
        var go = Button("CloseButton", parent, new Color(0.9f, 0.6f, 0.6f), 34, 34);
        var rt = go.GetComponent<RectTransform>();
        rt.anchorMin = rt.anchorMax = new Vector2(1, 1);
        rt.pivot = new Vector2(1, 1);
        rt.anchoredPosition = new Vector2(-6, -6);
        Stretch(Text("Label", go.transform, "X", 16, Dark, TextAnchor.MiddleCenter));
        return go.GetComponent<Button>();
    }

    static void Size(GameObject go, float w, float h)
    {
        go.GetComponent<RectTransform>().sizeDelta = new Vector2(w, h);
    }

    static void Center(GameObject go, float x, float y)
    {
        var rt = go.GetComponent<RectTransform>();
        rt.anchorMin = rt.anchorMax = rt.pivot = new Vector2(0.5f, 0.5f);
        rt.anchoredPosition = new Vector2(x, y);
    }

    static void Stretch(GameObject go) { Stretch(go, 0, 0); }

    static void Stretch(GameObject go, float padX, float padY)
    {
        var rt = go.GetComponent<RectTransform>();
        rt.anchorMin = Vector2.zero;
        rt.anchorMax = Vector2.one;
        rt.pivot = new Vector2(0.5f, 0.5f);
        rt.offsetMin = new Vector2(padX, padY);
        rt.offsetMax = new Vector2(-padX, -padY);
    }
}
