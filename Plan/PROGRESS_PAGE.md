# Progress Feature Implementation Plan                                                                                      
                                                                                                                              
  ## Overview                                                                                                                 
                                                                                                                              
  Create a Progress screen with a "Rainbow Sun" visualization showing daily goal completion, plus a historical calendar       
  view.                                                                                                                       
                                                                                                                              
  ## Requirements Summary                                                                                                     
                                                                                                                              
  - **Rainbow Sun**: Ball grows with goals completed (max ~50% screen width), 17 SDG-colored rays extend to screen edges for  
  completed SDG categories                                                                                                    
  - **Daily Target**: First-time picker (1-10), stored in user profile                                                        
  - **Calendar**: Monthly view with completion balls sized by progress, scrollable to past months                             
                                                                                                                              
  ---                                                                                                                         
                                                                                                                              
  ## Implementation Steps                                                                                                     
                                                                                                                              
  ### 1. Update AppUserModel                                                                                                  
                                                                                                                              
  **File:** `lib/features/auth/data/models/app_user_model.dart`                                                               
                                                                                                                              
  Add field:                                                                                                                  
  ```dart                                                                                                                     
  int? dailyGoalTarget,  // null = needs setup, 1-10 = user's target                                                          
  ```                                                                                                                         
                                                                                                                              
  ### 2. Create Progress Feature Structure                                                                                    
                                                                                                                              
  ```                                                                                                                         
  lib/features/progress/                                                                                                      
  ├── progress.dart                     # Barrel file                                                                         
  ├── data/                                                                                                                   
  │   ├── datasources/                                                                                                        
  │   │   └── daily_summary_remote_datasource.dart                                                                            
  │   ├── models/                                                                                                             
  │   │   └── daily_summary_model.dart  # Freezed model                                                                       
  │   └── repositories/                                                                                                       
  │       └── progress_repository.dart                                                                                        
  ├── domain/                                                                                                                 
  │   └── entities/                                                                                                           
  │       └── calendar_day_data.dart    # UI model (not persisted)                                                            
  └── presentation/                                                                                                           
      ├── providers/                                                                                                          
      │   └── progress_providers.dart   # Riverpod providers                                                                  
      ├── screens/                                                                                                            
      │   └── progress_screen.dart                                                                                            
      └── widgets/                                                                                                            
          ├── rainbow_sun_painter.dart  # CustomPainter                                                                       
          ├── rainbow_sun_widget.dart   # Animated widget                                                                     
          ├── progress_calendar.dart    # Month calendar                                                                      
          ├── calendar_day_cell.dart    # Day cell with ball                                                                  
          └── daily_target_picker.dart  # First-time setup screen                                                             
  ```                                                                                                                         
                                                                                                                              
  ### 3. Create DailySummaryModel                                                                                             
                                                                                                                              
  **Firestore path:** `users/{userId}/dailySummaries/{YYYY-MM-DD}`                                                            
                                                                                                                              
  Fields:                                                                                                                     
  - `date`: string (YYYY-MM-DD for queries)                                                                                   
  - `goalCount`: int                                                                                                          
  - `completedSdgs`: List<int> (1-17)                                                                                         
  - `totalPoints`: int                                                                                                        
  - `totalCo2Grams`: int                                                                                                      
  - `createdAt/updatedAt`: Timestamp                                                                                          
                                                                                                                              
  ### 4. Create Providers                                                                                                     
                                                                                                                              
  - `dailySummaryDataSourceProvider` - Firestore operations                                                                   
  - `progressRepositoryProvider` - Business logic                                                                             
  - `todaySummaryProvider` - Stream<DailySummaryModel?> for sun                                                               
  - `dailyGoalTargetProvider` - User's target from profile                                                                    
  - `needsDailyTargetSetupProvider` - Boolean for first-time flow                                                             
  - `selectedMonthProvider` - StateNotifier for calendar navigation                                                           
  - `monthCalendarDataProvider` - Future for calendar data                                                                    
  - `dailyTargetNotifierProvider` - AsyncNotifier to save target                                                              
                                                                                                                              
  ### 5. Implement Rainbow Sun                                                                                                
                                                                                                                              
  **RainbowSunPainter** (CustomPainter):                                                                                      
  - Ball: Radial gradient (yellow → orange), size = minRadius + (maxRadius - minRadius) * completion                          
  - Rays: 17 rays at equal angles starting from top, each ray uses SDG's official color                                       
  - Animation: Smooth transitions with AnimationController                                                                    
                                                                                                                              
  **Key logic:**                                                                                                              
  - Ball min size: 20% of max                                                                                                 
  - Ball max size: 25% of container width (half when doubled = 50%)                                                           
  - Ray angles: `startAngle + (sdgNumber - 1) * (2π / 17)`                                                                    
  - Ray endpoints: Line-rectangle intersection calculation                                                                    
                                                                                                                              
  ### 6. Implement Calendar                                                                                                   
                                                                                                                              
  **ProgressCalendar:**                                                                                                       
  - Month header with prev/next navigation                                                                                    
  - 7-column grid (Sun-Sat)                                                                                                   
  - Disable future navigation                                                                                                 
                                                                                                                              
  **CalendarDayCell:**                                                                                                        
  - Ball size: 8px + 20px * completionRatio                                                                                   
  - Ball color: Lerp from primaryContainer to primary                                                                         
  - Today: Ring indicator                                                                                                     
  - Empty days: No ball                                                                                                       
                                                                                                                              
  ### 7. Create Screens                                                                                                       
                                                                                                                              
  **DailyTargetPickerScreen** (first-time):                                                                                   
  - ListWheelScrollView for 1-10 picker                                                                                       
  - Description text based on selection                                                                                       
  - "Start My Journey" button saves to Firestore                                                                              
                                                                                                                              
  **ProgressScreen:**                                                                                                         
  - AppBar with title                                                                                                         
  - RainbowSunWidget (280px height)                                                                                           
  - Today's stats (X / Y goals)                                                                                               
  - ProgressCalendar below                                                                                                    
                                                                                                                              
  ### 8. Add Navigation Route                                                                                                 
                                                                                                                              
  **File:** `lib/app/router.dart`                                                                                             
                                                                                                                              
  Add:                                                                                                                        
  ```dart                                                                                                                     
  static const progress = '/progress';                                                                                        
                                                                                                                              
  GoRoute(                                                                                                                    
    path: AppRoutes.progress,                                                                                                 
    builder: (context, state) => const ProgressScreen(),                                                                      
  ),                                                                                                                          
  ```                                                                                                                         
                                                                                                                              
  ### 9. Integrate with Action Logging                                                                                        
                                                                                                                              
  When an action is logged, update daily summary in same transaction:                                                         
  - Increment `goalCount`                                                                                                     
  - Add new SDG numbers to `completedSdgs` (deduplicated)                                                                     
  - Add points and CO2 to totals                                                                                              
                                                                                                                              
  ---                                                                                                                         
                                                                                                                              
  ## File Modifications Summary                                                                                               
                                                                                                                              
  | File | Action |                                                                                                           
  |------|--------|                                                                                                           
  | `lib/features/auth/data/models/app_user_model.dart` | Add `dailyGoalTarget` field |                                       
  | `lib/app/router.dart` | Add progress route |                                                                              
  | `lib/core/l10n/app_en.arb` | Add localization strings |                                                                   
  | `lib/core/l10n/app_ja.arb` | Add Japanese strings |                                                                       
                                                                                                                              
  ## New Files                                                                                                                
                                                                                                                              
  | File | Purpose |                                                                                                          
  |------|---------|                                                                                                          
  | `lib/features/progress/progress.dart` | Barrel file |                                                                     
  | `lib/features/progress/data/models/daily_summary_model.dart` | Firestore model |                                          
  | `lib/features/progress/data/datasources/daily_summary_remote_datasource.dart` | Firestore operations |                    
  | `lib/features/progress/data/repositories/progress_repository.dart` | Business logic |                                     
  | `lib/features/progress/domain/entities/calendar_day_data.dart` | UI model |                                               
  | `lib/features/progress/presentation/providers/progress_providers.dart` | Riverpod providers |                             
  | `lib/features/progress/presentation/screens/progress_screen.dart` | Main screen |                                         
  | `lib/features/progress/presentation/widgets/rainbow_sun_painter.dart` | CustomPainter |                                   
  | `lib/features/progress/presentation/widgets/rainbow_sun_widget.dart` | Animated widget |                                  
  | `lib/features/progress/presentation/widgets/progress_calendar.dart` | Calendar widget |                                   
  | `lib/features/progress/presentation/widgets/calendar_day_cell.dart` | Day cell |                                          
  | `lib/features/progress/presentation/widgets/daily_target_picker.dart` | First-time picker |                               
                                                                                                                              
  ---                                                                                                                         
                                                                                                                              
  ## Verification Steps                                                                                                       
                                                                                                                              
  1. Run `dart run build_runner build --delete-conflicting-outputs` after creating Freezed/Riverpod files                     
  2. Run `flutter analyze` to check for lint errors                                                                           
  3. Test first-time user flow (picker should appear)                                                                         
  4. Test sun visualization with mock data                                                                                    
  5. Test calendar navigation (prev/next months)                                                                              
  6. Verify Firestore writes when actions are logged                                                                          
  7. Run `flutter test` for any new widget tests                                                                              
                                                                                                                              
                                                                                                                              
  If you need specific details from before exiting plan mode (like exact code snippets, error messages, or content you        
  generated), read the full transcript at:                                                                                    
  /Users/milesd/.claude/projects/-Users-milesd-GitRepos-Seed/56b327e6-a732-4234-b9bd-c41ae81dc01d.jsonl   


#### Initial prompt: 
  Let's make a progress page. It should show daily activity for the month. At the top part of the page there should be   
  a dynamic graph. It starts as a small rainbow  ball. Then as users complete goals for that day, the little lines come out   
  of the ball, one for each goal category. These rays of light go to the edge of the screen. So it looks like a rainbow sun,  
  with rainbow rays coming out. But if the user doesn't complete a goal in a category that day, then there is a no ray,       
  just the background. Also the user can set a number of goals to reach each day. The ball gets bigger with each goal, up to  
  a max size about half the width of the screen. At half width, completing more goals doesn't increase the ball size, but     
  can still add a ray if a goal of that category hadn't been completed yet that day.
  Then scrolling down, users can see a calendar view with this month, and each day they completed their target there is a     
  ball in the calendar for that day. If they only completed half of their personal target, the ball is half size. If they     
  skip a day, the calendar square is empty. The user can also scroll back to previous months 