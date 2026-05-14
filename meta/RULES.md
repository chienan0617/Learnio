# Learnio 專案開發規範 (RULES.md)

本文件定義了 Learnio 專案的目錄結構、代碼組織方式以及美學規範，旨在保持代碼的高度一致性與開發效率。

## 1. 目錄結構與職責

### `lib/pages/` (UI 層)
- **職責**: 負責介面的呈現、佈局與使用者交互。
- **規則**: 
    - 頁面應保持為「宣告式」(Declarative)，邏輯運算應交給對應的 Controller。
    - 優先使用 `lib/core/widgets.dart` 中封裝的函數式組件（如 `text()`, `row()`, `column()`, `box()`）。
    - 僅供特定頁面使用的私有組件應放在該目錄下的 `widgets/` 資料夾中。
    - **位置範例**: `lib/pages/root/chat/chat_page.dart`

### `lib/script/controller/` (邏輯管理層)
- **職責**: 處理業務邏輯、維護應用狀態、執行異步操作。
- **規則**:
    - 透過 `onStateChanged` 或 `VoidCallback` 通知 UI 更新。
    - 禁止在 Controller 內直接進行複雜的 UI 佈局。
    - 必須保持邏輯的可測試性與獨立性。
    - **位置範例**: `lib/script/controller/chat/chat_controller.dart`

### `lib/script/types/` (數據模型層)
- **職責**: 定義數據結構 (Models)。
- **規則**:
    - 使用 Hive 進行持久化，需包含 `@HiveType` 註解並執行 `build_runner` 生成 `.g.dart`。
    - 包含簡單的 Getters (如 `preview`, `timeLabel`)，但不應包含業務邏輯。
    - **位置範例**: `lib/script/types/conversation.dart`

### `lib/core/` (核心框架層)
- **職責**: 存放全域配置、樣式標記、系統級封裝。
- **關鍵檔案**:
    - `base.dart`: 專案的匯入中心 (Barrel file)。
    - `design_system.dart`: 定義 Spacing, Radius, Typography (如 `tsBodyLarge`)。
    - `theme.dart`: 提供全域配色 Getters (如 `primary`, `tx1`, `bg2`)。
    - `widgets.dart`: 提供極簡化的 UI 組件包裝函數。
    - `rebuild.dart`: 全域狀態刷新註冊機制。

---

## 2. 代碼開發規範

### 匯入慣例 (Import Standards)
- **絕對優先**: 所有檔案應優先匯入 `package:learnio/base.dart`。
- **禁止**: 除非必要，否則避免在頁面檔案中直接匯入大量的 `package:flutter/material.dart` 或其他 core 內的細分檔案。

### 狀態管理模式
- **局部狀態**: 使用 `setState()` 或 `AnimatedSwitcher`。
- **邏輯狀態**: 在 Controller 中定義 `onStateChanged`，UI 於 `initState` 中註冊回調並執行 `setState`。
- **跨頁面刷新**: 使用 `Rebuild.register('key', ...)` 與 `rebuild('key')` 進行跨組件刷新。

### UI 開發慣例
- **間距**: 嚴格遵守 `DesignSystem.space[N]`（如 `DesignSystem.space16`），禁止直接填入字面量數字。
- **圓角**: 使用 `DesignSystem.border[S/M/L/XL]`。
- **文字**: 使用 `lib/core/design_system.dart` 中預定義的 `TextStyle`（如 `tsTitleLarge`, `tsBodyMedium`）。
- **顏色**: 使用 `theme.dart` 中的變數（如 `tx1` 代表主要文字，`bg1` 代表主要背景），以確保深色模式自動適應。

---

## 3. UI 設計美學要求

- **現代感**: 使用柔和的漸層 (`LinearGradient`)、適度的陰影 (`DesignSystem.shadowSoft`)。
- **交互反饋**: 所有可點擊元件（`inkWell`, `IconButton`）必須包含觸覺反饋 `HapticFeedback.lightImpact()`。
- **簡約風格**: 保持介面清爽，避免過度擁擠。

## 4. 安全與品質

- **外科手術式修改**: 僅修改要求的代碼，不隨意重構無關區域。
- **錯誤處理**: 使用 `core/exception.dart` 中定義的異常類別。
- **Debug**: 使用 `Debug.log()` 進行帶有時間戳記的日誌輸出。

---

> [!CAUTION]
> 修改 `lib/core/` 下的檔案可能會影響全域，請務必謹慎並確保向下相容。
