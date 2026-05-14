# Learnio 聊天邏輯架構與 API 設計指南 (BACKEND_GUIDELINE.md)

本文件專注於 **聊天處理 (Chat Handling)** 的核心架構設計。它定義了後端應如何接收、處理並回傳數據，以配合 Learnio 前端的串流與多模態機制。

---

## 1. 聊天處理管道 (The Chat Pipeline)

後端應被視為一個 **「數據轉化層」**。其核心任務是將 Learnio 的通用結構轉化為 LLM (如 Gemini/GPT) 的特定格式，並將 LLM 的原始串流轉化為 Learnio 前端可解析的 SSE 格式。

### 邏輯流程圖
`Frontend` -> `POST /chat` -> `Context Parser` -> `LLM Call` -> `Stream Transformer` -> `SSE Response` -> `Frontend`

---

## 2. 數據傳輸架構 (Data Flow Architecture)

### 2.1 請求階段 (Request Handling)
前端送出的 `messages` 列表是累積的對話上下文。後端必須處理以下邏輯：

1. **多模態解析 (Multimodal Processing)**:
   - 檢查最後一則 `user` 訊息是否包含 `images` 陣列。
   - 若有，後端需將其轉換為 LLM 接受的內容區塊 (Inline Data)。
2. **上下文控制 (Context Window)**:
   - 後端應實施「滑動窗口」或「Token 限制」。若對話過長，後端負責裁切較早的訊息，確保不超過模型限制。
3. **系統指令注入 (System Prompt Injection)**:
   - 後端應在發送給 LLM 前，自動注入隱藏的 `system` 指令（例如：要求 AI 回傳 Markdown 格式）。

### 2.2 回傳階段 (Response Architecture)
Learnio 前端使用自定義的串流解析器。後端的回傳架構應分為 **「中間片段」** 與 **「最終包裹」**。

#### A. 中間片段 (The Chunks)
用於即時顯示文字。格式必須嚴格遵守：
```text
data: {"text": "正在生成..."}
```

#### B. 特殊元數據注入 (Metadata Injection)
若觸發了特定邏輯（如 `special` 元素或 `color` 變化），建議在串流的 **最後一個片段** 之前或之中傳送完整 JSON：
```json
data: {
  "text": "這是最後一段文字",
  "color": "#D580FF",
  "special": true
}
```

---

## 3. 核心數據結構範例 (Implementation Details)

### 3.1 請求轉換範例 (以 Gemini 為例)
**前端輸入**:
```json
{
  "messages": [{"role": "user", "content": "你好", "images": ["base64..."]}]
}
```
**後端轉化後傳給 LLM**:
```json
{
  "contents": [{
    "role": "user",
    "parts": [
      {"text": "你好"},
      {"inline_data": {"mime_type": "image/jpeg", "data": "base64..."}}
    ]
  }]
}
```

### 3.2 串流轉換邏輯 (Stream Transformation)
後端不應直接轉發 LLM 的原始回應，應進行包裹。

**LLM 原始輸出**: `"Hello"`
**後端轉換輸出**: `data: {"text": "Hello"}`

---

## 4. 特殊場景處理架構 (Edge Cases)

| 場景 | 後端處理邏輯 | 前端預期行為 |
| :--- | :--- | :--- |
| **超長文本** | 後端執行內容摘要或自動截斷舊上下文 | 無感延續對話 |
| **圖片過大** | 後端在轉發給 LLM 前執行圖片壓縮/縮放 | 降低請求延遲 |
| **敏感詞過濾** | 後端檢測到敏感內容，中斷 LLM 呼叫，直接回傳 `isError: true` | 顯示紅色錯誤警告 |
| **模型不穩定** | 後端捕獲 Exception，回傳 `data: Error: [訊息]` | 顯示重試按鈕 |

---

## 5. 設計建議：無狀態 vs 有狀態 (Stateless vs Stateful)

Learnio 目前採用 **無狀態設計 (Stateless)**：
- **優點**: 後端不需要數據庫來存儲對話 Session，所有上下文由前端 `messages` 帶入。
- **後端責任**: 確保每次 POST 請求都能獨立完成與 LLM 的完整交互。

---

## 6. 最終回應檢查清單 (Final Payload Checklist)

為了確保前端 UI 正常運作，後端輸出的 JSON 片段應包含：
- [ ] `text`: (String) Markdown 格式的文字。
- [ ] `color`: (String, 可選) HEX 顏色碼。
- [ ] `special`: (Boolean, 可選) 觸發特殊視覺效果。
- [ ] `done`: (Boolean) 當 `data: [DONE]` 傳出前，最後一包應可包含此標記。
