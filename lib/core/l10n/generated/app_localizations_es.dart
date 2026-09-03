// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Seed';

  @override
  String get appTagline => 'Cultiva tus hábitos sostenibles';

  @override
  String get navHome => 'Inicio';

  @override
  String get navProgress => 'Progreso';

  @override
  String get navLogAction => 'Acción';

  @override
  String get navMascot => 'Mascota';

  @override
  String get navProfile => 'Perfil';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get authLogin => 'Iniciar sesión';

  @override
  String get authRegister => 'Registrarse';

  @override
  String get authLogout => 'Cerrar sesión';

  @override
  String get authEmail => 'Correo electrónico';

  @override
  String get authPassword => 'Contraseña';

  @override
  String get authConfirmPassword => 'Confirmar contraseña';

  @override
  String get authForgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get authContinueWithGoogle => 'Continuar con Google';

  @override
  String get authContinueWithApple => 'Continuar con Apple';

  @override
  String get authOrDivider => 'o';

  @override
  String homeWelcome(String name) {
    return '¡Bienvenido de nuevo, $name!';
  }

  @override
  String get homeLogAction => 'Registrar acción';

  @override
  String get homeRecentActions => 'Acciones recientes';

  @override
  String get homeNoActions =>
      'Aún no hay acciones registradas. ¡Comienza tu viaje!';

  @override
  String get actionLogTitle => 'Registrar una acción';

  @override
  String get actionSearchHint => 'Buscar acciones...';

  @override
  String actionLogged(int points) {
    return '¡Acción registrada! $points puntos ganados';
  }

  @override
  String get noActionsFound => 'No se encontraron acciones';

  @override
  String get actionHistoryTitle => 'Historial de acciones';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String get addNoteOptional => 'Añadir una nota (opcional)';

  @override
  String get noteHint => 'Ej.: Usé mi propia bolsa en la tienda';

  @override
  String pointsLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count puntos',
      one: '$count punto',
    );
    return '$_temp0';
  }

  @override
  String levelLabel(int level) {
    return 'Nivel $level';
  }

  @override
  String streakLabel(int days) {
    return 'Racha de $days días';
  }

  @override
  String co2Saved(String amount) {
    return '$amount CO₂ ahorrado';
  }

  @override
  String mascotName(String name) {
    return '$name';
  }

  @override
  String get mascotRename => 'Renombrar';

  @override
  String mascotEvolution(int stage) {
    return 'Etapa de evolución $stage';
  }

  @override
  String get mascotSelectionTitle => 'Elige a tu compañero';

  @override
  String get mascotSelectionSubtitle =>
      '¡Este pequeño amigo crecerá contigo en tu viaje hacia la sostenibilidad!';

  @override
  String get mascotNameLabel => 'Dale un nombre a tu compañero';

  @override
  String get mascotNameHint => 'Ej.: Brotecito, Hojita, Capullo...';

  @override
  String get mascotNameRequired => 'Por favor ingresa un nombre';

  @override
  String get mascotNameTooLong => 'El nombre debe tener 20 caracteres o menos';

  @override
  String get mascotSelectionConfirm => '¡Crezcamos juntos!';

  @override
  String get evolutionTitle => '¡Evolución!';

  @override
  String get evolutionSubtitle => '¡Tu compañero se ha vuelto más fuerte!';

  @override
  String get evolutionContinue => '¡Increíble!';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get profileStats => 'Estadísticas';

  @override
  String get profileTotalActions => 'Total de acciones';

  @override
  String get profileTotalCO2 => 'Total CO₂ ahorrado';

  @override
  String get profileMemberSince => 'Miembro desde';

  @override
  String get profileCurrentStreak => 'Racha actual';

  @override
  String get profileLongestStreak => 'Racha más larga';

  @override
  String profileNextLevel(int points) {
    return '$points pts para el siguiente nivel';
  }

  @override
  String profileDaysActive(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días',
      one: '$days día',
    );
    return '$_temp0';
  }

  @override
  String profileEvolutionStage(int stage) {
    return 'Etapa de evolución $stage';
  }

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsNotifications => 'Notificaciones';

  @override
  String get settingsReminderTime => 'Recordatorio diario';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeSystem => 'Sistema';

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsThemeDark => 'Oscuro';

  @override
  String get settingsAccount => 'Cuenta';

  @override
  String get settingsSubscription => 'Suscripción';

  @override
  String get settingsAbout => 'Acerca de';

  @override
  String get settingsPrivacy => 'Política de privacidad';

  @override
  String get settingsTerms => 'Términos de servicio';

  @override
  String get subscriptionFree => 'Gratis';

  @override
  String get subscriptionPremium => 'Premium';

  @override
  String get subscriptionUpgrade => 'Actualizar a Premium';

  @override
  String get categoryRecycling => 'Reciclaje';

  @override
  String get categoryTransport => 'Transporte';

  @override
  String get categoryFood => 'Alimentación';

  @override
  String get categoryEnergy => 'Energía';

  @override
  String get categoryConsumption => 'Consumo';

  @override
  String get categoryWater => 'Agua';

  @override
  String get categoryCommunity => 'Comunidad';

  @override
  String get categoryAdvocacy => 'Defensa';

  @override
  String get categoryLearning => 'Aprendizaje';

  @override
  String get errorGeneric => 'Algo salió mal. Por favor intenta de nuevo.';

  @override
  String get errorNetwork => 'Sin conexión a internet.';

  @override
  String get errorAuth => 'Error de autenticación. Por favor intenta de nuevo.';

  @override
  String get errorOpenLink => 'No se pudo abrir el enlace.';

  @override
  String get errorActionTooSoon => 'Espera unos segundos entre acciones.';

  @override
  String get errorOffline =>
      'Sin conexión. Comprueba tu conexión e inténtalo de nuevo.';

  @override
  String get errorAuthEmailInUse =>
      'Ya existe una cuenta con este correo electrónico.';

  @override
  String get errorAuthInvalidEmail =>
      'Por favor ingresa un correo electrónico válido.';

  @override
  String get errorAuthOperationNotAllowed =>
      'Este método de inicio de sesión no está habilitado. Por favor contacta a soporte.';

  @override
  String get errorAuthWeakPassword =>
      'La contraseña es muy débil. Por favor usa al menos 6 caracteres.';

  @override
  String get errorAuthUserDisabled =>
      'Esta cuenta ha sido deshabilitada. Por favor contacta a soporte.';

  @override
  String get errorAuthInvalidCredentials =>
      'Correo o contraseña inválidos. Por favor intenta de nuevo.';

  @override
  String get errorAuthTooManyRequests =>
      'Demasiados intentos. Por favor espera un momento e intenta de nuevo.';

  @override
  String get errorAuthNetwork =>
      'Error de red. Por favor verifica tu conexión a internet.';

  @override
  String get errorAuthSignInCancelled => 'Se canceló el inicio de sesión.';

  @override
  String get errorAuthAccountExistsWithDifferentCredential =>
      'Ya existe una cuenta con este correo usando otro método de inicio de sesión.';

  @override
  String get errorAuthLinkExpired =>
      'Este enlace ha expirado. Por favor solicita uno nuevo.';

  @override
  String get errorAuthLinkInvalid =>
      'Este enlace es inválido. Por favor solicita uno nuevo.';

  @override
  String get buttonSave => 'Guardar';

  @override
  String get buttonCancel => 'Cancelar';

  @override
  String get buttonConfirm => 'Confirmar';

  @override
  String get buttonClose => 'Cerrar';

  @override
  String get buttonRetry => 'Reintentar';

  @override
  String get buttonContinue => 'Continuar';

  @override
  String get progressTitle => 'Progreso';

  @override
  String get progressGoalsToday => 'metas hoy';

  @override
  String get progressGoalReached => '¡Meta diaria alcanzada!';

  @override
  String get progressSetDailyGoal => 'Establece tu meta diaria';

  @override
  String get progressSetDailyGoalSubtitle =>
      '¿Cuántas acciones ecológicas quieres completar cada día?';

  @override
  String get progressStartJourney => 'Comenzar mi viaje';

  @override
  String get progressTargetDescriptionEasy =>
      'Un comienzo suave — ¡perfecto para principiantes!';

  @override
  String get progressTargetDescriptionModerate =>
      'Un desafío equilibrado — recomendado para la mayoría.';

  @override
  String get progressTargetDescriptionChallenge =>
      '¡Ambicioso! Estás comprometido con hacer un impacto.';

  @override
  String get progressTargetDescriptionExpert =>
      'Nivel experto — ¡eres un campeón de la sostenibilidad!';

  @override
  String get languageSettingsTitle => 'Idioma';

  @override
  String get languageSettingsDescription =>
      'Elige tu idioma preferido. La aplicación se actualizará inmediatamente.';

  @override
  String get languageSettingsNote =>
      'Parte del contenido de la biblioteca de acciones puede permanecer en su idioma original.';

  @override
  String settingsNotificationsSubtitle(int count) {
    return '$count recordatorios activados';
  }

  @override
  String get settingsNotificationsOff =>
      'Las notificaciones están desactivadas';

  @override
  String settingsLanguageSubtitle(String language) {
    return '$language';
  }

  @override
  String get settingsAccountSubtitle => 'Correo, contraseña, eliminar cuenta';

  @override
  String get settingsAboutSubtitle => 'Versión, licencias, contacto';

  @override
  String get accountSettingsTitle => 'Cuenta';

  @override
  String get accountSettingsEmail => 'Correo electrónico';

  @override
  String get accountSettingsChangeEmail => 'Cambiar correo';

  @override
  String get accountSettingsChangePassword => 'Cambiar contraseña';

  @override
  String get accountSettingsDeleteAccount => 'Eliminar cuenta';

  @override
  String get accountSettingsDeleteAccountWarning =>
      'Esta acción no se puede deshacer. Todos tus datos serán eliminados permanentemente.';

  @override
  String get accountSettingsDeleteConfirmTitle => '¿Eliminar cuenta?';

  @override
  String get accountSettingsDeleteConfirmMessage =>
      '¿Estás seguro de que quieres eliminar tu cuenta? Esto eliminará permanentemente todos tus datos incluyendo tu mascota, historial de acciones y progreso.';

  @override
  String get accountSettingsDeleteConfirmButton => 'Eliminar mi cuenta';

  @override
  String get accountSettingsCurrentEmail => 'Correo actual';

  @override
  String get accountSettingsNewEmail => 'Nuevo correo';

  @override
  String get accountSettingsCurrentPassword => 'Contraseña actual';

  @override
  String get accountSettingsNewPassword => 'Nueva contraseña';

  @override
  String get accountSettingsConfirmNewPassword => 'Confirmar nueva contraseña';

  @override
  String get accountSettingsPasswordMismatch => 'Las contraseñas no coinciden';

  @override
  String get accountSettingsEmailUpdated => 'Correo actualizado exitosamente';

  @override
  String get accountSettingsPasswordUpdated =>
      'Contraseña actualizada exitosamente';

  @override
  String get accountSettingsReauthRequired =>
      'Por favor ingresa tu contraseña nuevamente para continuar';

  @override
  String get accountSettingsProfile => 'Perfil';

  @override
  String get accountSettingsDisplayName => 'Nombre para mostrar';

  @override
  String get accountSettingsNotSet => 'Sin establecer';

  @override
  String get accountSettingsDisplayNameUpdated =>
      'Nombre actualizado exitosamente';

  @override
  String get accountSettingsDisplayNameRequired => 'Introduce un nombre';

  @override
  String get aboutSettingsTitle => 'Acerca de';

  @override
  String get aboutSettingsVersion => 'Versión';

  @override
  String get aboutSettingsLicenses => 'Licencias de código abierto';

  @override
  String get aboutSettingsPrivacy => 'Política de privacidad';

  @override
  String get aboutSettingsTerms => 'Términos de servicio';

  @override
  String get streakMilestoneTitle => '¡Increíble!';

  @override
  String streakMilestoneWeeks(int count) {
    return '¡$count semanas de racha!';
  }

  @override
  String streakMilestoneDays(int count) {
    return '¡Has registrado acciones por $count días seguidos!';
  }

  @override
  String get streakMilestoneKeepGoing => '¡Sigue con el increíble trabajo!';

  @override
  String get streakMilestoneContinue => 'Continuar';

  @override
  String get streakBrokenTitle => 'Racha interrumpida';

  @override
  String get streakBrokenMessage =>
      '¡No te preocupes! Comienza una nueva racha hoy.';

  @override
  String streakBrokenPrevious(int count) {
    return 'Racha anterior: $count días';
  }

  @override
  String get streakBrokenStartNew => 'Comenzar nueva racha';

  @override
  String get sortLabel => 'Ordenar';

  @override
  String get sortAlphabeticalAZ => 'Nombre (A-Z)';

  @override
  String get sortAlphabeticalZA => 'Nombre (Z-A)';

  @override
  String get sortCo2HighToLow => 'CO₂ (Mayor a menor)';

  @override
  String get sortCo2LowToHigh => 'CO₂ (Menor a mayor)';

  @override
  String get sortPointsHighToLow => 'Puntos (Mayor a menor)';

  @override
  String get sortPointsLowToHigh => 'Puntos (Menor a mayor)';

  @override
  String get filterBySDG => 'Filtrar por ODS';

  @override
  String get allCategories => 'Todos';

  @override
  String co2PerAction(Object amount) {
    return '${amount}g CO₂';
  }

  @override
  String get sdgYourImpact => 'Tu impacto';

  @override
  String sdgActionsLogged(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count acciones registradas',
      one: '$count acción registrada',
    );
    return '$_temp0';
  }

  @override
  String sdgCo2SavedForGoal(String amount) {
    return '$amount CO₂ ahorrado para este objetivo';
  }

  @override
  String get sdgRelatedActions => 'Acciones relacionadas';

  @override
  String get sdgViewAllActions => 'Ver todo';

  @override
  String get sdgResources => 'Recursos';

  @override
  String get sdgLearnOnlyExplanation =>
      'Este objetivo aborda problemas sistémicos que requieren acción colectiva. Aunque no puedes registrar acciones diarias directamente, aprender sobre él te ayuda a entender el panorama completo y encontrar formas de contribuir.';

  @override
  String get sdgWaysToContribute => 'Formas de contribuir';

  @override
  String get sdgNoActionsYet =>
      'Aún no hay acciones registradas para este objetivo';

  @override
  String get learnOnlyBadge => 'Aprender';

  @override
  String get learnOnlyTitle => 'Conoce esta acción';

  @override
  String get learnOnlyDescription =>
      'Esta acción apoya objetivos de sostenibilidad más amplios. Aunque no se puede registrar directamente, aprender sobre ella te ayuda a entender el panorama completo.';

  @override
  String get learnOnlyRelatedSdgs => 'Objetivos relacionados';

  @override
  String get learnOnlyDismiss => 'Entendido';

  @override
  String get settingsAnalytics => 'Privacidad';

  @override
  String get settingsAnalyticsSubtitle =>
      'Ayuda a mejorar Seed compartiendo datos de uso anónimos';

  @override
  String get privacyPolicyTitle => 'Política de privacidad';

  @override
  String get termsOfServiceTitle => 'Términos de servicio';

  @override
  String legalLastUpdated(String date) {
    return 'Última actualización: $date';
  }

  @override
  String get eggDiscoveryTitle => '¡Un huevo misterioso!';

  @override
  String eggDiscoveryMessage(String mascotName) {
    return 'Durante la noche, un huevo misterioso apareció junto a $mascotName.';
  }

  @override
  String get eggDiscoverySubtitle =>
      'Registra acciones todos los días durante 30 días para incubarlo.';

  @override
  String get eggDiscoveryDismiss => '¡Qué emocionante!';

  @override
  String get eggHatchingTitle => '¡Está eclosionando!';

  @override
  String get eggHatchingNamePrompt => 'Dale un nombre a tu nuevo compañero';

  @override
  String get eggHatchingConfirm => '¡Bienvenido!';

  @override
  String eggProgressLabel(int current, int total) {
    return 'Día $current/$total';
  }

  @override
  String get mascotCollectionTitle => 'Mis mascotas';

  @override
  String get mascotSwitchConfirm => '¿Cambiar mascota?';

  @override
  String get switchToMascot => 'Cambiar a';

  @override
  String get switchMascotButton => 'Cambiar';

  @override
  String get actionLearnMore => 'Toca para conocer la ciencia';

  @override
  String get maxEvolutionTitle => '¡Evolución máxima!';

  @override
  String get maxEvolutionSubtitle =>
      '¡Tu compañero ha alcanzado su máximo potencial!';

  @override
  String get maxEvolutionEggHint =>
      '¡Cuida tu huevo para descubrir un nuevo compañero!';

  @override
  String get sdgAboutGoal => 'Acerca de este objetivo';

  @override
  String get sdgViewTargets => 'Ver metas';

  @override
  String get sdgTargetsTitle => 'Metas de la ONU';

  @override
  String get notifSettingsTitle => 'Ajustes de notificaciones';

  @override
  String get notifSectionNotifications => 'Notificaciones';

  @override
  String get notifEnableTitle => 'Activar notificaciones';

  @override
  String get notifEnableSubtitle =>
      'Recibe recordatorios diarios para registrar acciones';

  @override
  String get notifSmartTitle => 'Recordatorios inteligentes';

  @override
  String get notifSmartOnlyTitle => 'Solo recordar si no hay acción hoy';

  @override
  String get notifSmartOnlySubtitle =>
      'Omitir recordatorios los días que ya registraste';

  @override
  String get notifSmartDescription =>
      'Cuando está activado, los recordatorios solo aparecerán si no has registrado acciones sostenibles ese día.';

  @override
  String get notifReminderTimesTitle => 'Horarios de recordatorio';

  @override
  String get notifNoReminders => 'Sin recordatorios configurados';

  @override
  String get notifAddReminder =>
      'Agrega un recordatorio para recibir notificaciones';

  @override
  String get notifAddReminderTime => 'Agregar horario de recordatorio';

  @override
  String get notifMaxReminders => 'Máximo 5 recordatorios permitidos';

  @override
  String get notifEditTime => 'Editar horario de recordatorio';

  @override
  String get notifSelectTime => 'Seleccionar horario de recordatorio';

  @override
  String get notifLabelTitle => 'Etiqueta del recordatorio';

  @override
  String get notifLabelHint => 'Ej.: Mañana, Después del trabajo...';

  @override
  String get notifLabelOptional => 'Etiqueta (opcional)';

  @override
  String get notifDeleteTitle => '¿Eliminar recordatorio?';

  @override
  String notifDeleteMessage(String time) {
    return '¿Eliminar el recordatorio de las $time?';
  }

  @override
  String get notifAdd => 'Agregar';

  @override
  String get settingsPreferences => 'Preferencias';

  @override
  String settingsVersionFormat(String version) {
    return 'Versión $version';
  }

  @override
  String get settingsNoReminders => 'Sin recordatorios configurados';

  @override
  String settingsRemindersCount(int count) {
    return '$count recordatorios configurados';
  }

  @override
  String get settingsOneReminder => '1 recordatorio configurado';

  @override
  String get settingsTapToAddReminders => 'Toca para agregar recordatorios';

  @override
  String get settingsAllRemindersDisabled =>
      'Todos los recordatorios desactivados';

  @override
  String settingsRemindersPlusMore(String time, int count) {
    return '$time + $count más';
  }

  @override
  String get settingsErrorLoading => 'Error al cargar ajustes';

  @override
  String get settingsSupport => 'Soporte';

  @override
  String get settingsFeedback => 'Enviar comentarios';

  @override
  String get settingsFeedbackSubtitle =>
      'Reporta un error o comparte tu opinión';

  @override
  String get aboutLegal => 'Legal';

  @override
  String get aboutFooterSdg =>
      'Seed ayuda a registrar acciones sostenibles alineadas con los Objetivos de Desarrollo Sostenible de la ONU.';

  @override
  String get aboutFooterMade => 'Hecho con cuidado para nuestro planeta.';

  @override
  String get aboutSubtitleTracker => 'Rastreador de hábitos sostenibles';

  @override
  String get feedbackTitle => 'Enviar comentarios';

  @override
  String get feedbackCategoryLabel => 'Categoría';

  @override
  String get feedbackCategoryBug => 'Reporte de error';

  @override
  String get feedbackCategoryFeature => 'Solicitud de función';

  @override
  String get feedbackCategoryGeneral => 'Comentario general';

  @override
  String get feedbackDescriptionLabel => 'Describe tus comentarios';

  @override
  String get feedbackDescriptionHint => 'Cuéntanos lo que piensas...';

  @override
  String get feedbackMetadataNote =>
      'Incluimos la siguiente información para ayudarnos a investigar: versión de la app, dispositivo y SO, idioma y tu ID de cuenta.';

  @override
  String get feedbackSubmit => 'Enviar comentarios';

  @override
  String get feedbackThanks => '¡Gracias por tus comentarios!';

  @override
  String get feedbackMailFailed =>
      'No se pudo abrir tu aplicación de correo. Inténtalo de nuevo.';

  @override
  String get mascotEvolutionTimeline => 'Línea de evolución';

  @override
  String get mascotNextEvolution => 'Próxima evolución';

  @override
  String get mascotStatsTitle => 'Nuestro viaje';

  @override
  String get mascotStatBirthday => 'Cumpleaños';

  @override
  String get mascotStatDaysTogether => 'Días juntos';

  @override
  String get mascotStatCo2Together => 'CO₂ ahorrado juntos';

  @override
  String mascotLevelShort(int level) {
    return 'Nv $level';
  }

  @override
  String mascotLevelsToGo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count niveles restantes',
      one: '$count nivel restante',
    );
    return '$_temp0';
  }

  @override
  String mascotLevelProgress(int current, int max) {
    return 'Nivel $current / $max';
  }

  @override
  String get homeExploreGoals => 'Explora los Objetivos ODS';

  @override
  String get homeExploreGoalsSubtitle =>
      'Toca para conocer los Objetivos de Desarrollo Sostenible de la ONU';

  @override
  String get homeLearnMore => 'Más información en UN.org';

  @override
  String get homePoints => 'Puntos';

  @override
  String get myGoalTitle => 'Mi meta';

  @override
  String get myGoalEmptyPrompt =>
      'Toca para establecer tu meta de sostenibilidad';

  @override
  String get myGoalUpdated => 'Meta actualizada exitosamente';

  @override
  String get goalPickerTitle => 'Elige tu meta';

  @override
  String get goalPickerCustomOption => 'Escribe la tuya';

  @override
  String get goalPickerCustomHint => 'Mi meta es...';

  @override
  String get personalGoalReduceFlights =>
      'Reducir los vuelos de larga distancia';

  @override
  String get personalGoalPlantBased => 'Comer más comidas a base de plantas';

  @override
  String get personalGoalLessPlastic => 'Eliminar el plástico de un solo uso';

  @override
  String get personalGoalWalkBike =>
      'Caminar o ir en bicicleta en lugar de conducir';

  @override
  String get personalGoalLessFoodWaste => 'Desperdiciar menos comida';

  @override
  String get personalGoalBuyLess => 'Comprar menos y reutilizar más';

  @override
  String get personalGoalInspireOthers =>
      'Inspirar a amigos y familiares a actuar';

  @override
  String get personalGoalSaveWorld => 'Salvar el mundo';

  @override
  String sdgGoalNumber(int number) {
    return 'Objetivo $number';
  }

  @override
  String get sdgProgressChart => 'Progreso mundial';

  @override
  String get sdgProgressChartHint => 'Toca para ampliar';

  @override
  String get sdgBadge => 'ODS ONU';

  @override
  String get buttonDelete => 'Eliminar';

  @override
  String get buttonSkip => 'Omitir';

  @override
  String get authWelcomeBack => 'Bienvenido de nuevo';

  @override
  String get authSignInSubtitle =>
      'Inicia sesión para continuar tu viaje sostenible';

  @override
  String get authSignIn => 'Iniciar sesión';

  @override
  String get authOrContinueWith => 'o continuar con';

  @override
  String get authNoAccount => '¿No tienes una cuenta?';

  @override
  String get authCreateAccount => 'Crear cuenta';

  @override
  String get authCreateAccountSubtitle => 'Comienza tu viaje sostenible hoy';

  @override
  String get authOrSignUpWith => 'o regístrate con';

  @override
  String get authHaveAccount => '¿Ya tienes una cuenta?';

  @override
  String get authAgreePrefix => 'Acepto los ';

  @override
  String get authAgreeAnd => ' y la ';

  @override
  String get authAcceptTermsError =>
      'Por favor acepta los Términos de servicio y la Política de privacidad';

  @override
  String get authForgotPasswordTitle => 'Restablecer contraseña';

  @override
  String get authForgotPasswordHint => 'Ingresa tu correo electrónico';

  @override
  String get authForgotPasswordSend => 'Enviar';

  @override
  String get authForgotPasswordSent =>
      'Si existe una cuenta con este correo, se ha enviado un enlace para restablecer la contraseña.';

  @override
  String get authVerifyEmailTitle => 'Verificar correo';

  @override
  String get authCheckEmail => 'Revisa tu correo';

  @override
  String get authVerificationSentTo => 'Enviamos un enlace de verificación a:';

  @override
  String get authVerifyInstructions =>
      'Haz clic en el enlace del correo para verificar tu cuenta, luego regresa aquí y toca el botón de abajo.';

  @override
  String get authChecking => 'Verificando...';

  @override
  String get authVerifiedButton => 'Ya verifiqué mi correo';

  @override
  String get authVerificationSent => '¡Correo de verificación enviado!';

  @override
  String get authResendEmail => 'Reenviar correo';

  @override
  String get authDifferentEmail => 'Usar otro correo';

  @override
  String get authEmailVerified => '¡Correo verificado! ¡Bienvenido a Seed!';

  @override
  String get authEmailNotVerified =>
      'Correo aún no verificado. Revisa tu bandeja de entrada y haz clic en el enlace de verificación.';

  @override
  String get authValidationEmailRequired => 'Por favor ingresa tu correo';

  @override
  String get authValidationEmailInvalid => 'Por favor ingresa un correo válido';

  @override
  String get authValidationPasswordRequired =>
      'Por favor ingresa tu contraseña';

  @override
  String get authValidationPasswordShort =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String get authValidationConfirmRequired =>
      'Por favor confirma tu contraseña';

  @override
  String pointsAbbreviated(int count) {
    return '$count pts';
  }

  @override
  String stageFallback(int stage) {
    return 'Etapa $stage';
  }

  @override
  String get dayDetailActions => 'Acciones';

  @override
  String get dayDetailNoActions => 'No hay acciones registradas este día';

  @override
  String get dayDetailFactLocked => 'No se desbloqueó ningún eco-dato este día';

  @override
  String get ecoFactTitle => 'Eco-dato del día';

  @override
  String get ecoFactDidYouKnow => 'Sabías que...?';

  @override
  String get ecoFactSource => 'Fuente';

  @override
  String get ecoFactLocked =>
      'Completa el desafío de hoy para desbloquear este dato!';

  @override
  String get ecoFactInboxTitle => 'Bandeja de entrada';

  @override
  String get ecoFactInboxEmpty =>
      'Aún no hay correo. Completa el desafío de hoy para recibir tu primer eco-dato.';

  @override
  String get ecoFactInboxLockedSubject => 'Eco-dato bloqueado';

  @override
  String get ecoFactCategoryComparison => 'Comparación';

  @override
  String get ecoFactCategoryIndividual => 'Impacto individual';

  @override
  String get ecoFactCategoryMythBuster => 'Desmitificador';

  @override
  String get ecoFactCategoryNatureWonder => 'Maravilla natural';

  @override
  String get ecoFactCategoryPositiveNews => 'Noticia positiva';

  @override
  String get challengeDialogTitle => 'Desafío de hoy';

  @override
  String get challengeDialogLater => 'Más tarde';

  @override
  String get challengeDialogLogAction => 'Registrar acción';

  @override
  String get challengeDialogUnlock =>
      'Completa para desbloquear el eco-dato de hoy!';

  @override
  String get challengeTabLabel => 'Desafío';

  @override
  String get challengeCompleted => 'Completado!';

  @override
  String get challengeNotCompleted => 'Aún no completado';

  @override
  String get challengeSeeFact => 'Ver el eco-dato de hoy';

  @override
  String challengeStreakDays(int days) {
    return 'Racha de $days días de desafío';
  }

  @override
  String challengeMultiDayProgress(int current, int target) {
    return 'Día $current de $target';
  }

  @override
  String get challengeCompletedSnackbar =>
      'Desafío completado! Eco-dato desbloqueado!';

  @override
  String get challengeBrowse => 'Explorar desafíos';

  @override
  String get challengesScreenTitle => 'Desafíos de varios días';

  @override
  String get challengeStart => 'Iniciar desafío';

  @override
  String get challengeStartConfirm => 'Iniciar este desafío?';

  @override
  String get challengeActive => 'Activo';

  @override
  String get challengeCompletedBadge => 'Completado';

  @override
  String get challengeAvailable => 'Disponible';

  @override
  String get challengeAbandon => 'Abandonar';

  @override
  String get challengeAbandonConfirm =>
      'Abandonar este desafío? Se perderá el progreso.';

  @override
  String challengeDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días',
      one: '$days día',
    );
    return '$_temp0';
  }

  @override
  String get challengeAnyCategory => 'Cualquier categoría';

  @override
  String get challengeLocked => 'Bloqueado';

  @override
  String get progressCalendarTab => 'Calendario';

  @override
  String get ecoDexTab => 'Eco-Dex';

  @override
  String get impactTab => 'Impacto';

  @override
  String get periodToday => 'Hoy';

  @override
  String get periodThisWeek => 'Esta semana';

  @override
  String get periodThisMonth => 'Este mes';

  @override
  String get periodAllTime => 'Total';

  @override
  String get co2SavedToday => 'CO2 ahorrado hoy';

  @override
  String get co2SavedThisWeek => 'CO2 ahorrado esta semana';

  @override
  String get co2SavedThisMonth => 'CO2 ahorrado este mes';

  @override
  String get co2SavedAllTime => 'CO2 ahorrado en total';

  @override
  String get kgUnit => 'kg';

  @override
  String get vsYesterday => 'vs. ayer';

  @override
  String get vsLastWeek => 'vs. semana pasada';

  @override
  String get vsLastMonth => 'vs. mes pasado';

  @override
  String get trendChartTitle => 'Tendencia diaria';

  @override
  String get trendChartAverageLabel => 'promedio';

  @override
  String get categoryChartTitle => 'Por categoría';

  @override
  String get categoryOther => 'Otros';

  @override
  String get equivalentToHeader => 'Equivale a';

  @override
  String get equivTreesLabel => 'árboles · año';

  @override
  String get equivCarKmLabel => 'km no recorridos';

  @override
  String get equivPhoneChargesLabel => 'cargas de móvil';

  @override
  String get equivBurgersLabel => 'hamburguesas de carne';

  @override
  String get impactInfoTooltip => 'Cómo lo calculamos';

  @override
  String get impactInfoTitle => 'Cómo lo calculamos';

  @override
  String get impactInfoIntro =>
      'Traducimos el CO2 que has evitado a comparaciones cotidianas. Las cifras son orientativas: usamos promedios globales y mezclamos CO2 con CO2 equivalente (metano, electricidad, ciclo de vida alimentario), así que tu impacto real depende de la red eléctrica local y la cadena de suministro.';

  @override
  String get impactInfoFormulaLabel => 'Fórmula';

  @override
  String get impactInfoSourceLabel => 'Fuente';

  @override
  String get equivTreesExplainer =>
      'CO2 aproximado que absorbe un árbol urbano maduro en un año. Los árboles recién plantados absorben mucho menos: esta cifra corresponde a árboles ya desarrollados.';

  @override
  String get equivCarKmExplainer =>
      'Emisiones medias de un coche por kilómetro recorrido, ponderadas entre gasolina y diésel.';

  @override
  String get equivPhoneChargesExplainer =>
      'Electricidad de red necesaria para cargar por completo un móvil medio, basada en la combinación eléctrica nacional de EE. UU. Las redes más limpias (p. ej., Noruega) consumen menos; las más dependientes del carbón, más.';

  @override
  String get equivBurgersExplainer =>
      'Emisiones del ciclo de vida completo de una hamburguesa de carne (113 g de carne), desde la ganadería hasta el comercio. Una hamburguesa de pollo emite unas 10 veces menos; una de frijoles, unas 50 veces menos.';

  @override
  String equivFormulaTemplate(String factor) {
    return 'g de CO2 / $factor';
  }

  @override
  String get ecoDexTitle => 'Eco-Dex';

  @override
  String ecoDexProgress(int discovered, int total) {
    return '$discovered / $total descubiertos';
  }

  @override
  String get ecoDexLocked => 'No descubierto';

  @override
  String get ecoDexViewSource => 'Ver fuente';

  @override
  String ecoDexAchievement(String hint) {
    return 'Logro: $hint';
  }

  @override
  String get ecoDexNewDiscovery => 'Nuevo descubrimiento en Eco-Dex!';

  @override
  String get ecoDexNextUp => 'Próximos';

  @override
  String get ecoDexDiscoveryTitle => '¡Nuevo Descubrimiento!';

  @override
  String get ecoDexDiscoveryAcknowledge => '¡Genial!';

  @override
  String ecoDexDiscoveryMoreQueued(int count) {
    return '+$count más en cola';
  }

  @override
  String get ecoDexEmptyHint =>
      'Registra tu primera acción para hacer tu primer descubrimiento.';

  @override
  String get ecoDexInfoTooltip => 'Acerca del Eco-Dex';

  @override
  String get ecoDexInfoTitle => 'Acerca del Eco-Dex';

  @override
  String get ecoDexInfoBody =>
      'El Eco-Dex es tu enciclopedia de datos sobre nuestro planeta. Las entradas se desbloquean automáticamente al usar Seed: registrar acciones, ahorrar CO2, mantener rachas, completar retos y leer datos ecológicos. Toca una tarjeta bloqueada para ver una pista sobre cómo descubrirla, y toca una entrada descubierta para leer su dato completo. Los descubrimientos no otorgan puntos: cada uno te recompensa con conocimiento.';

  @override
  String get transportCalculatorTitle => 'Calculadora de transporte';

  @override
  String get calculatorsSheetTitle => 'Calculadoras';

  @override
  String get calculatorsButtonTooltip => 'Calculadoras';

  @override
  String get calculatorHomeEnergy => 'Energía del hogar';

  @override
  String get transportJourneyEmpty =>
      'Añade un tramo para crear tu trayecto y ver su huella de CO2e.';

  @override
  String get transportAddLeg => 'Añadir trayecto';

  @override
  String get transportEditLeg => 'Editar tramo';

  @override
  String get transportSelectMode => 'Elige un modo de transporte';

  @override
  String get transportChangeMode => 'Cambiar';

  @override
  String get transportDistanceLabel => 'Distancia (km)';

  @override
  String get transportDistanceInvalid =>
      'Introduce una distancia de 0 km o más';

  @override
  String get transportDistanceEstimateNote =>
      'Estimación derivada de la ubicación de las ciudades. Edítala según tu ruta.';

  @override
  String get transportDistanceUnknown => 'Desconocida';

  @override
  String transportFlightBandNote(String band) {
    return 'Esta distancia usa el factor de $band, para que un trayecto corto nunca se calcule como un vuelo de larga distancia.';
  }

  @override
  String get transportOccupantsLabel => 'Personas en el vehículo';

  @override
  String get transportOccupantsAdd => 'Añadir una persona';

  @override
  String get transportOccupantsRemove => 'Quitar una persona';

  @override
  String transportOccupantsSemantic(int count) {
    return 'Personas en el vehículo: $count';
  }

  @override
  String get transportTotalLabel => 'Total';

  @override
  String get transportRemoveLeg => 'Eliminar tramo';

  @override
  String get transportFromCity => 'Ciudad de origen';

  @override
  String get transportToCity => 'Ciudad de destino';

  @override
  String get transportCityPrefillHint =>
      'Elige dos ciudades para estimar las distancias.';

  @override
  String transportEstimatedKm(String km) {
    return '~$km km';
  }

  @override
  String transportKmValue(String km) {
    return '$km km';
  }

  @override
  String transportOccupantsValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count personas',
      one: '1 persona',
    );
    return '$_temp0';
  }

  @override
  String transportModeFactorPerPassenger(int grams) {
    return '$grams g CO2e por km';
  }

  @override
  String transportModeFactorPerVehicle(int grams) {
    return '$grams g CO2e por vehículo y km';
  }

  @override
  String get transportGroupActive => 'A pie y en bici';

  @override
  String get transportGroupMicro => 'Micromovilidad';

  @override
  String get transportGroupCar => 'Coche y moto';

  @override
  String get transportGroupBus => 'Autobús';

  @override
  String get transportGroupTaxi => 'Taxi';

  @override
  String get transportGroupRail => 'Tren';

  @override
  String get transportGroupWater => 'Barco';

  @override
  String get transportGroupAir => 'Avión';

  @override
  String get transportGroupHighImpact => 'Alto impacto';

  @override
  String get transportModeScienceTooltip => 'Sobre este factor';

  @override
  String get transportBasisEvGrid =>
      'Red eléctrica media mundial; varía según tu electricidad';

  @override
  String get transportBasisJetRf =>
      'Incluye el mismo incremento de gran altitud (forzamiento radiativo) que los vuelos';

  @override
  String get transportBasisZeroDirect => '0 emisiones directas';

  @override
  String get transportBasisElectricityOnly => 'Solo electricidad';

  @override
  String get transportComparisonTitle => 'Comparar trayectos';

  @override
  String get transportAddToComparison => 'Añadir como opción';

  @override
  String get calculatorStagedOptions => 'Opciones a comparar';

  @override
  String get calculatorRemoveOption => 'Quitar esta opción';

  @override
  String calculatorEntryPreview(String amount) {
    return 'Esto añade $amount CO2e';
  }

  @override
  String get co2eDefinitionTitle => '¿Qué es el CO2e?';

  @override
  String get co2eDefinitionBody =>
      'El CO2e cuenta el metano y otros gases de efecto invernadero como su equivalente en CO2, para que una hamburguesa y un vuelo se comparen de forma justa.';

  @override
  String get calculatorOptionA => 'Opción A';

  @override
  String get calculatorOptionB => 'Opción B';

  @override
  String get calculatorDropHint =>
      'Arrastra o toca un elemento de abajo para añadirlo';

  @override
  String get calculatorAddToA => 'Añadir a A';

  @override
  String get calculatorAddToB => 'Añadir a B';

  @override
  String get calculatorBrowseAll => 'Ver todo';

  @override
  String get transportColumnEmptyHint =>
      'Toca Añadir trayecto para empezar este viaje';

  @override
  String get calculatorNeedBothOptions =>
      'Crea ambas opciones para compararlas';

  @override
  String get calculatorRemoveEntry => 'Quitar';

  @override
  String get scienceNotesHeading => 'Cómo se calcula';

  @override
  String get scienceSourcesHeading => 'Fuentes';

  @override
  String scienceAccessed(String date) {
    return 'Consultado el $date';
  }

  @override
  String transportComparisonFull(int max) {
    return 'Comparación completa ($max opciones)';
  }

  @override
  String transportCompareOptions(int count) {
    return 'Comparar $count opciones';
  }

  @override
  String transportOptionStaged(int count) {
    return 'Opción $count añadida';
  }

  @override
  String transportComparisonDelta(
    String label,
    String amount,
    String worse,
    int percent,
  ) {
    return '$label emite $amount de CO2e menos que $worse ($percent% menos)';
  }

  @override
  String transportComparisonTreesEquiv(String count) {
    return 'Equivale a unos $count árboles absorbiendo CO2 durante un año';
  }

  @override
  String get transportMethodologyTitle => 'Metodología y fuentes';

  @override
  String transportMethodologyBody(int grid) {
    return 'Cada cifra de esta herramienta es una estimación con fines educativos, trazable a las fuentes indicadas abajo.\n\n### Qué se cuenta\nSolo la energía operativa: el combustible que queman los motores y la electricidad generada para los modos eléctricos. Se excluyen la fabricación de vehículos y las infraestructuras. Caminar e ir en bici cuentan como cero por convención: las calorías que gastas quedan fuera, ya que pueden no sumarse a una dieta normal.\n\n### Ocupación\nLos coches y taxis se miden por vehículo, así que su huella se divide entre las personas a bordo. Autobuses, trenes y vuelos ya son por pasajero, con una ocupación típica.\n\n### Vuelos y forzamiento radiativo\nLos aviones calientan el clima más allá de su CO2 mediante estelas y efectos de gran altitud. Siguiendo a DESNZ 2025, los factores de vuelos y jets privados incluyen un incremento del 1,7x (estimación central) sobre el componente de CO2. Los jets privados llevan el mismo incremento, así que la comparación es equivalente.\n\n### Modos eléctricos y la red\nLos coches eléctricos, las bicis y patinetes eléctricos no emiten nada por el tubo de escape; su huella proviene de generar la electricidad. Esta herramienta usa una red media mundial de $grid g CO2e por kWh, que varía mucho según el país y la hora, así que tu cifra real puede ser mayor o menor.\n\n### Promedios, no tu trayecto exacto\nLos factores son promedios por categoría, no tu vehículo, ruta o estilo de conducción concretos. Úsalos para comparar opciones, no para una contabilidad precisa del carbono.\n\n### Diferencias mínimas\nAlgunos modos están muy cerca: el autocar y el tren, por ejemplo, están a pocos gramos y su orden puede cambiar entre revisiones anuales de factores. Trata las diferencias pequeñas como un empate, no como un ganador claro.';
  }

  @override
  String get transportLogChoiceTitle => '¿Tomar la opción más ecológica?';

  @override
  String transportLogChoiceBody(String amount) {
    return 'Registra esto como una acción de transporte y acumula los $amount de CO2e que evitas al elegir la opción de menor huella.';
  }

  @override
  String transportLogChoiceCta(String label) {
    return 'Registrar $label como mi elección de hoy';
  }

  @override
  String transportChoiceLoggedMessage(String amount) {
    return 'Registrado. Acumulaste $amount de CO2e.';
  }

  @override
  String transportCustomActionName(String greener, String worse) {
    return 'Elegí $greener en vez de $worse';
  }

  @override
  String get transportChoseLabel => 'Elegí';

  @override
  String get transportInsteadOfLabel => 'en lugar de';

  @override
  String get transportChoiceDistinctHint =>
      'Elige dos opciones distintas para registrar tu elección.';

  @override
  String get transportActionsEntryTitle =>
      'Registrar una acción de transporte personalizada';

  @override
  String get customActionBadge => 'Personalizada';

  @override
  String get actionReproduce => 'Hacerlo de nuevo';

  @override
  String get actionReproducedMessage => 'Registrado de nuevo';

  @override
  String get foodCalculatorTitle => 'Calculadora de alimentación';

  @override
  String get foodMethodologyTitle => 'Metodología y fuentes';

  @override
  String get foodTotalLabel => 'Total';

  @override
  String get foodMealEmpty =>
      'Añade un ingrediente para construir tu comida y ver su huella de CO2e.';

  @override
  String get foodAddIngredient => 'Añadir alimento';

  @override
  String get foodEditIngredient => 'Editar ingrediente';

  @override
  String get foodSelectItem => 'Elige un alimento';

  @override
  String get foodChangeItem => 'Cambiar';

  @override
  String get foodQuantityLabel => 'Cantidad (g)';

  @override
  String get foodQuantityInvalid => 'Introduce una cantidad de 0 g o más';

  @override
  String foodGramsValue(String grams) {
    return '$grams g';
  }

  @override
  String get foodRemoveIngredient => 'Eliminar ingrediente';

  @override
  String get foodItemScienceTooltip => 'Sobre este factor';

  @override
  String get foodColumnEmptyHint =>
      'Toca Añadir alimento para empezar esta comida';

  @override
  String get foodSearchHint => 'Buscar alimentos...';

  @override
  String get foodSearchNoResults => 'Ningún alimento coincide con la búsqueda.';

  @override
  String foodItemFactorWithServing(
    String perKg,
    String perServing,
    String serving,
  ) {
    return '$perKg kg CO2e por kg  ·  $perServing por $serving';
  }

  @override
  String foodItemFactorPerKg(String value) {
    return '$value kg de CO2e por kg';
  }

  @override
  String get foodGroupMeat => 'Carne';

  @override
  String get foodGroupSeafood => 'Pescado y marisco';

  @override
  String get foodGroupDairyEggs => 'Lácteos y huevos';

  @override
  String get foodGroupPlantProtein => 'Proteína vegetal';

  @override
  String get foodGroupStaples => 'Alimentos básicos';

  @override
  String get foodGroupVegetables => 'Verduras';

  @override
  String get foodGroupFruit => 'Fruta';

  @override
  String get foodGroupDrinks => 'Bebidas';

  @override
  String get foodGroupTreats => 'Caprichos';

  @override
  String get foodGroupOils => 'Aceites';

  @override
  String get foodAddToComparison => 'Añadir como opción';

  @override
  String foodComparisonFull(int max) {
    return 'Comparación completa ($max opciones)';
  }

  @override
  String foodCompareOptions(int count) {
    return 'Comparar $count opciones';
  }

  @override
  String foodOptionStaged(int count) {
    return 'Opción $count añadida';
  }

  @override
  String get foodComparisonTitle => 'Comparar comidas';

  @override
  String get foodGroupNutsSeeds => 'Frutos secos y semillas';

  @override
  String get foodGroupCondiments => 'Condimentos';

  @override
  String get foodGroupPrepared => 'Platos preparados';

  @override
  String get foodBasisDry =>
      'Peso en seco: pésalo antes de cocinarlo o ponerlo a remojo.';

  @override
  String get foodBasisDrained =>
      'Peso escurrido: pésalo después de escurrir la lata.';

  @override
  String get foodBasisEdible =>
      'Peso comestible: pésalo sin cáscara, hueso ni piel.';

  @override
  String get foodBasisConcentrate =>
      'Peso sin diluir: pesa el concentrado, no la bebida.';

  @override
  String get foodBoundaryNarrower =>
      'Se ha medido sobre una cadena de suministro más corta que la mayoría de los alimentos de aquí, así que parece más bajo.';

  @override
  String get foodPickerRecents => 'Recientes';

  @override
  String get foodVerdictWhyCta => '¿Por qué no hay resultado?';

  @override
  String get foodVerdictBlockedTitle =>
      'La diferencia no basta para registrarla';

  @override
  String foodVerdictTooClose(int percent) {
    return 'Estas dos comidas están a menos del $percent% una de otra. La mayoría de los alimentos de aquí comparten un promedio con toda una categoría, y muchos están empatados estadísticamente, así que una diferencia tan pequeña queda dentro de lo que la investigación de origen puede distinguir. Arriba tienes ambos totales; simplemente no declaramos una ganadora.';
  }

  @override
  String foodVerdictCrossSource(int percent) {
    return 'Estas comidas se miden con estudios distintos, y uno de ellos abarca una cadena de suministro más corta. Parte de cualquier diferencia podría deberse a eso y no a algo real, así que necesitaríamos que una emitiera menos de la mitad que la otra -- en torno al $percent% -- antes de decir cuál es mejor.';
  }

  @override
  String foodVerdictTiedBasis(int percent) {
    return 'Esta diferencia se apoya en ingredientes que comparten una misma cifra de investigación de origen. Cuando dos de ellos no coinciden, esa discrepancia es una decisión contable del estudio original y no algo medido en el campo. Si se descuenta, estas comidas quedan a menos del $percent% una de otra, así que no declaramos una ganadora. Arriba tienes ambos totales.';
  }

  @override
  String get foodVerdictTiedBasisFlips =>
      'Cuál de estas comidas sale mejor parada depende de una decisión contable del estudio original y no de los alimentos. Algunos ingredientes de ambos lados comparten una misma cifra de investigación de origen, y al fijar esa cifra en un único valor el resultado se invierte. Una ganadora que cambia así es un dato sobre el estudio, así que no declaramos ninguna. Arriba tienes ambos totales.';

  @override
  String foodVerdictUncertainItem(String item, String ratio, int percent) {
    return 'El problema es $item, no tus comidas. La investigación que hay detrás no se pone de acuerdo consigo misma: una minoría de productores de impacto muy alto eleva su promedio hasta $ratio veces su valor intermedio, así que dónde acaba depende mucho de qué granjas se cuenten. Una diferencia de en torno al $percent% superaría esa incertidumbre; esta no lo hace. Puedes registrar la comida como una acción normal.';
  }

  @override
  String get foodComparisonTooClose =>
      'Estas dos opciones están demasiado igualadas. Por debajo de una diferencia del 20%, la brecha queda dentro de lo que la investigación de origen puede distinguir, así que mostramos ambos totales sin elegir una ganadora.';

  @override
  String foodComparisonDelta(
    String label,
    String amount,
    String worse,
    int percent,
  ) {
    return '$label emite $amount de CO2e menos que $worse ($percent% menos)';
  }

  @override
  String foodComparisonCarKmEquiv(int km) {
    return 'Equivale a unos $km km no recorridos en un coche de gasolina';
  }

  @override
  String get foodChoseLabel => 'Comí';

  @override
  String get foodInsteadOfLabel => 'en lugar de';

  @override
  String foodLogChoiceBody(String amount) {
    return 'Registra esto como una acción de alimentación y acumula los $amount de CO2e que evitas al elegir la comida de menor huella.';
  }

  @override
  String get foodChoiceDistinctHint =>
      'Elige dos comidas distintas para registrar tu elección.';

  @override
  String foodLogChoiceCta(String label) {
    return 'Registrar $label como mi elección de hoy';
  }

  @override
  String foodChoiceLoggedMessage(String amount) {
    return 'Registrado. Acumulaste $amount de CO2e.';
  }

  @override
  String foodCustomActionName(String greener, String worse) {
    return 'Elegí $greener en vez de $worse';
  }

  @override
  String get foodActionsEntryTitle =>
      'Registrar una acción de comida personalizada';

  @override
  String get foodMethodologyBody =>
      'Cada cifra de esta herramienta es una estimación con fines educativos, trazable hasta las fuentes que se enumeran abajo.\n\n### Qué se cuenta\nCada factor abarca todo el ciclo de vida del alimento, de la cuna al comercio -- cambio de uso del suelo, cultivo, pienso, procesado, transporte y envasado --, según el metaanálisis de Poore & Nemecek de 2018 (unas 38.000 granjas), publicado por Our World in Data. Se excluyen la energía de cocinado en casa y el desperdicio alimentario doméstico. Es un límite más amplio que el alcance solo operativo de la calculadora de transporte, así que nunca sumes cifras de las dos herramientas. Las cifras son las medias del estudio ponderadas por producción e incluyen las pérdidas de la cadena de suministro, no sus medianas, porque las medias representan mejor el impacto global total.\n\n### Una cifra, enorme dispersión\nEstas son medias globales por categoría. Un mismo alimento puede variar de 10 a 50 veces entre productores: la ternera va de unos 9 a 105 kg de CO2e por 100 g de proteína, y el tomate de 0,45 kg de CO2e/kg al aire libre y de temporada a 2,20 en invernadero con calefacción. Usa las cifras para comparar alimentos, no para juzgar una granja concreta.\n\n### Por qué no siempre declaramos una ganadora\nCada cifra de aquí es un promedio de miles de granjas, y esas granjas no se reparten de forma uniforme alrededor de él. Una minoría de productores de impacto muy alto empuja el promedio por encima de lo que sería una granja típica, y por eso el estudio publica también un valor intermedio: la cifra que deja la mitad de la producción mundial a cada lado. En la mayoría de los alimentos ambos valores quedan cerca. En algunos no: el chocolate negro promedia 46,65 kg CO2e/kg frente a un valor intermedio de 18,7, y el pescado de piscifactoría 13,63 frente a 5,1.\n\nUsamos los promedios, porque representan el impacto mundial total y no la granja típica. La consecuencia es que dos alimentos con cifras próximas pueden intercambiar posiciones según cuál de los dos valores se mire. Por eso esta herramienta solo afirma que una comida es mejor que otra cuando la diferencia llega al 20%; por debajo de eso muestra ambos totales y te deja la comparación a ti.\n\nEse 20% está comprobado, no elegido por comodidad. En todas las parejas de alimentos de aquí para las que el estudio publica ambas cifras, una diferencia del 20% o más apunta en la misma dirección con cualquiera de las dos. Hay tres excepciones, porque su propio promedio y su valor intermedio difieren en más del doble: el chocolate negro, el pescado de piscifactoría y los frutos secos de árbol. En esos casos ninguna diferencia es fiable, así que nunca se usan para declarar una ganadora. Y cuando la comparación cruza dos estudios distintos -- algunos alimentos de aquí se miden con una segunda fuente que abarca una cadena de suministro más corta -- exigimos que una comida emita menos de la mitad que la otra, porque una diferencia menor podría ser solo el reflejo de lo que cada estudio contabilizó.\n\n### \'Ecológico\' y \'local\'\nAquí no hay descuento por ecológico ni por local, y es deliberado. El transporte suele ser menos del 10% de la huella de un alimento, así que la \'ternera local\' sigue teniendo una huella mucho mayor que los \'frijoles importados\', y lo ecológico suele ser similar o mayor por kg. Lo que comes importa mucho más que la distancia que viajó o cómo se cultivó.';

  @override
  String get energyGroupHotWater => 'Agua caliente';

  @override
  String get energyGroupDishes => 'Lavar platos';

  @override
  String get energyGroupLaundryWash => 'Lavado de ropa';

  @override
  String get energyGroupLaundryDry => 'Secado de ropa';

  @override
  String get energyGroupSpaceHeat => 'Calefacción';

  @override
  String get energyGroupSpaceCool => 'Refrigeración';

  @override
  String get energyGroupBoil => 'Hervir agua';

  @override
  String get energyGroupCook => 'Cocinar';

  @override
  String get energyGroupLighting => 'Iluminación';

  @override
  String get energyGroupDevice => 'Dispositivos';

  @override
  String get energyPickerRecents => 'Usados recientemente';

  @override
  String get energyBehaviorScienceTooltip => 'De dónde viene este número';

  @override
  String get energyLowConfidenceNote => 'La cifra menos precisa de estos datos';

  @override
  String energyFactorPerMinute(String kwh) {
    return '$kwh kWh por minuto';
  }

  @override
  String energyFactorPerHour(String kwh) {
    return '$kwh kWh por hora';
  }

  @override
  String energyFactorPerUse(String kwh) {
    return '$kwh kWh por uso';
  }

  @override
  String energyFactorPerDay(String kwh) {
    return '$kwh kWh por día';
  }

  @override
  String get energyQuantityOneMinute => '1 minuto';

  @override
  String get energyQuantityOneHour => '1 hora';

  @override
  String get energyQuantityOneDay => '1 día';

  @override
  String energyQuantityMinutes(String units) {
    return '$units minutos';
  }

  @override
  String energyQuantityHours(String units) {
    return '$units horas';
  }

  @override
  String energyQuantityUses(String units) {
    return '$units x';
  }

  @override
  String energyQuantityDays(String units) {
    return '$units días';
  }

  @override
  String get energyScienceNoSources =>
      'Esta cifra no lleva cita, a propósito. Las notas de arriba explican por qué.';

  @override
  String get energyCalculatorTitle => 'Energía del hogar';

  @override
  String get energyAddUsage => 'Añadir';

  @override
  String get energyColumnEmptyHint =>
      'Añade algo que hagas en casa para crear esta rutina';

  @override
  String get energyNoPointsNote =>
      'Esta calculadora es para aprender. No otorga puntos ni registra nada.';

  @override
  String get energyPresetsLabel => 'Cantidades habituales';

  @override
  String get energyQuantityLabel => 'Cantidad';

  @override
  String get energyQuantityInvalid => 'Introduce un número mayor que cero';

  @override
  String energyComparisonDelta(
    String label,
    String amount,
    String worse,
    int percent,
  ) {
    return '$label usa $amount CO2e menos que $worse ($percent% menos)';
  }

  @override
  String energyComparisonRatio(String worse, String multiple, String label) {
    return '$worse emite $multiple veces el CO2e de $label';
  }

  @override
  String energyComparisonSavesEquiv(String amount, int charges) {
    String _temp0 = intl.Intl.pluralLogic(
      charges,
      locale: localeName,
      other: 'unas $charges cargas de móvil',
      one: 'una carga de móvil',
    );
    return 'Eso es $amount menos, $_temp0 de electricidad';
  }

  @override
  String energyComparisonSavesOnly(String amount) {
    return 'Eso es $amount menos';
  }

  @override
  String energyPhoneChargesEquiv(int charges) {
    String _temp0 = intl.Intl.pluralLogic(
      charges,
      locale: localeName,
      other: 'unas $charges cargas de móvil',
      one: 'una carga de móvil',
    );
    return 'Eso equivale a $_temp0 de electricidad';
  }

  @override
  String energyGridBasisNote(int grid) {
    return 'Las cifras en gramos asumen la red eléctrica media mundial, $grid g CO2e/kWh (Ember, datos de 2025)';
  }

  @override
  String energyGridBasisNoteRatio(int grid) {
    return 'Las cifras en gramos asumen la red eléctrica media mundial, $grid g CO2e/kWh (Ember, datos de 2025); el múltiplo vale en cualquier red';
  }

  @override
  String get energyMethodologyTitle => 'Metodología y fuentes';

  @override
  String energyMethodologyBody(int grid) {
    return 'Todas las cifras de esta herramienta son estimaciones para aprender, trazables hasta las fuentes del final.\n\n### Qué se cuenta\nSolo energía operativa: la electricidad o el gas que tu hogar usa mientras haces la actividad. Coincide con el criterio de la calculadora de transporte y difiere a propósito del de la de comida, que cuenta un ciclo de vida completo: nunca sumes resultados de las tres herramientas. El gas cuenta solo la combustión; el término del pozo al tanque (aproximadamente un +17%) se excluye por coherencia con transporte. Aquí no se otorgan puntos: los hábitos de energía se registran en el registro de acciones.\n\n### ¿Por qué un único número para todo el mundo?\nLa electricidad no es igual de limpia en todas partes. La misma secadora cuesta unos 0,6 kg de CO2e en la red británica, 1,9 kg en Japón y 3,1 kg en la India: una diferencia de cinco veces por una acción idéntica. De dónde viene tu electricidad (solar, eólica y nuclear, o carbón) puede importar tanto como lo que hagas con ella.\n\nConsideramos publicar un factor por país y decidimos no hacerlo. La precisión real exigiría tu país, tu región o compañía eléctrica (una sola media de EE. UU. esconde 26 subregiones) e incluso la hora del día, porque una red funcionando con solar de mediodía es mucho más limpia que la misma red en el pico de la tarde. Y todos esos números se mueven: el factor oficial del Reino Unido cayó un 26% en una sola revisión anual. Mantener cien cifras que caducan cada una a su ritmo es la mejor manera de equivocarse con confianza en cien sitios en vez de aproximar con honestidad en uno.\n\nAsí que hicimos tres cosas.\n\n**Una cifra global con fecha clara.** Usamos $grid g de CO2e por kWh, la media mundial de 2025 publicada por Ember. Es demasiado alta para el Reino Unido o Francia y demasiado baja para la India o Polonia, y lo decimos.\n\n**Comparaciones válidas para todos.** Casi todas las comparaciones aquí son entre dos cosas que usan el mismo tipo de energía: un baño contra una ducha, una secadora contra un tendedero, un lavado caliente contra uno frío. Ahí el factor de red se cancela por completo: un baño cuesta 2,3 veces una ducha de diez minutos en Glasgow, en Tokio o en Delhi. Los valores absolutos cambian con tu red; la comparación no.\n\n**Sin veredicto cuando tu red decide la respuesta.** Gas contra electricidad es la única comparación que de verdad se invierte. Por debajo de unos 241 g de CO2e por kWh gana calentar agua con electricidad; por encima, gana el gas. El Reino Unido ya está por debajo de esa línea; Japón, muy por encima. Mostramos ambos números y no declaramos ganador, porque la respuesta honesta depende de dónde vives, no de lo que hiciste.\n\nPara comprobar tu propia red, compara el factor que publican tu compañía eléctrica o las estadísticas oficiales de energía con el $grid de arriba, y sabrás hacia dónde se inclinan estos números en tu caso.\n\n### Dónde está el calor\nTodo lo que genera o mueve calor (duchas, baños, secado, calefacción y aire acondicionado) cuesta entre 20 y 670 veces más que lo que solo produce luz o computación; la lista ordenada de abajo lo muestra. El ventilador es la excepción del grupo de refrigeración: mueve aire, no calor, por alrededor de una octava parte del consumo por hora de un aire acondicionado. Una nevera consume alrededor de 1 kWh al día, pero no puedes acortarla como una ducha, así que no está en el selector; su etiqueta de eficiencia importa cuando la reemplazas.\n\nCuatro formas de calentar una habitación, sobre una misma base medida (METI), por hora:\n\n- Aire acondicionado (bomba de calor): 110 g CO2e\n- Estufa de gas: 181 g\n- Estufa de queroseno: 245 g\n- Calefactor eléctrico portátil (resistencia): 550 g\n\nUna bomba de calor emite unas 5 veces menos que un calefactor de resistencia, 1,6 veces menos que el gas y 2,2 veces menos que el queroseno. El queroseno gana a la resistencia eléctrica pero pierde con claridad frente a la bomba de calor: por eso las cuatro se muestran siempre juntas.\n\n### Medido, no nominal\nLas cifras del aire acondicionado son medias medidas de una hora de uso real (Energy Conservation Center vía METI); el valor de catálogo es unas 2,5 veces mayor porque se mide a plena carga. La del kotatsu es la medición termostatada de los propios fabricantes: unas 8 veces menos que un calefactor portátil, y la cifra menos segura de este conjunto de datos. Los ajustes de temperatura se limitan a ±2 °C: la regla práctica habitual dice un 13% (frío) / 10% (calor) por grado (Ministerio de Medio Ambiente de Japón), mientras que las mediciones de METI implican 15,2% / 12,6%; trata el ahorro por grado como aproximado, no lineal.\n\n### El standby, con honestidad\nEl consumo en espera por aparato cayó de 1-3 W a unos 0,5 W, pero el número de aparatos creció más deprisa: los hogares usan «aproximadamente la misma energía en espera, ahora repartida entre muchos más productos» (Lawrence Berkeley National Laboratory). El standby ni es trivial ni es el 10% de tu factura.\n\n### Iluminación\nLas cifras de apagar la luz asumen un LED de 8,5 W: unos 15 g por cuatro horas. Con una bombilla incandescente esas mismas cuatro horas son unos 110 g, y cambiar la bombilla ahorra mucho más que apagarla.\n\n### Emisiones evitadas\nLas acciones de segunda mano del registro (un coche usado, ropa de segunda mano, la biblioteca) premian la decisión de no comprar nuevo. Que dos personas se apunten la misma fabricación evitada es coherente; sumar esos créditos no lo es, porque la fabricación ocurrió una sola vez.';
  }

  @override
  String get energyRankedTitle => 'A dónde va tu energía';

  @override
  String get energyRankedIntro =>
      'Un uso típico de cada hábito, de mayor a menor, como múltiplo de la energía de una hora de luz LED. Cada fila indica bajo el nombre su propia base (un uso, una hora o un día). Esto ordena la energía consumida, que es la parte que deciden tus hábitos.';

  @override
  String get energyRankedGasNote =>
      'Los aparatos de gas están en la misma lista, porque aquí se ordena la energía. Ojo a un detalle: un calentador de gas usa más energía que uno eléctrico para el mismo baño y, aun así, con la red media mundial de hoy emite menos. Por debajo de unos 241 g de CO2e por kWh eléctrico se invierte y gana la electricidad. La energía que usas es lo que eliges tú; lo limpia que sea la red depende de tu país y mejora cada año.';

  @override
  String energyRankedMultiple(String multiple) {
    return '${multiple}x';
  }

  @override
  String get energyComparisonNoVerdict => 'Aquí no hay un ganador';

  @override
  String get energyVerdictWhyCta => '¿Por qué no?';

  @override
  String get energyVerdictDifferentGroup =>
      'Son dos cosas de distinto tipo, así que decir que una es mejor sería un error de categoría. Compara lo comparable: un baño con una ducha, una secadora con un tendedero.';

  @override
  String get energyVerdictDifferentCarrier =>
      'Una funciona con gas y la otra con electricidad, y cuál resulta más limpia depende de la red eléctrica de tu zona, no de lo que hiciste. Por debajo de unos 241 g CO2e por kWh gana la eléctrica; por encima, el gas. Por eso se muestran ambas cifras sin declarar un ganador.';

  @override
  String energyVerdictTooClose(int percent) {
    return 'La diferencia entre ambas es de menos del $percent%, dentro de la precisión de las mediciones de origen. Declarar un ganador sería atribuir una exactitud que las fuentes no tienen.';
  }

  @override
  String get energyUnitSuffixMinute => 'min';

  @override
  String get energyUnitSuffixHour => 'h';

  @override
  String get energyUnitSuffixUse => 'usos';

  @override
  String get energyUnitSuffixDay => 'días';

  @override
  String energyExploreIntro(String anchorUnit) {
    return 'Un uso típico de cada hábito, de mayor a menor, como múltiplo de la energía de $anchorUnit. Ordena la energía consumida, y los múltiplos valen en cualquier red.';
  }

  @override
  String get energyExploreBarNote =>
      'Las barras usan una escala de raíz cuadrada para que las filas más pequeñas sigan visibles. Compara los números, no las barras.';

  @override
  String get energyAnchorChipLedBulb => 'LED 1 h';

  @override
  String get energyAnchorChipPhoneCharge => 'Móvil 1 carga';

  @override
  String get energyAnchorChipKettle => 'Hervidor 1 L';

  @override
  String get energyAnchorChipFan => 'Ventilador 1 h';

  @override
  String get energyAnchorUnitLedBulb => 'una hora de luz LED';

  @override
  String get energyAnchorUnitPhoneCharge => 'una carga completa de móvil';

  @override
  String get energyAnchorUnitKettle => 'un litro hervido en el hervidor';

  @override
  String get energyAnchorUnitFan => 'una hora de ventilador';

  @override
  String energyExploreSheetMultiple(String multiple, String anchorUnit) {
    return '${multiple}x $anchorUnit';
  }

  @override
  String energyExploreWallCaptionOne(String anchorUnit) {
    return 'Cada icono es $anchorUnit';
  }

  @override
  String get quizTitle => '¿Más o menos?';

  @override
  String get quizQuestion => 'Arrastra arriba la de mayor huella';

  @override
  String get quizBasisEnergy => 'Energía del hogar: un uso típico';

  @override
  String get quizBasisFood => 'Comida: una ración';

  @override
  String get quizBasisTransport => 'Transporte: un pasajero-kilómetro';

  @override
  String get quizNoteFood =>
      'Las cifras de comida son medias de ciclo de vida de la cuna al comercio (Poore y Nemecek, 2018) por ración.';

  @override
  String get quizNoteTransport =>
      'Las cifras de transporte son por pasajero-kilómetro con ocupación media; caminar e ir en bici cuentan como cero.';

  @override
  String quizPerKm(String amount) {
    return '$amount por km';
  }

  @override
  String get quizHigher => 'Más';

  @override
  String get quizLower => 'Menos';

  @override
  String get quizCorrect => '¡Correcto!';

  @override
  String get quizWrong => 'Esta vez no';

  @override
  String quizStreakLabel(int count) {
    return 'Racha: $count';
  }

  @override
  String quizBestLabel(int count) {
    return 'Mejor: $count';
  }

  @override
  String get quizContinue => 'Seguir';

  @override
  String get quizNewRun => 'Empezar de nuevo';

  @override
  String get quizLadderHeading => 'Tarjetas reveladas';

  @override
  String get quizNoPointsNote =>
      'Solo por diversión. No da puntos ni registra nada.';
}
