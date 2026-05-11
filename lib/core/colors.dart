import 'package:learnio/base.dart';

class CommonColors {
  static late List<Color> colors;

  @initial
  static Future<void> initialize() async {
    colors = (await FileHandle.getAndSaveCache(
      "colors",
      "colors",
    )).cast<String>().map((e) => hexColor(e)).toList().cast<Color>();
  }

  static final List<Color> selectedColor20 = [
    hexColor("#55efc4"),
    hexColor("#81ecec"),
    hexColor("#74b9ff"),
    hexColor("#a29bfe"),
    hexColor("#dfe6e9"),
    hexColor("#00b894"),
    hexColor("#00cec9"),
    hexColor("#0984e3"),
    hexColor("#6c5ce7"),
    hexColor("#b2bec3"),
    hexColor("#ffeaa7"),
    hexColor("#fab1a0"),
    hexColor("#ff7675"),
    hexColor("#fd79a8"),
    hexColor("#636e72"),
    hexColor("#fdcb6e"),
    hexColor("#e17055"),
    hexColor("#d63031"),
    hexColor("#e84393"),
    hexColor("#2d3436"),
  ];

  static final success = darkMode ? hexColor("#10B981") : hexColor("#059669");
  static final successSoft = darkMode
      ? hexColor("#064E3B")
      : hexColor("#D1FAE5");

  // 錯誤 (Error/Danger)
  static final error = darkMode ? hexColor("#EF4444") : hexColor("#DC2626");
  static final errorSoft = hexColor("#FEE2E2");
  //darkMode ? hexColor("#450A0A") :
  // 警告 (Warning)
  static final warning = darkMode ? hexColor("#F59E0B") : hexColor("#D97706");
  static final warningSoft = darkMode
      ? hexColor("#451A03")
      : hexColor("#FEF3C7");

  // 資訊 (Info)
  static final info = darkMode ? hexColor("#0EA5E9") : hexColor("#0284C7");
  static final infoSoft = darkMode ? hexColor("#0C4A6E") : hexColor("#E0F2FE");

  // ---------------------------------------------------------
  // 輔助裝飾色 (Accent / Decorative)
  // ---------------------------------------------------------
  static final accentPurple = hexColor("#8B5CF6");
  static final accentPink = hexColor("#EC4899");
  static final accentTeal = hexColor("#14B8A6");
  static final accentAmber = hexColor("#F59E0B");

  static final List<Color> midToneNeutralSpectrumColor = [
    // -----------------------------------------------------------
    // 1. Reddish Earth Tones (紅/乾燥玫瑰) - 中等明度
    // -----------------------------------------------------------
    hexColor("#E6B0AA"), // rose-300
    hexColor("#D98880"), // rose-500
    hexColor("#CD6155"), // rose-600
    hexColor("#C0392B"), // red-700 (偏深，但仍在中間範圍)
    // -----------------------------------------------------------
    // 2. Orange/Brown Tones (橘/陶土與杏色) - 中等明度
    // -----------------------------------------------------------
    hexColor("#FAE5D3"), // apricot-200 (偏淺，作為基礎色)
    hexColor("#F0B27A"), // terra-500 (陶土橘)
    hexColor("#E59866"), // terra-600
    hexColor("#D35400"), // brown-700 (偏深，但在中間範圍)
    // -----------------------------------------------------------
    // 3. Yellow/Khaki Tones (黃/燕麥與芥末) - 中等明度
    // -----------------------------------------------------------
    hexColor("#F9E79F"), // beige-300
    hexColor("#F4D03F"), // mustard-500 (柔和芥末黃)
    hexColor("#D4AC0D"), // mustard-600
    hexColor("#B7950B"), // mustard-700
    // -----------------------------------------------------------
    // 4. Green Tones (綠/鼠尾草與苔蘚) - 中等明度
    // -----------------------------------------------------------
    hexColor("#D1F2EB"), // mint-200 (偏淺，作為基礎色)
    hexColor("#A3E4D7"), // sage-400 (鼠尾草綠)
    hexColor("#76D7C4"), // sage-500
    hexColor("#48C9B0"), // teal-600
    // -----------------------------------------------------------
    // 5. Cyan/Aqua Tones (青/迷霧與深松) - 中等明度
    // -----------------------------------------------------------
    hexColor("#B2DFDB"), // aqua-300
    hexColor("#80CBC4"), // ocean-500 (海洋青)
    hexColor("#4DB6AC"), // ocean-600
    hexColor("#26A69A"), // pine-700 (偏深，但在中間範圍)
    // -----------------------------------------------------------
    // 6. Blue Tones (藍/霧霾與丹寧) - 中等明度
    // -----------------------------------------------------------
    hexColor("#D4E6F1"), // mist-200 (偏淺，作為基礎色)
    hexColor("#A9CCE3"), // denim-400 (丹寧藍)
    hexColor("#7FB3D5"), // denim-500
    hexColor("#5499C7"), // blue-600
    // -----------------------------------------------------------
    // 7. Purple/Violet Tones (紫/香芋與紫藕) - 中等明度
    // -----------------------------------------------------------
    hexColor("#E8DAEF"), // lavender-200 (偏淺，作為基礎色)
    hexColor("#D2B4DE"), // plum-400 (紫藕色)
    hexColor("#BB8FCE"), // plum-500
    hexColor("#A569BD"), // violet-600
    // -----------------------------------------------------------
    // 8. Achromatic Neutrals (灰/冷灰與岩石) - 中等明度
    // -----------------------------------------------------------
    hexColor("#CCD1D1"), // grey-300
    hexColor("#B2BABB"), // grey-400
    hexColor("#99A3A4"), // grey-500
    hexColor("#7F8C8D"), // grey-600
  ];

  // ignore: unused_element, unused_field
  static final List<Color> _colors = [
    hexColor('#F3EAC6'), // 曙光米 Daybreak
    hexColor('#F6F1D3'), // 淡奶油 Pale Cream
    hexColor('#DFDAD8'), // 被動灰 Passive
    hexColor('#FFF2EF'), // 柔和桃 Soft Peach
    hexColor('#FAD6D6'), // 嬰兒粉 Baby Pink
    hexColor('#FFE2CC'), // 杏仁色 Apricot
    hexColor('#FFDAC1'), // 淺杏橘 Light Apricot
    hexColor('#FCE1E4'), // 粉香檳 Pink Champagne
    hexColor('#F6CED8'), // 玫瑰石 Rose Quartz
    hexColor('#F1C6D4'), // 腮紅粉 Blush Pink
    hexColor('#E6C0B3'), // 粉黏土 Blush Clay
    hexColor('#D8BCC5'), // 粉石英 Carnelian
    hexColor('#D2B1A3'), // 溫暖褐 Warm Taupe
    hexColor('#C5B0A0'), // 曬樹褐 Tanbark
    hexColor('#B6A29A'), // 石灰輝 Stone Gray
    hexColor('#DECBAA'), // 杏仁牛奶 Almond Milk
    hexColor('#D3B88C'), // 砂岩 Sandstone
    hexColor('#E0B75E'), // 晨光金 Sundew
    hexColor('#D9A24E'), // 稻草黃 Straw Harvest
    hexColor('#A16B47'), // 古銅棕 Burnt Sienna
    hexColor('#B17B5C'), // 粘土棕 Clay Brown
    hexColor('#8F5A3C'), // 摩卡 Mocha
    hexColor('#6C3E2A'), // 咖啡豆 Coffee Bean
    hexColor('#554C4A'), // 深棕褐 Dark Auburn
    hexColor('#A82E33'), // 熱情紅 Heartthrob
    hexColor('#FF6F61'), // 柔珊瑚 Muted Coral
    hexColor('#A9B8D3'), // 天際藍 Skyline
    hexColor('#C1E5F2'), // 法國海岸 French Coast
    hexColor('#B0D0D3'), // 粉藍 Powder Blue
    hexColor('#A1C6C8'), // 海風藍 Ocean Breeze
    hexColor('#B2DFE4'), // 湖水藍 Aqua Tone
    hexColor('#A2D8D0'), // 海泡綠 Seafoam
    hexColor('#ACCFCB'), // 微風綠 Breeze Green
    hexColor('#CDEDEA'), // 冰薄荷 Ice Mint
    hexColor('#AED9E0'), // 薄霧藍 Mist Blue
    hexColor('#93A8AC'), // 灰藍 Dusty Blue
    hexColor('#3D4D5C'), // 工業藍 Industrial Blue
    hexColor('#5B6C7D'), // 灰藍灰 Dust Blue
    hexColor('#3A5A8A'), // 升藍 Upward
    hexColor('#1E90FF'), // 道奇藍 Dodger Blue
    hexColor('#00BFFF'), // 深天藍 Deep Sky Blue
    hexColor('#D6D6D6'), // 淺水泥 Light Cement
    hexColor('#C0C0C0'), // 銀霧 Silver Mist
    hexColor('#A0A0A0'), // 陶土灰 Studio Clay
    hexColor('#A8A8A8'), // 晨霧灰 Foggy Morning
    hexColor('#B4B8B1'), // 鼠尾草綠 Sage Green
    hexColor('#A3B1A8'), // 苔蘚灰 Moss Gray
    hexColor('#7E9485'), // 橄欖綠 Olive Green
    hexColor('#597B71'), // 深苔綠 Deep Moss
    hexColor('#449F7F'), // 森林綠 Forest Green
    hexColor('#66CDAA'), // 中水綠 Aquamarine
    hexColor('#83C8B0'), // 水波綠 Watery
    hexColor('#A8D5BA'), // 霜葉綠 Frosted Leaf
    hexColor('#D1E2B8'), // 晨霧綠 Dawn Mist
    hexColor('#D4E8B3'), // 芹菜綠 Celery
    hexColor('#BCCCE0'), // 淡薰衣草 Mist Lavender
    hexColor('#EADCF6'), // 淡紫 Lilac Light
    hexColor('#C9C2E1'), // 淺薰衣草 Lite Lavender
    hexColor('#BFA2CC'), // 欣悅紫 Euphoric Lilac
    hexColor('#D8B7DD'), // 迷霧紫 Lilac Haze
    hexColor('#6A4C8C'), // 深梅紫 Deep Plum
    hexColor('#8C8E9F'), // 暮色藍 Twilight Blue
    hexColor('#4B3F3F'), // 木炭 Charcoal
  ];

  // 科技與酷炫 (Tech & Cyber)
  // 科技與酷炫 (Tech & Cyber) - 修改後：色調更統一，減少極端對比
  static final List<Color> cyberpunk = [
    hexColor("#08D9D6"), // 青
    hexColor("#00B2B2"),
    hexColor("#252A34"), // 深灰藍
    hexColor("#FF2E63"), // 桃紅
    hexColor("#A239CA"), // 紫
  ];
  static final List<Color> deepDark = [
    hexColor("#1A1A2E"),
    hexColor("#16213E"),
    hexColor("#0F3460"),
    hexColor("#533483"),
    hexColor("#E94560"),
  ];
  static final List<Color> aurora = [
    hexColor("#4E6E81"),
    hexColor("#2E4F4F"),
    hexColor("#0E8388"),
    hexColor("#CBE4DE"),
    hexColor("#2C3333"),
  ];
  static final List<Color> modernAI = [
    hexColor("#14213D"),
    hexColor("#000000"),
    hexColor("#E5E5E5"),
    hexColor("#FCA311"),
    hexColor("#FFFFFF"),
  ];

  // 自然與大地 (Nature & Earthy) - 修改後：過渡更自然
  static final List<Color> deepForest = [
    hexColor("#0B3D01"),
    hexColor("#1B5E20"),
    hexColor("#388E3C"),
    hexColor("#66BB6A"),
    hexColor("#A5D6A7"),
  ];
  static final List<Color> desertSunset = [
    hexColor("#D35400"),
    hexColor("#E67E22"),
    hexColor("#F39C12"),
    hexColor("#F5B041"),
    hexColor("#F8C471"),
  ];
  static final List<Color> oceanDeep = [
    hexColor("#012A4A"),
    hexColor("#013A63"),
    hexColor("#01497C"),
    hexColor("#014F86"),
    hexColor("#2A6F97"),
  ];
  static final List<Color> autumnLeaf = [
    hexColor("#641E16"),
    hexColor("#922B21"),
    hexColor("#C0392B"),
    hexColor("#D98880"),
    hexColor("#E6B0AA"),
  ];
  static final List<Color> morningMist = [
    hexColor("#E8F3F1"),
    hexColor("#D1E8E4"),
    hexColor("#B8D8D8"),
    hexColor("#91B2C7"),
    hexColor("#729D39").withOpacity(0.5), // 這裡建議用相近的藍灰色系
    hexColor("#76949F"),
  ];

  // 復古與懷舊 (Retro & Vintage) - 修改後：降低飽和度，增加高級感
  static final List<Color> retro80s = [
    hexColor("#E91E63"),
    hexColor("#9C27B0"),
    hexColor("#673AB7"),
    hexColor("#3F51B5"),
    hexColor("#2196F3"),
  ];
  static final List<Color> vintageFilm = [
    hexColor("#434343"),
    hexColor("#666666"),
    hexColor("#999999"),
    hexColor("#BDBDBD"),
    hexColor("#E0E0E0"),
  ];
  static final List<Color> oldNewspaper = [
    hexColor("#795548"),
    hexColor("#8D6E63"),
    hexColor("#A1887F"),
    hexColor("#BCAAA4"),
    hexColor("#D7CCC8"),
  ];
  static final List<Color> midCentury = [
    hexColor("#264653"),
    hexColor("#2A9D8F"),
    hexColor("#E9C46A"),
    hexColor("#F4A261"),
    hexColor("#E76F51"),
  ];

  // 粉嫩與馬卡龍 (Pastel & Soft) - 修改後：讓它們處於同一明度區間
  static final List<Color> strawberryMilk = [
    hexColor("#FFB7B2"),
    hexColor("#FFDAC1"),
    hexColor("#E2F0CB"),
    hexColor("#B5EAD7"),
    hexColor("#C7CEEA"),
  ];
  static final List<Color> dreamyCloud = [
    hexColor("#D4F1F4"),
    hexColor("#A2D5F2"),
    hexColor("#B9E1DC"),
    hexColor("#F3D1F4"),
    hexColor("#E8F9FD"),
  ];
  static final List<Color> lilacGarden = [
    hexColor("#E0BBE4"),
    hexColor("#957DAD"),
    hexColor("#D291BC"),
    hexColor("#FEC8D8"),
    hexColor("#FFDFD3"),
  ];
  static final List<Color> softMint = [
    hexColor("#D1F2EB"),
    hexColor("#A3E4D7"),
    hexColor("#76D7C4"),
    hexColor("#48C9B0"),
    hexColor("#1ABC9C"),
  ];

  // 專業與商務 (Corporate & Professional)
  static final List<Color> elegantGrey = [
    hexColor("#212529"),
    hexColor("#343A40"),
    hexColor("#495057"),
    hexColor("#6C757D"),
    hexColor("#ADB5BD"),
  ];
  static final List<Color> trustyNavy = [
    hexColor("#0D1B2A"),
    hexColor("#1B263B"),
    hexColor("#415A77"),
    hexColor("#778DA9"),
    hexColor("#E0E1DD"),
  ];
  static final List<Color> minimalistBW = [
    hexColor("#121212"),
    hexColor("#2C2C2C"),
    hexColor("#4F4F4F"),
    hexColor("#828282"),
    hexColor("#BDBDBD"),
  ];
  static final List<Color> techTeal = [
    hexColor("#006D77"),
    hexColor("#83C5BE"),
    hexColor("#EDF6F9"),
    hexColor("#FFDDD2"),
    hexColor("#E29578"),
  ];

  // 鮮艷與活力 (Vibrant & Energetic) - 修改後：雖然鮮艷但符合漸層規律
  static final List<Color> tropicalFruit = [
    hexColor("#FF9F1C"),
    hexColor("#FFBF69"),
    hexColor("#FFE5B4"),
    hexColor("#CBF3F0"),
    hexColor("#2EC4B6"),
  ];
  static final List<Color> energyPunch = [
    hexColor("#D90429"),
    hexColor("#EF233C"),
    hexColor("#EDF2F4"),
    hexColor("#8D99AE"),
    hexColor("#2B2D42"),
  ];
  static final List<Color> neonParty = [
    hexColor("#3F37C9"),
    hexColor("#4361EE"),
    hexColor("#4895EF"),
    hexColor("#4CC9F0"),
    hexColor("#7209B7"),
  ];

  // 特別風格 (Special Styles)
  static final List<Color> nordic = [
    hexColor("#2E3944"),
    hexColor("#475569"),
    hexColor("#64748B"),
    hexColor("#94A3B8"),
    hexColor("#CBD5E1"),
  ];
  static final List<Color> luxuryRose = [
    hexColor("#6D597A"),
    hexColor("#B56576"),
    hexColor("#E56B6F"),
    hexColor("#EAAC8B"),
    hexColor("#F7D1CD"),
  ];
  static final List<Color> coffeeBreak = [
    hexColor("#4B3832"),
    hexColor("#854442"),
    hexColor("#BE9B7B"),
    hexColor("#FFF4E6"),
    hexColor("#3C2F2F"),
  ];
  static final List<Color> matchaBean = [
    hexColor("#3A5A40"),
    hexColor("#588157"),
    hexColor("#A3B18A"),
    hexColor("#DAD7CD"),
    hexColor("#344E41"),
  ];
  static final List<Color> sakuraSeason = [
    hexColor("#FFB7C5"),
    hexColor("#FFC0CB"),
    hexColor("#FFD1DC"),
    hexColor("#FFE4E1"),
    hexColor("#FFF0F5"),
  ];
  static final List<Color> morandi = [
    hexColor("#918E85"),
    hexColor("#A0937D"),
    hexColor("#B6AD90"),
    hexColor("#C6AC8F"),
    hexColor("#D5BDAF"),
  ];
  static final List<Color> spaceOrbit = [
    hexColor("#03071E"),
    hexColor("#370617"),
    hexColor("#6A040F"),
    hexColor("#9D0208"),
    hexColor("#D00000"),
  ];
  static final List<Color> fairytale = [
    hexColor("#FAD0C4"),
    hexColor("#FFD1FF"),
    hexColor("#E0C3FC"),
    hexColor("#B9FBC0"),
    hexColor("#CFBAF0"),
  ];

  static final List<List<Color>> allTheme = [
    cyberpunk,
    deepDark,
    aurora,
    modernAI,
    deepForest,
    desertSunset,
    oceanDeep,
    autumnLeaf,
    morningMist,
    retro80s,
    vintageFilm,
    oldNewspaper,
    midCentury,
    strawberryMilk,
    dreamyCloud,
    lilacGarden,
    softMint,
    elegantGrey,
    trustyNavy,
    minimalistBW,
    techTeal,
    tropicalFruit,
    energyPunch,
    neonParty,
    nordic,
    luxuryRose,
    coffeeBreak,
    matchaBean,
    sakuraSeason,
    morandi,
    spaceOrbit,
    fairytale,
  ];

  static final List<List<Color>> allThemes = [
    // 1. 科技與酷炫 (Tech & Cyber)
    [
      hexColor("#05D9E8"),
      hexColor("#005678"),
      hexColor("#01012B"),
      hexColor("#FF2A6D"),
      hexColor("#D1F7FF"),
    ],
    [
      hexColor("#121212"),
      hexColor("#1F1B24"),
      hexColor("#332940"),
      hexColor("#BB86FC"),
      hexColor("#03DAC6"),
    ],
    [
      hexColor("#2E3440"),
      hexColor("#4C566A"),
      hexColor("#88C0D0"),
      hexColor("#A3BE8C"),
      hexColor("#EBCB8B"),
    ],
    [
      hexColor("#000000"),
      hexColor("#1A1A1A"),
      hexColor("#4A90E2"),
      hexColor("#FFFFFF"),
      hexColor("#F5F5F5"),
    ],

    // 2. 自然與大地 (Nature & Earthy)
    [
      hexColor("#1B3022"),
      hexColor("#236940"),
      hexColor("#439A86"),
      hexColor("#BCD8C1"),
      hexColor("#E7EFC5"),
    ],
    [
      hexColor("#F28123"),
      hexColor("#D34E24"),
      hexColor("#563F32"),
      hexColor("#E8B0AF"),
      hexColor("#F1E0C5"),
    ],
    [
      hexColor("#012A4A"),
      hexColor("#013A63"),
      hexColor("#2C7DA0"),
      hexColor("#89C2D9"),
      hexColor("#A9D6E5"),
    ],
    [
      hexColor("#5E2C04"),
      hexColor("#A73E10"),
      hexColor("#D96C06"),
      hexColor("#EEBA0B"),
      hexColor("#F3DE8A"),
    ],
    [
      hexColor("#D8E2DC"),
      hexColor("#FFE5D9"),
      hexColor("#FFCAD4"),
      hexColor("#F4ACB7"),
      hexColor("#9D8189"),
    ],

    // 3. 復古與懷舊 (Retro & Vintage)
    [
      hexColor("#FF00FF"),
      hexColor("#00FFFF"),
      hexColor("#FFFF00"),
      hexColor("#702283"),
      hexColor("#000000"),
    ],
    [
      hexColor("#353535"),
      hexColor("#3C6E71"),
      hexColor("#FFFFFF"),
      hexColor("#D9D9D9"),
      hexColor("#284B63"),
    ],
    [
      hexColor("#6B705C"),
      hexColor("#A5A58D"),
      hexColor("#B7B7A4"),
      hexColor("#FFE8D6"),
      hexColor("#D4A373"),
    ],
    [
      hexColor("#264653"),
      hexColor("#2A9D8F"),
      hexColor("#E9C46A"),
      hexColor("#F4A261"),
      hexColor("#E76F51"),
    ],

    // 4. 粉嫩與馬卡龍 (Pastel & Soft)
    [
      hexColor("#FFADAD"),
      hexColor("#FFD6A5"),
      hexColor("#FDFFB6"),
      hexColor("#CAFFBF"),
      hexColor("#9BFBC0"),
    ],
    [
      hexColor("#A0C4FF"),
      hexColor("#BDB2FF"),
      hexColor("#FFC6FF"),
      hexColor("#FFFFFC"),
      hexColor("#9BFBC0"),
    ],
    [
      hexColor("#E0BBE4"),
      hexColor("#957DAD"),
      hexColor("#D291BC"),
      hexColor("#FEC8D8"),
      hexColor("#FFDFD3"),
    ],
    [
      hexColor("#F7FFF7"),
      hexColor("#34A0A4"),
      hexColor("#1A759F"),
      hexColor("#1E6091"),
      hexColor("#184E77"),
    ],

    // 5. 專業與商務 (Corporate & Professional)
    [
      hexColor("#212529"),
      hexColor("#343A40"),
      hexColor("#495057"),
      hexColor("#ADB5BD"),
      hexColor("#DEE2E6"),
    ],
    [
      hexColor("#001D3D"),
      hexColor("#003566"),
      hexColor("#FFC300"),
      hexColor("#FFD60A"),
      hexColor("#000814"),
    ],
    [
      hexColor("#000000"),
      hexColor("#333333"),
      hexColor("#666666"),
      hexColor("#999999"),
      hexColor("#FFFFFF"),
    ],
    [
      hexColor("#006D77"),
      hexColor("#83C5BE"),
      hexColor("#EDF6F9"),
      hexColor("#FFDDD2"),
      hexColor("#E29578"),
    ],

    // 6. 鮮艷與活力 (Vibrant & Energetic)
    [
      hexColor("#FF9F1C"),
      hexColor("#FFBF69"),
      hexColor("#FFFFFF"),
      hexColor("#CBF3F0"),
      hexColor("#2EC4B6"),
    ],
    [
      hexColor("#E63946"),
      hexColor("#F1FAEE"),
      hexColor("#A8DADC"),
      hexColor("#457B9D"),
      hexColor("#1D3557"),
    ],
    [
      hexColor("#39FF14"),
      hexColor("#FF3131"),
      hexColor("#FFF01F"),
      hexColor("#1F51FF"),
      hexColor("#BC13FE"),
    ],

    // 7. 特別風格 (Special Styles)
    [
      hexColor("#2E3944"),
      hexColor("#124E66"),
      hexColor("#748D92"),
      hexColor("#D3D9D4"),
      hexColor("#212A31"),
    ],
    [
      hexColor("#6D597A"),
      hexColor("#B56576"),
      hexColor("#E56B6F"),
      hexColor("#EAAC8B"),
      hexColor("#355070"),
    ],
    [
      hexColor("#432818"),
      hexColor("#99582A"),
      hexColor("#BB9457"),
      hexColor("#FFE6A7"),
      hexColor("#6F1D1B"),
    ],
    [
      hexColor("#606C38"),
      hexColor("#283618"),
      hexColor("#FEFAE0"),
      hexColor("#DDA15E"),
      hexColor("#BC6C25"),
    ],
    [
      hexColor("#FFB7C5"),
      hexColor("#FF99AC"),
      hexColor("#FAE1DF"),
      hexColor("#E2C2C6"),
      hexColor("#907F9F"),
    ],
    [
      hexColor("#918E85"),
      hexColor("#A0937D"),
      hexColor("#B6AD90"),
      hexColor("#C6AC8F"),
      hexColor("#5E503F"),
    ],
    [
      hexColor("#0B3D91"),
      hexColor("#191970"),
      hexColor("#4B0082"),
      hexColor("#000000"),
      hexColor("#FFFFFF"),
    ],
    [
      hexColor("#FFCAD4"),
      hexColor("#F4ACB7"),
      hexColor("#9D8189"),
      hexColor("#FFE5D9"),
      hexColor("#D8E2DC"),
    ],
  ];

  static final List<Color> allColors = allThemes
      .expand((palette) => palette)
      .toList(growable: false)
      .cast<Color>();
  //hexColor('#6495ED') Cornflower Blue

  // 中藍系：hexColor('#4682B4') Steel Blue

  // 深藍系：hexColor('#00008B') Dark Blue
}

List<Color> colors = CommonColors.colors;

Color randomColor([int? seed]) {
  Random random = seed == null ? Random() : Random(seed);

  return Color.fromRGBO(
    random.nextInt(255),
    random.nextInt(255),
    random.nextInt(255),
    255,
  );
}
