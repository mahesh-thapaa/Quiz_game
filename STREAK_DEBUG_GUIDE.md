# Streak Progress Bar Debugging Guide

## Issue: currentDay = 3 in database, but UI shows 0 bars

## Step-by-Step Debugging

### 1. **Check Flutter Logs** (Most Important)
Open Flutter DevTools console and look for these log patterns:

```
🎨 [BUILD] StreakCard rendering:
   → Using [DEFAULT|LOADED] streak model
   → currentDay: [VALUE]
```

**Expected output if working:**
```
✅ StreakCard._init(): Loaded from database. currentDay: 3
🔄 StreakCard._init(): Calling setState with currentDay=3
🎨 [BUILD] StreakCard rendering:
   → Using LOADED streak model
   → currentDay: 3
   → Segments to fill: 3 / 7
      Segment 0: 🟪 FILLED
      Segment 1: 🟪 FILLED
      Segment 2: 🟪 FILLED
      Segment 3: ⬜ EMPTY
      ...
```

**If showing DEFAULT (problem case):**
```
🎨 [BUILD] StreakCard rendering:
   → Using DEFAULT streak model
   → currentDay: 0
```

### 2. **Check Database Load Logs**
Look for:
```
📖 StreakLogic.load(): Reading from Firebase path: streaks/{userId}
✅ StreakLogic.load(): Successfully loaded from database
   → Raw data keys: [...]
   → Raw currentDay value: 3 (type: int)
   → Parsed currentDay: 3
```

**Possible Issues:**
- ❌ If you see: `❌ StreakLogic.load(): No streak data in database` → Database is empty
- ❌ If you see: `Raw currentDay value: "3" (type: String)` → Value is stored as STRING, not INT
- ❌ If you see: `Raw currentDay value: null` → Field doesn't exist

### 3. **Check setState() Calls**
Look for:
```
🔄 StreakCard._init(): Calling setState with currentDay=3
✅ StreakCard._init(): setState() called. UI rebuild should occur with currentDay: 3
```

**If missing:**
- ❌ `❌ StreakCard._init(): Widget not mounted` → Race condition
- ❌ No setState log at all → _init() never completed

### 4. **Visual Check in UI**
Look at the progress bar area. Count the bars:

| currentDay | Expected |
|-----------|----------|
| 0 | ⬜⬜⬜⬜⬜⬜⬜ (0 filled) |
| 1 | 🟪⬜⬜⬜⬜⬜⬜ (1 filled) |
| 3 | 🟪🟪🟪⬜⬜⬜⬜ (3 filled) |
| 7 | 🟪🟪🟪🟪🟪🟪🟪 (7 filled) |

---

## Most Likely Causes

### Cause 1: Default Model Still Being Displayed
**Symptom:** Logs show `Using DEFAULT streak model` with `currentDay: 0`

**Solutions:**
1. Check if _init() is being called at all
2. Check if onLogin()/load() is throwing an error (look for ❌ logs)
3. Check if setState() is being called

### Cause 2: Database Value Not Being Read Correctly
**Symptom:** Logs show `Raw currentDay value: "3" (type: String)`

**Fix:** The value is stored as a string, need to convert:
```dart
// Current code (may fail if value is string):
final currentDay = data['currentDay'] as int? ?? 0;

// Better code (handles both):
final currentDay = int.tryParse(data['currentDay'].toString()) ?? 0;
```

### Cause 3: Progress Bar Rendering Issue
**Symptom:** currentDay shows 3 in logs, but no bars visible in UI

**Check:**
- Are any bars visible at all?
- Are the empty bars visible (light gray)?
- Is `AppColors.primaryGradient` correctly defined?

---

## Quick Fix to Try

If you need immediate confirmation that bars should show:

1. **Test with hardcoded value:** Temporarily change in streak_card.dart:
```dart
// In build():
final testStreak = StreakModel(
  title: 'TEST',
  currentDay: 3,  // Force to 3
  totalDays: 7,
);
// Then render with testStreak instead of streak
```

2. **Check if bars appear:** If bars appear with hardcoded value = progress bar rendering is fine
   - Problem is with loading/setState

---

## What Each Log Means

| Log | Meaning |
|-----|---------|
| `Using DEFAULT streak model` | Showing initial state (not loaded yet) |
| `Using LOADED streak model` | Successfully loaded from database |
| `currentDay: 0 / 7` | Could be default OR broken streak |
| `currentDay: 3 / 7` | Streak is on day 3 |
| `Segment 0: 🟪 FILLED` | Bar 0 is colored (will show as gradient) |
| `Segment 0: ⬜ EMPTY` | Bar 0 is gray (will show as light gray) |

---

## Action Items

1. ✅ **Open Flutter DevTools console**
2. ✅ **Hot restart the app (or fully close and reopen)**
3. ✅ **Check the logs for the patterns above**
4. ✅ **Share the logs in DevTools console**
5. ✅ **Share what "Using [DEFAULT|LOADED]" message shows**

This will help identify exactly where the issue is!
