Implement the following plan:                                                                                               
                                                                                                                              
  # Action Library & Logging Feature Implementation Plan                                                                      
                                                                                                                              
  ## Overview                                                                                                                 
  Implement the core action logging feature allowing users to log eco-friendly actions, earn points, and track their          
  sustainability habits.                                                                                                      
                                                                                                                              
  ## File Structure                                                                                                           
  ```                                                                                                                         
  lib/features/actions/                                                                                                       
  ├── actions.dart                           # Barrel file                                                                    
  ├── data/                                                                                                                   
  │   ├── datasources/                                                                                                        
  │   │   ├── action_library_remote_datasource.dart                                                                           
  │   │   └── action_log_remote_datasource.dart                                                                               
  │   ├── models/                                                                                                             
  │   │   ├── action_model.dart              # Freezed                                                                        
  │   │   └── action_log_model.dart          # Freezed                                                                        
  │   └── repositories/                                                                                                       
  │       ├── action_library_repository.dart                                                                                  
  │       └── action_log_repository.dart                                                                                      
  ├── domain/                                                                                                                 
  │   └── enums/                                                                                                              
  │       └── action_category.dart                                                                                            
  └── presentation/                                                                                                           
      ├── providers/                                                                                                          
      │   └── actions_providers.dart                                                                                          
      ├── screens/                                                                                                            
      │   ├── action_log_screen.dart                                                                                          
      │   └── action_history_screen.dart                                                                                      
      └── widgets/                                                                                                            
          ├── action_card.dart                                                                                                
          ├── action_category_tabs.dart                                                                                       
          ├── action_log_confirmation_dialog.dart                                                                             
          ├── action_log_item.dart                                                                                            
          └── points_animation_overlay.dart                                                                                   
  ```                                                                                                                         
                                                                                                                              
  ## Phase 1: Data Models                                                                                                     
                                                                                                                              
  ### 1.1 ActionCategory Enum (`domain/enums/action_category.dart`)                                                           
  - 6 categories: recycling, transport, food, energy, consumption, water                                                      
  - Map to colors from `AppColors.categoryX`                                                                                  
  - Include icon and localized display names                                                                                  
                                                                                                                              
  ### 1.2 ActionModel (`data/models/action_model.dart`)                                                                       
  ```dart                                                                                                                     
  @freezed                                                                                                                    
  abstract class ActionModel with _$ActionModel {                                                                             
    const factory ActionModel({                                                                                               
      required String id,                                                                                                     
      required String nameEn,                                                                                                 
      required String nameJa,                                                                                                 
      @Default('') String descriptionEn,                                                                                      
      @Default('') String descriptionJa,                                                                                      
      required String category,                                                                                               
      required int points,                                                                                                    
      @Default(0) int co2Grams,                                                                                               
      @Default('eco') String iconName,                                                                                        
      @Default([]) List<String> relatedSdgs,                                                                                  
      @Default(true) bool isActive,                                                                                           
      @Default(0) int sortOrder,                                                                                              
    }) = _ActionModel;                                                                                                        
  }                                                                                                                           
  ```                                                                                                                         
                                                                                                                              
  ### 1.3 ActionLogModel (`data/models/action_log_model.dart`)                                                                
  ```dart                                                                                                                     
  @freezed                                                                                                                    
  abstract class ActionLogModel with _$ActionLogModel {                                                                       
    const factory ActionLogModel({                                                                                            
      required String id,                                                                                                     
      required String actionId,                                                                                               
      required String actionName,                                                                                             
      required String category,                                                                                               
      required int points,                                                                                                    
      @Default(0) int co2Grams,                                                                                               
      @TimestampConverter() required DateTime loggedAt,                                                                       
      String? note,                                                                                                           
      @Default([]) List<String> relatedSdgs,                                                                                  
    }) = _ActionLogModel;                                                                                                     
  }                                                                                                                           
  ```                                                                                                                         
  - Import `TimestampConverter` from `auth/data/models/app_user_model.dart`                                                   
                                                                                                                              
  ## Phase 2: Data Layer                                                                                                      
                                                                                                                              
  ### 2.1 ActionLibraryRemoteDataSource                                                                                       
  - `watchActions()` → Stream from `actionLibrary` collection                                                                 
  - `getAction(id)` → Single action lookup                                                                                    
  - Query with `isActive == true`, order by `sortOrder`                                                                       
                                                                                                                              
  ### 2.2 ActionLogRemoteDataSource                                                                                           
  - `createActionLog(userId, log)` → Add to `users/{userId}/actionLog`                                                        
  - `watchUserActionLogs(userId)` → Stream ordered by `loggedAt` desc                                                         
  - `getRecentActionLogs(userId, limit)` → For home screen                                                                    
                                                                                                                              
  ### 2.3 ActionLogRepository (critical file)                                                                                 
  - `logAction()` uses Firestore transaction to:                                                                              
    1. Create action log document                                                                                             
    2. Update user `points`, `level`, `currentStreak`, `longestStreak`, `lastActionDate`                                      
  - Level calculation: `pointsPerLevel` (100) with `levelScalingFactor` (1.5)                                                 
  - Streak logic: consecutive days increment, gaps reset to 1                                                                 
                                                                                                                              
  ## Phase 3: Providers (`presentation/providers/actions_providers.dart`)                                                     
                                                                                                                              
  Following patterns from `auth_providers.dart`:                                                                              
  ```dart                                                                                                                     
  // Data sources                                                                                                             
  @riverpod ActionLibraryRemoteDataSource actionLibraryDataSource(Ref ref)                                                    
  @riverpod ActionLogRemoteDataSource actionLogDataSource(Ref ref)                                                            
                                                                                                                              
  // Repositories                                                                                                             
  @riverpod ActionLibraryRepository actionLibraryRepository(Ref ref)                                                          
  @riverpod ActionLogRepository actionLogRepository(Ref ref)                                                                  
                                                                                                                              
  // Streams                                                                                                                  
  @riverpod Stream<List<ActionModel>> actionLibrary(Ref ref)                                                                  
  @riverpod Stream<List<ActionLogModel>> userActionLogs(Ref ref)                                                              
                                                                                                                              
  // State                                                                                                                    
  @riverpod class SelectedCategory extends _$SelectedCategory  // nullable                                                    
  @riverpod List<ActionModel> filteredActions(Ref ref)                                                                        
                                                                                                                              
  // Notifier                                                                                                                 
  @riverpod class ActionLogNotifier extends _$ActionLogNotifier                                                               
    - logAction(ActionModel, note?) → AsyncValue<ActionLogModel?>                                                             
  ```                                                                                                                         
                                                                                                                              
  ## Phase 4: UI Components                                                                                                   
                                                                                                                              
  ### 4.1 ActionLogScreen (`screens/action_log_screen.dart`)                                                                  
  - AppBar with search field                                                                                                  
  - TabBar: "All" + 6 category tabs                                                                                           
  - GridView of ActionCards (2 columns)                                                                                       
  - On tap: show confirmation dialog                                                                                          
  - On success: show points animation overlay                                                                                 
                                                                                                                              
  ### 4.2 Widgets                                                                                                             
  - **ActionCard**: Icon, name, points badge, category color accent                                                           
  - **ActionCategoryTabs**: TabBar with category icons/colors                                                                 
  - **ActionLogConfirmationDialog**: Action details, optional note field, confirm button                                      
  - **PointsAnimationOverlay**: "+X points" animation that auto-dismisses                                                     
                                                                                                                              
  ### 4.3 ActionHistoryScreen (`screens/action_history_screen.dart`)                                                          
  - ListView of ActionLogItems grouped by date                                                                                
  - Each item: action name, time, points, optional note                                                                       
                                                                                                                              
  ## Phase 5: Integration                                                                                                     
                                                                                                                              
  ### 5.1 Router Update (`lib/app/router.dart`)                                                                               
  Replace placeholders at lines 98-107:                                                                                       
  ```dart                                                                                                                     
  GoRoute(                                                                                                                    
    path: AppRoutes.actionLog,                                                                                                
    builder: (context, state) => const ActionLogScreen(),                                                                     
  ),                                                                                                                          
  GoRoute(                                                                                                                    
    path: AppRoutes.actionHistory,                                                                                            
    builder: (context, state) => const ActionHistoryScreen(),                                                                 
  ),                                                                                                                          
  ```                                                                                                                         
                                                                                                                              
  ### 5.2 Barrel Export (`actions.dart`)                                                                                      
  Export models, repositories, providers, screens, key widgets                                                                
                                                                                                                              
  ## Implementation Order                                                                                                     
                                                                                                                              
  1. **ActionCategory enum** → `action_category.dart`                                                                         
  2. **ActionModel** → `action_model.dart` + run build_runner                                                                 
  3. **ActionLogModel** → `action_log_model.dart` + run build_runner                                                          
  4. **Datasources** → both datasource files                                                                                  
  5. **Repositories** → both repository files                                                                                 
  6. **Providers** → `actions_providers.dart` + run build_runner                                                              
  7. **ActionCard widget** → `action_card.dart`                                                                               
  8. **ActionCategoryTabs** → `action_category_tabs.dart`                                                                     
  9. **ActionLogConfirmationDialog** → `action_log_confirmation_dialog.dart`                                                  
  10. **PointsAnimationOverlay** → `points_animation_overlay.dart`                                                            
  11. **ActionLogScreen** → `action_log_screen.dart`                                                                          
  12. **ActionLogItem widget** → `action_log_item.dart`                                                                       
  13. **ActionHistoryScreen** → `action_history_screen.dart`                                                                  
  14. **Router update** → `router.dart`                                                                                       
  15. **Barrel file** → `actions.dart`                                                                                        
                                                                                                                              
  ## Verification                                                                                                             
                                                                                                                              
  1. Run `dart run build_runner build --delete-conflicting-outputs`                                                           
  2. Run `flutter analyze` - should pass with no errors                                                                       
  3. Run `flutter test` - existing tests should pass                                                                          
  4. Manual testing:                                                                                                          
     - Navigate to action log screen from home                                                                                
     - Verify categories display and filter correctly                                                                         
     - Log an action, verify points animation shows                                                                           
     - Check user document in Firestore for updated points/level/streak                                                       
     - Navigate to history, verify logged action appears                                                                      
                                                                                                                              
  ## Firebase Setup Required                                                                                                  
  Seed `actionLibrary` collection with actions matching `ActionPoints` values from `app_constants.dart`                       
                                                                                                                              
                                                                                                                              
  If you need specific details from before exiting plan mode (like exact code snippets, error messages, or content you        
  generated), read the full transcript at:                                                                                    
  /Users/milesd/.claude/projects/-Users-milesd-GitRepos-Seed/8138dfd1-4799-4888-8648-7e7dc144840f.jsonl   