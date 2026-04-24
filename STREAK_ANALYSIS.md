# Daily Streak Logic & UI Analysis

## 1. **PRIMARY FIELD TRACKING STREAK: `currentDay`**

### Database Storage Location
```
Firebase Realtime Database
└── streaks
    └── {userId}
        ├── currentDay: 1-7 (PRIMARY FIELD)
        ├── lastLoginDate: "2026-04-23T00:00:00.000Z"
        ├── totalDays: 7
        └── updatedAt: "2026-04-23T15:30:00.000Z"
```

**Primary Field:** `currentDay` (Integer: 0-7)
- **0** = No streak / Broken streak
- **1-6** = Ongoing streak
- **7** = Completed cycle
- **Resets to 1** on day 8 of consecutive login

---

## 2. **DATA FLOW: Database → Model → UI**

```
┌─────────────────────────┐
│  FIREBASE DATABASE      │
│  streaks/{userId}       │
│                         │
│  currentDay: 5          │
│  lastLoginDate: date    │
└────────────┬────────────┘
             │ read()
             ▼
┌─────────────────────────┐
│  StreakModel            │
│                         │
│  - currentDay: 5        │ ◄── PRIMARY PROPERTY
│  - totalDays: 7         │
│  - title: string        │
│                         │
│  Getters:               │
│  - isComplete           │ ◄── currentDay >= totalDays (7)
│  - isBroken             │ ◄── currentDay == 0
│  - rewardCoins          │
└────────────┬────────────┘
             │
             ▼ pass to UI
┌─────────────────────────────────────────────┐
│         STREAK CARD UI                      │
│                                             │
│  1. Progress Bar (7 segments)               │
│     └─ segments_filled = currentDay         │
│                                             │
│  2. Day Counter Text                        │
│     └─ "Day 5/7" ◄── Uses currentDay       │
│                                             │
│  3. Status Messages                         │
│     └─ "Full week complete!" ◄── isComplete│
│     └─ "Login to start streak!" ◄── isBroken
│                                             │
│  4. Fire Icon (Always visible)              │
│     └─ Color: Orange/Red                    │
└─────────────────────────────────────────────┘
```

---

## 3. **UI DISPLAY MAPPING**

### Progress Bar (7 Segments)
```dart
// In UI Build Method
Row(
  children: List.generate(streak.totalDays, (i) {
    final done = i < streak.currentDay;  // ◄── KEY LINE
    return Container(
      decoration: BoxDecoration(
        gradient: done ? AppColors.primaryGradient : null,
        color: done ? null : Colors.white.withValues(alpha: 0.15),
      ),
    );
  }),
),
```

**Logic:**
- **currentDay = 1** → 1 segment filled (index 0 < 1)
- **currentDay = 5** → 5 segments filled (indices 0-4 < 5)
- **currentDay = 7** → 7 segments filled (indices 0-6 < 7)
- **currentDay = 0** → 0 segments filled (no index < 0)

---

### Day Counter Text
```dart
Text(
  isBroken
      ? '—/${streak.totalDays}'
      : 'Day ${streak.currentDay}/${streak.totalDays}',
),
```

**Display Examples:**
| currentDay | Text Shown | Status |
|-----------|-----------|--------|
| 0 | —/7 | Broken streak (not started) |
| 1 | Day 1/7 | First day |
| 5 | Day 5/7 | Middle of streak |
| 7 | Day 7/7 | Full week complete |

---

### Status Messages
```dart
if (isComplete) // ◄── currentDay >= 7
  Text('Full week complete! Keep it going 🎉')
else if (isBroken) // ◄── currentDay == 0
  Text('Login today to start a new streak!')
```

---

## 4. **HOW CURRENTDAY CHANGES**

### Scenario 1: First Login Ever
```
Database BEFORE: (empty)
       ↓ StreakLogic.onLogin()
Database AFTER:  currentDay: 1
       ↓
UI shows: Day 1/7 + 1 filled segment
```

### Scenario 2: Day 1 → Day 2 (Consecutive Login)
```
Database BEFORE: currentDay: 1, lastLoginDate: 2026-04-22
       ↓ User logs in on 2026-04-23 (day 2)
       ↓ onLogin() logic checks:
         - lastDateOnly (2026-04-22) == yesterday ✓
         - currentDay < 7 (1 < 7) ✓
         - INCREMENT: currentDay = 1 + 1 = 2
Database AFTER:  currentDay: 2, lastLoginDate: 2026-04-23
       ↓
UI shows: Day 2/7 + 2 filled segments
```

### Scenario 3: Day 7 → Day 8 (Cycle Complete)
```
Database BEFORE: currentDay: 7, lastLoginDate: 2026-04-28
       ↓ User logs in on 2026-04-29 (day 8)
       ↓ onLogin() logic checks:
         - lastDateOnly (2026-04-28) == yesterday ✓
         - currentDay >= 7 (7 >= 7) ✓
         - RESET: currentDay = 1
         - SET: justCompletedCycle = true
         - SHOW REWARD DIALOG
Database AFTER:  currentDay: 1, lastLoginDate: 2026-04-29
       ↓
UI shows: Day 1/7 + 1 filled segment + REWARD DIALOG
```

### Scenario 4: Missed Days (Skip to Day 4)
```
Database BEFORE: currentDay: 3, lastLoginDate: 2026-04-20
       ↓ User logs in on 2026-04-23 (skipped 2 days)
       ↓ onLogin() logic checks:
         - lastDateOnly (2026-04-20) != yesterday ✗
         - MISSED DAYS: currentDay = 1
Database AFTER:  currentDay: 1, lastLoginDate: 2026-04-23
       ↓
UI shows: Day 1/7 + 1 filled segment + "Login to start new streak!"
```

---

## 5. **COMPLETE UI UPDATE PROCESS**

```
User Opens App
    ↓
StreakCard._init() called
    ↓
    ├─ If triggerLoginOnInit:
    │   ├─ Call StreakLogic.onLogin()
    │   ├─ Read currentDay from DB
    │   ├─ Apply streak logic (increment/reset)
    │   └─ UPDATE: currentDay in DB
    │
    └─ Otherwise:
        └─ Call StreakLogic.load()
            └─ Read currentDay from DB (no changes)
    ↓
setState(() => _streak = result.streak)
    ↓
build() re-renders with NEW currentDay
    ├─ Progress bar: segments = currentDay
    ├─ Day counter: "Day {currentDay}/7"
    ├─ Status message: based on isComplete/isBroken
    └─ UI UPDATES!
```

---

## 6. **DEBUGGING: HOW TO VERIFY**

### Check Database Value
```dart
await StreakLogic.debugCheckDatabaseValue();
```

**Output:**
```
═══════════════════════════════════════════════
🔍 [DEBUG] STREAK DATABASE VALUES:
   currentDay: 5 (Expected: 1-7)
   lastLoginDate: 2026-04-22T00:00:00.000Z
   totalDays: 7 (Expected: 7)
   updatedAt: 2026-04-23T15:30:00.000Z
═══════════════════════════════════════════════
```

### Check UI Update
Look for logs in Flutter DevTools:
```
✅ StreakCard: onLogin() completed. currentDay: 5
🎨 StreakCard: UI updated with currentDay: 5
```

### Manual Refresh from Database
```dart
// Call from somewhere with context:
_streakCardState.refreshStreakFromDatabase();
```

---

## 7. **SUMMARY TABLE**

| Field Name | Storage | Type | Range | Purpose |
|-----------|---------|------|-------|---------|
| **currentDay** | Firebase DB | int | 0-7 | **Tracks current day in streak** |
| lastLoginDate | Firebase DB | String (ISO) | Date | Determines if streak breaks |
| totalDays | Firebase DB | int | 7 | Total days in a cycle |
| updatedAt | Firebase DB | String (ISO) | DateTime | Timestamp tracking |
| isComplete | Computed | bool | - | currentDay >= totalDays |
| isBroken | Computed | bool | - | currentDay == 0 |

---

## 8. **KEY INSIGHTS**

✅ **`currentDay` is the ONLY field that determines UI display**

- Fills progress bar (N segments for day N)
- Shows day counter text
- Triggers status messages
- Determines reward eligibility

✅ **`lastLoginDate` enables streak logic**

- Compares with today to check if consecutive
- If not yesterday → resets currentDay to 1
- If yesterday → increments currentDay
- If same day → no change

✅ **UI is ALWAYS synchronized with currentDay**

- On every load/login: read currentDay from DB
- setState() triggers UI rebuild
- UI renders based on currentDay value
- No stale data issues

---

## 9. **POTENTIAL ISSUES & FIXES**

### Issue: UI doesn't update when logging in
**Cause:** currentDay wasn't updated in Firebase
**Fix:** Ensure onLogin() saves to Firebase before returning

### Issue: Streak shows day 0 instead of day 1
**Cause:** currentDay is 0 (broken streak)
**Fix:** Check if lastLoginDate is null or currentDay is 0, set to 1

### Issue: UI shows correct day but wrong segments
**Cause:** Comparison logic error in progress bar
**Current Logic:** `final done = i < streak.currentDay;` ✓ Correct
- For Day 3: indices 0,1,2 < 3 → 3 segments filled ✓

