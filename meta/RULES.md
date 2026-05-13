# Game Hub 專案開發規範 (RULES.md)

本文件定義了 Game Hub 專案的目錄結構、程式碼組織方式以及開發規範，旨在保持代碼的一致性與可維護性。

## 1. 目錄結構與職責

### `lib/pages/` (UI 層)
- **職責**: 負責所有介面的呈現與佈局。
- **規則**: 
    - 頁面應保持「宣告式」(Declarative)，儘量減少複雜的邏輯運算。
    - 每個頁面通常對應一個 `Controller` 來處理交互邏輯。
    - 大型頁面應拆分為多個小組件，若組件僅供該頁面使用，可放在該頁面目錄下的 `widgets/` 資料夾中。
    - **位置範例**: `lib/pages/root/games/sudoku.dart`

### `lib/script/controller/` (邏輯層 / Controller)
- **職責**: 處理業務邏輯、遊戲狀態管理、事件分發。
- **規則**:
    - 每個遊戲或主要功能模組應有自己的子資料夾（如 `sudoku/`, `2048/`）。
    - 邏輯應與 UI 分離。Controller 透過 `onStateChanged` 或具體的動畫回呼 (Callbacks) 通知 UI 更新。
    - 遊戲的演算法（如解題器 Solver）應放在對應的 Controller 目錄下。
    - **位置範例**: `lib/script/controller/sudoku/controller.dart`

### `lib/script/types/` (數據層 / Models)
- **職責**: 定義數據模型 (Data Transfer Objects)。
- **規則**:
    - 使用 Hive 進行數據持久化，需包含 `.g.dart` 生成檔案。
    - 模型應專注於數據結構，不應包含複雜的 UI 或業務邏輯。
    - **位置範例**: `lib/script/types/sudoku.dart`

### `lib/core/` (核心配置層)
- **職責**: 存放全域配置、樣式定義、底層封裝。
- **規則**:
    - `colors.dart`: 定義專案的主色調與配色方案。
    - `system.dart`: 系統級別的設定（如震動、語言）。
    - `widgets.dart`: 全域通用的基礎 UI 組件。

---

## 2. 邏輯與組件分離規範 (Widget vs Logic)

### Widget (介面組件)
- 寫在 `lib/pages/` 下。
- **準則**: 只負責「怎麼顯示」。
- **操作**: 呼叫 `controller.method()`，並在回呼中呼叫 `setState()` 或使用 `AnimationController` 播放動畫。

### Logic (業務邏輯)
- 寫在 `lib/script/controller/` 下。
- **準則**: 只負責「做什麼」以及「數據如何變化」。
- **禁止**: Controller 內禁止直接引入 `material.dart` 進行 UI 佈局，應透過回呼通知 UI。

---

## 3. 代碼風格與慣例

- **匯入規範**: 優先匯入 `package:game_hub/base.dart`。它包含了大部分常用的 Flutter 核心庫與專案基礎組件，能有效減少 Import 區塊的長度。
- **命名規範**: 
    - 檔案名：`snake_case.dart`
    - 類別名：`UpperCamelCase`
    - 變數與函式：`lowerCamelCase`
- **動畫處理**: 
    - 遊戲中的微動畫（如抖動、彈跳）建議封裝在 `AnimationMixin` 中，並透過 Controller 的 Callback 觸發。

## 4. UI 設計美學要求

- **質感**: 優先使用「玻璃擬態」(Glassmorphism) 與柔和的漸層色 (Gradients)。
- **反饋**: 所有的按鈕點擊應有觸覺反饋 (Haptic Feedback) 與微小的縮放動畫。
- **配色**: 避免使用過於單純的紅、藍、綠，應使用 `CommonColors` 中定義的調和色。

---

> [!IMPORTANT]
> 在開發新功能時，請先檢查 `lib/core/` 中是否已有現成的組件或工具，避免重複造輪子。
