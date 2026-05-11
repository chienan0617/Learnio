# 🎮 LevelMap 集成指南

## 📦 文件清單

新的關卡地圖系統包含以下文件：

```
lib/pages/root/level_map/
├── level_map.dart                 # ✅ 新主文件（已更新）
├── level_map_components.dart      # ✨ 可選擴展組件
├── infinite_level_map.dart        # ⚠️ 已棄用（備份+export新文件）
└── DESIGN.md                      # 📖 設計文檔
```

---

## 🚀 快速開始

### 1. 導航到關卡地圖

在你的導航或按鈕處理中：

```dart
import 'package:learnio/pages/root/level_map/level_map.dart';

// 導航到新的關卡地圖
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => const LevelMapPage(),
  ),
);
```

### 2. 基本顯示

`LevelMapPage` 會自動配置：

- ✅ 深色背景｜漸層
- ✅ 毛玻璃頂部導航欄
- ✅ 無限滾動加載（每次 24 個關卡）
- ✅ S形路徑（2 個關卡/行）
- ✅ 解鎖狀態管理

---

## 🎨 自定義選項

### 修改初始参数

編輯 `level_map.dart` 中的 \_LevelMapPageState：

```dart
class _LevelMapPageState extends State<LevelMapPage> {
  // 修改這些值來自定義

  int _totalLevels = 24;              // 初始加載的關卡數
  static const int unlockedUpTo = 7;  // 已解鎖到第 7 關
  static const int levelsPerRow = 2;  // 每行 2 個關卡

  // 無限加載時的增量
  void _onScroll() {
    if (pos.pixels >= pos.maxScrollExtent - 400) {
      setState(() => _totalLevels += 24); // 每次增加 24 個
    }
  }
}
```

### 修改視覺樣式

#### 改變關卡氣泡顏色

在 `LevelBubble` 的 build 方法中：

```dart
if (isCurrent) {
  bgColor = const Color(0xFFFFD700);  // 當前關卡 - 改為你想要的顏色
  gradientColors = [
    const Color(0xFFFFE54C),
    const Color(0xFFFFD700),
  ];
}
```

#### 調整路徑粗細

在 `_LevelPathPainter.paint()` 中：

```dart
final paint = Paint()
  ..strokeWidth = 3.5  // 改為 2.0 更細或 5.0 更粗
  ..color = tx1.withOpacity(0.25); // 改變透明度
```

#### 修改氣泡大小

在 `LevelBubble` 中：

```dart
width: isCurrent ? 72 : 64,  // 改為喜歡的尺寸
height: isCurrent ? 72 : 64,
```

---

## ✨ 使用擴展組件

### 顯示進度統計

```dart
import 'package:learnio/pages/root/level_map/level_map_components.dart';

// 在 _LevelMapPageState 的 build() 方法中
positioned(
  LevelStatsCard(
    totalLevelsCleared: unlockedUpTo,
    currentLevel: unlockedUpTo + 1,
    totalLevels: _totalLevels,
  ),
  t: mq.padding.top + 70,
  l: 20,
  r: 20,
);
```

### 添加章節標題

```dart
// 在 ListView.builder 中
if (rowIndex == 0) {
  return Column(
    children: [
      LevelChapterHeader(
        chapterNumber: 1,
        chapterName: '新手教程',
        description: '學習基本玩法',
      ),
      // 然後是 LevelRow...
    ],
  );
}
```

### 顯示難度指示

```dart
// 作為 LevelBubble 的補充顯示
if (isUnlocked) {
  return Column(
    children: [
      LevelBubble(...),
      SizedBox(height: 8),
      LevelDifficultyBadge(difficulty: 2),
    ],
  );
}
```

---

## 🎯 常見需求

### Q: 如何連接真實的關卡數據？

A: 修改 `LevelMapPage` 以從數據庫讀取：

```dart
class _LevelMapPageState extends State<LevelMapPage> {
  late List<LevelData> levels;

  @override
  void initState() {
    super.initState();
    _loadLevels();
  }

  void _loadLevels() async {
    // 從你的數據庫讀取
    levels = await getLevelsFromDatabase();
    setState(() => _totalLevels = levels.length);
  }

  // 然後在 LevelBubble 中使用真實數據
  isUnlocked: levels[index].isUnlocked,
  isCurrent: levels[index].id == currentLevelId,
}
```

### Q: 如何添加點擊事件？

A: 修改 `LevelBubble` 的 GestureDetector：

```dart
return GestureDetector(
  onTap: isUnlocked || isCurrent
      ? () {
          // 你的邏輯
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LevelGamePage(levelId: level),
            ),
          );
        }
      : null,
  child: ...,
);
```

### Q: 如何自定義上方導航欄？

A: 編輯 `_buildTopBar()` 方法：

```dart
Widget _buildTopBar() {
  return buildGlass(
    color: bg2.withOpacity(0.4),
    blur: 20,
    radius: 28,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: row([
        text('🗺️ 關卡地圖', 18, fw8, tx1),
        const Spacer(),
        // 添加你自己的按鈕
        _topBarItem(Icons.favorite, () => print('收藏')),
        _topBarItem(Icons.share, () => print('分享')),
      ]),
    ),
  );
}
```

---

## 🔧 調試模式

### 顯示調試信息

```dart
// 在 LevelBubble 中
if (System.debugMode) {
  print('Level: $level, Unlocked: $isUnlocked, Current: $isCurrent');
}
```

### 測試不同的解鎖狀態

```dart
// 暫時改變 unlockedUpTo 的值
static const int unlockedUpTo = 15;  // 測試更多解鎖關卡
```

---

## 📊 性能最佳化

### 1. 列表渲染優化

目前使用 `ListView.builder`，已自動優化。如需進一步優化：

```dart
ListView.builder(
  controller: _scrollController,
  cacheExtent: 1000, // 預加載範圍
  itemCount: totalRows,
  itemBuilder: ...,
)
```

### 2. 圖像優化

如果使用背景圖片，確保格式正確：

```dart
decoration: BoxDecoration(
  image: DecorationImage(
    image: AssetImage('assets/level_map_bg.webp'), // 使用 webp 格式
    fit: BoxFit.cover,
  ),
)
```

---

## 🎬 下一步

1. **集成關卡邏輯** - 連接你的遊戲引擎
2. **添加聲音效果** - 點擊時播放 SFX
3. **實現成就系統** - 使用 `LevelRewardDisplay`
4. **優化動畫** - 為氣泡添加入場動畫
5. **支持多語言** - 翻譯標題和描述

---

## 🆘 故障排除

### 問題：氣泡不顯示顏色

✅ 檢查 `primary` 顏色是否正確定義在 theme 中

### 問題：路徑綫條不平順

✅ 調整 `_LevelPathPainter` 的貝塞爾曲線參數

### 問題：滾動不流暢

✅ 減少 `_totalLevels` 的初始值，或檢查 GPU 渲染設置

### 問題：頂部欄模糊效果不工作

✅ 確保 `buildGlass` 函數可用（在 core/share.dart 中）
