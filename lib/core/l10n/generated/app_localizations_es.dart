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
      'Emisiones del ciclo de vida completo de una hamburguesa de carne, desde la ganadería hasta el comercio. Las hamburguesas de pollo o vegetales emiten entre 5 y 10 veces menos.';

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
}
