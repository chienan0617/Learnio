# Learnio 系統使用指南 (HOW_TOUSE.md)

歡迎來到 Learnio 專案。本文件旨在幫助開發者快速理解整個系統的運作方式、架構設計以及開發流程。

---

## 1. 系統概觀 (System Overview)

Learnio 是一個「學習導向的 AI 聊天 App」。其核心目標是提供一個簡潔、現代且高效的學習與對話環境。系統設計強調**邏輯與 UI 分離**、**高度一致的視覺語言**以及**開發效率**。

---

## 2. 核心架構 (Architecture)

系統採用嚴格的分層架構，確保代碼的可維護性：

- **Core (核心框架層)**: `lib/core/`
    - 提供全域配置、樣式標記（Spacing, Radius, Typography）以及系統級封裝。
    - 關鍵檔案：`design_system.dart` (Token), `theme.dart` (配色), `widgets.dart` (UI 簡化函數)。
- **Data (數據模型層)**: `lib/script/types/`
    - 定義數據結構（Models），使用 Hive 進行持久化儲存。
- **Logic (邏輯管理層)**: `lib/script/controller/`
    - 處理業務邏輯、維護應用狀態。Controller 不應包含 UI 佈局。
- **UI (介面呈現層)**: `lib/pages/`
    - 負責介面渲染與使用者交互，應保持宣告式 (Declarative)。

---

## 3. 開發規範與準則

在開始開發前，請務必詳細閱讀以下文檔：

1.  **[RULES.md](./RULES.md)**: 定義目錄職責、代碼組織方式與 UI 開發慣例。
2.  **[LAWS.md](./LAWS.md)**: 開發行為準則，強調「先思考後動手」、「保持簡潔」與「外科手術式修改」。
3.  **[DESIGN.md](./DESIGN.md)**: 視覺語言規範，確保所有頁面的一致性。

---

## 4. 關鍵組件與使用方式

### 4.1 統一匯入 (The Barrel File)
為了簡化匯入，專案使用 `lib/base.dart` 作為匯入中心。
**原則**：開發時應優先匯入 `package:learnio/base.dart`。

### 4.2 簡化 UI 函數 (Functional Widgets)
在 `lib/core/widgets.dart` 中定義了大量簡化 UI 構建的函數：
- `text(msg, ...)`: 快速創建符合設計系統的文字。
- `row([...])`, `column([...])`: 簡化的佈局組件。
- `box(w, h, c)`: 帶有尺寸的容器。
- `inkWell(v, fn)`: 帶有觸覺反饋的點擊組件。

### 4.3 顏色與主題 (Theme System)
專案支持深色/淺色模式，配色定義在 `meta/prompt.txt` 中。
使用方式：
- 透過 `theme.dart` 的 Getters 獲取顏色，如 `primary`, `tx1` (主要文字), `bg1` (主要背景)。
- 系統會自動根據 `Data.app.get("dark_mode")` 切換色彩。

### 4.4 狀態刷新機制 (Rebuild System)
除了標準的 `setState`，專案提供了一套全域刷新機制 `lib/core/rebuild.dart`：
- `Rebuild.register('key', () => setState(() {}))`: 在 UI 中註冊刷新。
- `rebuild('key')`: 在邏輯層觸發特定組件的刷新。

---

## 5. Metadata 目錄指南

`meta/` 目錄存放了系統的「靈魂」與配置：

- `DESIGN.md`: UI/UX 的憲法。
- `RULES.md`: 開發者的作業手冊。
- `LAWS.md`: 核心價值觀與思維準則。
- `models.json`: 系統支持的 AI 模型配置。
- `prompt.txt`: 主題色彩與設計 Token 的原始定義。
- `common_command.txt`: 常用的開發指令（如 `build_runner`, `flutter clean`）。
- `INTEGRATION_GUIDE.md`: 特定複雜功能（如 `LevelMap`）的集成指南。

---

## 6. 常用開發流程 (Workflows)

### 6.1 新增頁面
1. 在 `lib/pages/` 下創建目錄與頁面檔案。
2. 在 `lib/script/controller/` 下創建對應的 Controller。
3. 在頁面的 `initState` 中連接 Controller 的 `onStateChanged`。

### 6.2 修改數據模型
1. 修改 `lib/script/types/` 中的 Model。
2. 執行 `dart run build_runner build` 生成 `.g.dart` 檔案。

### 6.3 調整視覺樣式
1. 優先修改 `meta/prompt.txt` 或 `lib/core/design_system.dart` 以確保全域生效。

---

> [!TIP]
> 始終保持代碼的對稱性與簡約。如果你發現需要寫大量的重複代碼，請檢查 `lib/core/` 是否已有對應的封裝。
