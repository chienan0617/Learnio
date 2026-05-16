# Learnio 數據結構與存儲規範 (DATA_STRUCTURE.md)

本文件詳述了 Learnio App 的數據存儲機制、模型架構以及持久化邏輯，幫助開發者理解數據如何在應用中流動與保存。

---

## 1. 持久化層級 (Persistence Layer)

Learnio 使用 **Hive** 作為主要的核心數據庫。Hive 是一個輕量級、極速的鍵值對 (Key-Value) 數據庫，特別適合 Flutter 應用。

### 核心特性：
- **強類型**: 透過 `HiveAdapter` 實現對象序列化。
- **加密與安全性**: Box 名稱經過加密處理（見 `lib/core/database.dart` 中的 `transferKey`）。
- **延遲加載**: 對於大數據量使用 `LazyBox` 以節省內存。

---

## 2. 數據庫組織 (Database Organization)

系統中的數據被拆分為多個「Box」（類似於數據表），由 `lib/core/data.dart` 和 `lib/script/controller/data/data_controller.dart` 統一管理。

### 2.1 系統級 Box
| Box 名稱 | 職責 | 存儲內容 |
| :--- | :--- | :--- |
| `app` | 全域應用狀態 | 使用者設定、主題模式 (Dark/Light)、API 配置、初始引導狀態。 |
| `recycle-bin` | 回收站機制 | 已刪除項目的元數據 (`DeletedItem`)，用於實現撤銷或恢復功能。 |

### 2.2 業務邏輯 Box
| Box 名稱 | 職責 | 關聯模型 |
| :--- | :--- | :--- |
| `conversations` | 對話歷史 | `Conversation` (內含 `List<ChatMessage>`) |
| `projects` | 專案管理 | `Project` (用於歸納對話、學習筆記等) |
| `learning_items` | 學習庫 | `LearningItem` (保存的知識點、收藏的內容) |

---

## 3. 核心數據模型 (Data Models)

所有模型定義於 `lib/script/types/`。

### 3.1 對話架構 (Chat Architecture)
- **`Conversation`**: 
    - 唯一標識符 `id`
    - 標題 `title`
    - **`List<ChatMessage>`**: 直接嵌套存儲該對話下的所有訊息。
    - 模型資訊 `modelName`
    - 關聯專案 `projectId`
    - 時間戳 `createdAt`, `updatedAt`

- **`ChatMessage`**:
    - 角色 `role`: `user` (使用者), `assistant` (AI), `system` (系統指令)。
    - 內容 `content`: Markdown 格式文字。
    - 附件: `images`, `files`, `links`。
    - 狀態標記: `isFavorite` (收藏), `isError` (錯誤訊息)。

### 3.2 組織與學習
- **`Project`**:
    - 專案名稱、描述、顏色。
    - 用於將多個相關的對話或學習項群組化。
- **`LearningItem`**:
    - 用於存儲使用者從對話中提取或手動輸入的學習內容。
    - 支持標籤 (Tags) 管理。

---

## 4. 數據流轉邏輯 (Data Flow)

### 4.1 讀取流程
`UI` -> `DataController` -> `Database (Hive Box)` -> `Model Object` -> `UI (Stream/ValueNotifier)`

### 4.2 寫入與更新流程
1. 使用者在 UI 發起操作（如：發送訊息）。
2. `ChatController` 創建或更新 `Conversation` 對象。
3. 調用 `DataController.saveConversation()`。
4. `Database` wrapper 執行 `box.put(id, value)`。
5. Hive 自動觸發監聽器或通過 `rebuild` 機制刷新介面。

---

## 5. 開發建議與注意事項

- **更新模型**: 如果修改了 `lib/script/types/` 中的模型，必須運行指令：
  `dart run build_runner build` 以更新 `.g.dart` 序列化檔案。
- **TypeId 管理**: 每個 `@HiveType` 必須有唯一的 `typeId`（目前範圍在 48-55 之間），請勿重複以免數據損壞。
- **大數據優化**: 由於 `Conversation` 內嵌了所有訊息，若單個對話過長（如超過 1000 條），建議檢查內存佔用。未來可考慮將訊息拆分為獨立的 Box 存儲。
- **數據導出**: 可調用 `DatabaseExporter.exportAllDataToJson()` 進行數據備份或調試。
